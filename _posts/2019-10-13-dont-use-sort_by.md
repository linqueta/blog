---
layout: post
title: Don't use sort_by, use only sort!
date: 2019-10-13 18:03
categories: ruby sort sort_by reverse sorting
summary: Mainly if you'll use reverse after!
description: Mainly if you'll use reverse after!
tags: ruby sort sort_by reverse sorting
image: https://res.cloudinary.com/linqueta/image/upload/v1568776002/healthcheck_ypelrf.png
---

![image]({{ page.image }})

Nowadays, I'm a Tech lead at Petlove and during the week I've interviewed many candidates that they're applied for backend position, mainly using Ruby and Rails. When I review theirs tests for our jobs and sometimes I catch many mistakes, and I think the principal is when the candidates use the method `sort_by` and the sequence `sort_by(&:any_attribute).reverse`. I've always searched about these candidates in Github and Linkedin and almost half have between 2 and 3 years about Ruby and Ruby on Rails experience and they keep doing this mistake.

I'm certified in the program [Ruby Association Certified Ruby Programmer Silver](https://www.credential.net/3kwsc6bh), but the best thing that it brought for me was the knowledge that I got when I read documentations, api docs and books about *Ruby*, mainly the book [The Ruby Programming Language: Everything You Need to Know](https://www.amazon.com/Ruby-Programming-Language-Everything-Need/dp/0596516177). Nowadays, this book is outdated, but it bring many important things that you have to know to develop an application using correct methods for determinate situations.

About the method `sort_by`, I think that the developers using because is easier to use than the method `sort`, but I also think that these people don't know how `sort_by` is slower than just `sort`. In the [official documentation](https://ruby-doc.org/core-2.6.5/Enumerable.html#method-i-sort_by) was explained about the problem, but I'll explain here too.

Using an array with 100 people:

```ruby
class Person
  attr_accessor :name, :weight

  def initialize(name:, weight:)
    @name = name
    @weight = weight
  end
end

require 'faker'

def people
  @people ||= (1..100).map { Person.new(name: Faker::Name.name, weight: rand(55..95)) }
end
```

And I`d like to get this array sorted ascendent by the people's weight. To do it, I can get it with two ways.

- Using the method `sort_by`:

```ruby
module SortBySorter
  module_function

  def by_weight_asc(people)
    people.sort_by(&:weight)
  end
end
```

- Using the method `sort`:

```ruby
module SortSorter
  module_function

  def by_weight_asc(people)
    people.sort { |a, b| a.weight <=> b.weight }
  end
end
```

Both return the expected result, so, the performance among them aren't the same.

```ruby
# ...
```

How I said before in the introduce, using the method `sort_by` to sort is almost three times slowed than `sort`. Now, imagine