---
layout: post
title: Sort vs sort_by? Which one do I have to use?
date: 2019-12-07 12:00
categories: ruby sort sort_by reverse sorting performance
summary: Knowing the better way to use each one!
description: Knowing the better way to use each one!
tags: ruby sort sort_by reverse sorting performance
image: https://res.cloudinary.com/linqueta/image/upload/v1575736090/0f0f0f_mvk6zl.png
---

![image]({{ page.image }})

## TL;DR

- The method `sort` is faster when you sort just primary types (like an array of String, Number, Integer, Time, ...) non using blocks to catch the param like:

```ruby
strings = ('a'..'z').to_a.shuffle
# => An array from letter a to z shuffled

strings.sort
# => ["a", "b", "c", "d", "e", "f", ...]
```

- For everything else using blocks is better to use `sort_by`:

```ruby
class MyNumber
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

my_numbers = (1..26).to_a.shuffle.map { |i| MyNumber.new(i) }
# => An array of MyNumber from 1 to 26 values shuffled

my_numbers.sort_by(&:value) # is the same as my_numbers.sort_by { |my_number| my_number.value }
# => [#<MyNumber:0x00007f887114d538 @value=1>, #<MyNumber:0x00007f887114d678 @value=2>, ...]
```

- For both methods, to reverse an array is faster using the Enumerator's method `reverse` instead use blocks:

```ruby
strings.sort.reverse
# => ["z", "y", "x", "w", "v", "u", ...]

my_numbers.sort_by(&:value).reverse
# => [#<MyNumber:0x00007f88730271c0 @value=26>, #<MyNumber:0x00007f8873027198 @value=25>, ...]
```

---

### Motivation

Nowadays, I'm a Tech lead at Petlove and during the week I've interviewed many candidates that they're applied for backend position, mainly using Ruby and Rails. When I review theirs tests for our jobs and sometimes I catch many mistakes, and sometimes I've seen the candidates using `sort` where they have to use `sort_by` and the opposite to. I've decided to make this post to ensure where you have to use the method `sort` and `sort_by`. Also, I'll talk (or write) about how to reverse arrays with Ruby. The main purpose here is performance among this methods.

Using two arrays with 100000 elements each one:

```ruby
class MyNumber
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

my_numbers = (1..100000).to_a.shuffle.map { |i| MyNumber.new(i) }
numbers = (1..100000).to_a.shuffle
```

Now, we will sort them ascending:

```ruby
require 'benchmark'
require 'benchmark/ips'


```
