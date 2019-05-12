---
layout: post
title: The Safe Navigation operator (&.)
date: 2019-05-12 17:00
categories: ruby safe_navigation
summary: What you should know before you use this operator!
description: What you should know before you use this operator!
tags: ruby safe_navigation
image: https://res.cloudinary.com/linqueta/image/upload/v1556244754/safe_navigation.jpg
---

![image]({{ page.image }})

As the [dig](https://linqueta.com/ruby/hash/dig/2019/03/17/ruby-hash-dig), the Ruby version 2.3.0 brought the Safe Navigation operator (`&.`). It isn't so known, but it may help you to write code more clear than others ways, however, you should be careful because the Safe Navigation operator may raise some errors and it doesn't work as expected in some moments. In this post, I will explain how it works and the its pros and cons.

#### The problem
##### Using these models:
<script src="https://gist.github.com/linqueta/a03f58654c05fbc57a4b9ca3c7fe24b2.js"></script>

##### Setting the order:
<script src="https://gist.github.com/linqueta/3e436a59ae6af6a6e44e64f68aef12e8.js"></script>

##### Checking if the user's wallet is active and getting order's channel's name:
<script src="https://gist.github.com/linqueta/e2d44248b7b697caf3c6c52983a8b5e1.js"></script>

##### You may use the Safe Navigation operator operator to do the same with less code:
<script src="https://gist.github.com/linqueta/144605b3c866e0d15dffe7cca4112a17.js"></script>

How to showed above, using (`&.`) requires less code to get the data and is clearer than use the operator (`&&`) or `try`. The [Rubocop](https://github.com/rubocop-hq/rubocop) gem suggests to use the [Safe Navigation](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Rails/SafeNavigation) operator in these cases as a good pattern. However, some mistakes may exists, they are:

##### The method nil? returning incorrect value:
<script src="https://gist.github.com/linqueta/3709b91484f4e484631c60f8dc89ff45.js"></script>

When there is a `nil` value and we use the operator (`&.`) to check if it's `nil`, the Safe Navigation operator prevents from be raised a NoMethodError returning `nil`, but the correct value should be `true`.

##### When there is incorrect instance in some accessor:
<script src="https://gist.github.com/linqueta/d033f75adbc9eaed8341701f7293c9b3.js"></script>

When there is  a value not expected different from a `nil` in an accessor and we try to get some accessor from this accessor, the Safe Navigation operator doesn't prevent to be raised a NoMethodError, because the value isn't a `nil` as have been showed above.

#### About performance...
##### Getting data from a non nil value
<script src="https://gist.github.com/linqueta/8818dc9478866d0a839ec5a95169ba19.js"></script>

##### Getting data from a nil value
<script src="https://gist.github.com/linqueta/095897bf84ca2499a37a988516d56df7.js"></script>

In both tests the Safe Navigation operator is faster than `try` and `&&`. In the first test, the operator `&.` is 1.5x faster than `&&`. The method `try` have been the slowest in the tests.

#### Final words

The Safe Navigation operator is a good way to get data in nested accessors, because it requires less code and is faster and clearer than others ways. Although there are many pros points, is imporant to remmenber that there are mistakes using it, as incorrect return using the method `nil?` and non rescue from NoMethodError when the value is non nil.

#### Fonts

- https://github.com/ruby/ruby/commit/a356fe1c3550892902103f66928426ac8279e072
- https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/