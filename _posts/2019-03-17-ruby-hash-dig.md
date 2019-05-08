---
layout: post
title: The method dig in Ruby
date: 2019-03-17 18:00
categories: ruby hash dig
summary: The why you should consider to use it for complex Hashes
description: The why you should consider to use it for complex Hashes
tags: ruby hash dig
image: https://res.cloudinary.com/linqueta/image/upload/v1556245128/dig.jpg
---

![image]({{ page.image }})

The Ruby version 2.3.0 released on final of 2015 brought some interesting features that many Ruby programmers don't know some parts of this. One of the many features introduced is the method `dig`, included on Array and Hash libs. In this post, we will to talk about the method `dig` for Hashes.

### For the Hash bellow:
<script src="https://gist.github.com/linqueta/80e910d400c860b7eaebb5d703c0a653.js"></script>

Ruby has three ways to get data from a Hash object:
1. `dig`
2. `[]`
3. `fetch`

### To get data using `dig`:
<script src="https://gist.github.com/linqueta/4e7e3542fd298b63dfc1adf5c5f78856.js"></script>

Using the method `dig` is very simple to get data, just put the name of the keys on the params. If the key value is a Hash object, you may get a value from this nested hash, just pass one more param with the key name. Therefore, this name is _dig_, like digger worker, because the diggers dig holes to get anything, in this case, to get key value from Hash object.

An interesting point about the method `dig` is that it rescues from `NoMethodError`, when the previous key value is nil and it's trying to get the next key value. Other ways to get data from Hash object raise errors when happen this situation.

### To get data using `[]`:
<script src="https://gist.github.com/linqueta/6881e37b8e86987bc1bf88e02cf45925.js"></script>

How described above, the native method for to get data from a Hash object (`[]`) doesn't rescue when the previous Hash object is null, raising a `NoMethodError`. If your code doesn't prevent this error, your program may be crashed.

### To get data using `fetch`:
<script src="https://gist.github.com/linqueta/3f7e3fc92428b51fc7f1945ed3fcff77.js"></script>

Using `fetch` we have more errors than the last methods.`KeyError` happens when the key is not present in the Hash object and when there is a another class in the previous value, like `nil` or anything except Hash object, it raised a `NoMethodError`.

### Ways to rescue from errors
<script src="https://gist.github.com/linqueta/14bc84544aa381da26ea79cc8432590d.js"></script>

### And about perfomance...

##### 1. Get data in the first level without treating for errors
<script src="https://gist.github.com/linqueta/086bfd19f2bb9496ca8366fd1043c2b1.js"></script>

##### 2. Get data in the third level without treating for errors
<script src="https://gist.github.com/linqueta/5170cd6c9c5bb712ea9c4c10e4bc3d77.js"></script>

##### 3. When an error isn't raised with treating for errors
<script src="https://gist.github.com/linqueta/ab5077b215cbba20eb6f76095882ab2a.js"></script>

##### 4 .When an error is raised with treating for errors
<script src="https://gist.github.com/linqueta/c4ebc823dbac7069ca0668f438489de9.js"></script>

### Why you should consider to use it for complex Hashes?

The method `dig` has three main benefits to use it, they are:

- Easy
- Safe
- Fast

#### Easy
It's simple because you just need to pass as param all keys to get the value of the last key passed.

#### Safe
It's safer than others because `dig` doesn't raise an error when the key or the previous key isn't present.

#### Fast
In two of four cases (showed above), it's faster than others to get data without errors, mainly when the number of nested hashes is big. In one case, when using `dig` to get data on a three level, it had the same performance than `[]`. Only to access data in the first level, `dig` is slower than `[]`.

### Fonts

- https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/
- https://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig
