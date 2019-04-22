---
layout: post
title: Ruby - The dig method
date: 2019-03-17 18:00
categories: ruby hash dig
summary: Easy, safe and fast way to get data from Hash object
description: Easy, safe and fast way to get data from Hash object
tags: ruby hash dig
---

![excavator]({{ site.baseurl }}/images/excavator.jpeg)

The Ruby version 2.3.0 released on final of 2015 brought some interesting features that many Ruby programmers don't know some parts of this. One of the many features introduced is the `dig` method, included on Array and Hash libs. In this post, we will to talk about Hash `dig` method.

### For the Hash bellow:
```ruby
payment = {
  credit_card: {
    final_numbers: '6789',
    month: '1010',
    year: '2020',
    brand: {
      display_name: 'Visa',
      name: 'visa_payment'
    }
  },
  billet: nil,
  amount: 50.0
}
```

Ruby has three ways to get data from a Hash object:
1. `dig`
2. `[]`
3. `fetch`

### To get data using `dig`:
```ruby
amount = payment.dig(:amount)
# => 50.0

brand_display_name = payment.dig(:credit_card, :brand, :display_name)
# => "Visa"

voucher = payment.dig(:voucher)
# => nil

billet = payment.dig(:billet)
# => nil

billet_number = payment.dig(:billet, :number)
# => nil
```

Using the `dig` method is very simple to get data, just put the name of the keys on the params. If the key value is a Hash object, you may get a value from this nested hash, just pass one more param with the key name. Therefore, this name is _dig_, like digger worker, because the diggers dig holes to get anything, in this case, to get key value from Hash object.

An interesting point about the `dig` method rescue from `NoMethodError`, when the previous key value is nil and is trying to get the next key value. Other ways to get data from Hash object raise errors when happen this situation.

### To get data using `[]`:
```ruby
amount = payment[:amount]
# => 50.0

brand_display_name = payment[:credit_card][:brand][:display_name]
# => "Visa"

billet = payment[:billet]
# => nil

voucher = payment[:voucher]
# => nil

billet_number = payment[:billet][:number]
# => NoMethodError (undefined method `[]' for nil:NilClass)
```

How described above, the native method for to get data from a Hash object (`[]`) not rescue when the previous Hash object is null, raising a `NoMethodError`. If your code doesn't prevent this error, your program may be crashed.

### To get data using `fetch`:
```ruby
amount = payment.fetch(:amount)
# => 50.0

brand_display_name = payment.fetch(:credit_card).fetch(:brand).fetch(:display_name)
# => "Visa"

billet = payment.fetch(:billet)
# => nil

voucher = payment.fetch(:voucher)
# => KeyError (key not found: :voucher)

billet_number = payment.fetch(:billet).fetch(:number)
# => NoMethodError (undefined method `fetch' for nil:NilClass)
```

Using `fetch` we have more errors than the last methods.`KeyError` happens when the key is not present in the Hash object. Also, when there is a another class in the previous value, like `nil` or anything, is raised a `NoMethodError`.

### Ways to rescue from errors
```ruby
billet_number = (payment[:billet] || {})[:number]
# => nil

billet_number = payment[:billet].to_h[:number]
# => nil

voucher = payment.fetch(:voucher) { nil }
# => nil

billet_number = payment.fetch(:billet) { {} }.fetch(:number){ nil }
# => nil
```

### And about perfomance...

#### Without treating for errors
- To get data into the first level

```ruby
  require 'benchmark/ips'

  Benchmark.ips do |x|
    x.report('using dig')   { payment.dig(:amount) }
    x.report('using []')    { payment[:amount] }
    x.report('using fetch') { payment.fetch(:amount) }

    x.compare!
  end

  # Warming up --------------------------------------
  #           using dig    226.750k i/100ms
  #            using []    250.329k i/100ms
  #         using fetch    229.523k i/100ms
  # Calculating -------------------------------------
  #           using dig    6.849M (± 1.8%) i/s -     34.239M in   5.000971s
  #            using []    7.582M (± 2.1%) i/s -     38.050M in   5.020581s
  #         using fetch    6.465M (± 1.6%) i/s -     32.363M in   5.007088s

  # Comparison:
  #           using []:    7582481.0 i/s
  #          using dig:    6848850.2 i/s - 1.11x  slower
  #         sing fetch:    6465160.0 i/s - 1.17x  slower
```

- To get data in the third level

```ruby
  require 'benchmark/ips'

  Benchmark.ips do |x|
    x.report('using dig')   { payment.dig(:credit_card, :year, :display_name) }
    x.report('using []')    { payment[:credit_card][:brand][:display_name] }
    x.report('using fetch') { payment.fetch(:credit_card).fetch(:brand).fetch(:display_name) }

    x.compare!
  end

  # Warming up --------------------------------------
  #          using dig   199.604k i/100ms
  #           using []   214.580k i/100ms
  #        using fetch   185.720k i/100ms
  # Calculating - ------------------------------------
  #          using dig   4.796M (± 2.7%) i/s -     24.152M in   5.039771s
  #           using []   4.998M (± 1.8%) i/s -     25.106M in   5.025192s

  #        using fetch   3.857M (± 2.0%) i/s -     19.315M in   5.009446s
  # Comparison:
  #          using []:   4997633.8 i/s
  #         using dig:   4796139.0 i/s - same-ish: difference falls within error
  #       using fetch:   3857276.5 i/s - 1.30x  slower
```

#### With treating for errors
- When an error isn't raised

```ruby
  require 'benchmark/ips'

  Benchmark.ips do |x|
    x.report('using dig')               { payment.dig(:credit_card, :brand, :display_name) }
    x.report('using [] and || {}')      { ((payment[:credit_card] || {})[:number] || {})[:display_name] }
    x.report('using [] and to_h')       { payment[:credit_card].to_h[:number].to_h[:display_name] }
    x.report('using fetch and default') { payment.fetch(:credit_card) { {} }.fetch(:brand) { {} }.fetch(:display_name) { nil }}

    x.compare!
  end

  # Warming up --------------------------------------
  #             using dig        203.927k i/100ms
  #     using [] and || {}       181.964k i/100ms
  #     using [] and to_h        182.159k i/100ms
  #   using fetch and default    188.631k i/100ms
  # Calculating -------------------------------------
  #             using dig        4.878M (± 2.1%) i/s -     24.471M in   5.019222s
  #     using [] and || {}       3.968M (± 1.7%) i/s -     20.016M in   5.046547s
  #     using [] and to_h        3.479M (± 2.6%) i/s -     17.487M in   5.030772s
  #   using fetch and default    3.757M (± 2.8%) i/s -     18.863M in   5.025237s

  # Comparison:
  #                 using dig:   4877899.3 i/s
  #        using [] and || {}:   3967526.2 i/s - 1.23x  slower
  #   using fetch and default:   3756891.9 i/s - 1.30x  slower
  #         using [] and to_h:   3478660.5 i/s - 1.40x  slower
```

- When an error is raised

```ruby
  require 'benchmark/ips'

  Benchmark.ips do |x|
    x.report('using dig')               { payment.dig(:credit_card, :owner, :document) }
    x.report('using [] and || {}')      { ((payment[:credit_card] || {})[:owner] || {})[:document] }
    x.report('using [] and to_h')       { payment[:credit_card].to_h[:owner].to_h[:document] }
    x.report('using fetch and default') { payment.fetch(:credit_card) { {} }.fetch(:owner) { {} }.fetch(:document) { nil }}

    x.compare!
  end

  # Warming up --------------------------------------
  #                  using dig   206.609k i/100ms
  #         using [] and || {}   183.440k i/100ms
  #          using [] and to_h   178.323k i/100ms
  #    using fetch and default   137.485k i/100ms
  # Calculating -------------------------------------
  #                  using dig   4.795M (± 8.8%) i/s -     23.760M in   5.006556s
  #         using [] and || {}   3.900M (± 5.7%) i/s -     19.445M in   5.005244s
  #          using [] and to_h   3.476M (± 2.6%) i/s -     17.476M in   5.030683s
  #    using fetch and default   2.351M (± 2.0%) i/s -     11.824M in   5.031040s

  # Comparison:
  #                 using dig:   4794518.8 i/s
  #        using [] and || {}:   3899954.6 i/s - 1.23x  slower
  #         using [] and to_h:   3476385.0 i/s - 1.38x  slower
  #   using fetch and default:   2351157.5 i/s - 2.04x  slower
```

### Conclusion

The `dig` method has three main benefits for use it, they are:

- Easy
- Safe
- Fast

#### Easy
It's simple because you just need to pass as param all keys for to get the value of the last key passed.

#### Safe
It's safer than others because `dig` doesn't raise an error when the key or the previous key isn't present.

#### Fast
In two of four cases (showed above), it's faster than others to get data without errors, mainly when the number of nested hashes is big. In one case, when using `dig` to get data on a three level, it had the same performance than `[]`. Only to access data in the first level, `dig` is slower than `[]`.

### Fonts

- https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/
- https://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig
