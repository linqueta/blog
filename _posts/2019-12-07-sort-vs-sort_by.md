---
layout: post
title: Sort or sort_by? Which one do I have to use?
date: 2019-12-07 12:00
categories: ruby sort sort_by reverse sorting performance
summary: Knowing the better way to sort arrays in Ruby
description: Knowing the better way to sort arrays in Ruby
tags: ruby sort sort_by reverse sorting performance
image: https://res.cloudinary.com/linqueta/image/upload/v1575748703/0f0f0f_acn6wk.png
---

![image]({{ page.image }})

## TL;DR

- The method `sort` is faster when you sort just primary type objects (like an array of String, Number, Integer, Time, ...) without block:

<script src="https://gist.github.com/linqueta/0333ea3b7fea69bc199cb60a23f981eb.js"></script>

- For everything else are better to use `sort_by`:

<script src="https://gist.github.com/linqueta/f5ca34e7783c1348f61350e72d2abc73.js"></script>

- For both methods, to sort reversing elements of an array is faster using the Enumerator's method `reverse`:

<script src="https://gist.github.com/linqueta/36bb652d4ceba70ca6e863ba514a1918.js"></script>

### Why I wrote this post?

Nowadays, I'm a tech lead at [Petlove](https://www.petlove.com.br) and during the week I've interviewed many candidates for backend positions, mainly for Ruby and Rails positions. Sometimes I've caught many mistakes when I review their tests and these mistakes many times are the wrong use of `sort` and  `sort_by`. I've decided to make this post to ensure when you have to use these methods. Also, I'll talk (or write) about how to sort reversing arrays with Ruby. The main purpose here is performance among these methods.

Using two arrays with 100000 elements each one:

<script src="https://gist.github.com/linqueta/edd281188c7e499035e42e6b1f098b51.js"></script>

### Sorting the numbers array

For the first test, we'll sort the `numbers` array ascending:

<script src="https://gist.github.com/linqueta/f4d77b71feaebdcebb6cf4dd2f149142.js"></script>

#### Who wins here?

So, as we can see the better way to sort a primary type object array is using the method `sort`, but, it's important to remember that when use block to compare the positions, it's worse than `sort_by`. So, for the method `sort`, **do not** use block.

### Sorting the custom_numbers array

Now to sort the `custom_numbers` array by the accessor `value` we will repeat almost the same benchmark test:

<script src="https://gist.github.com/linqueta/eec3cbae2bae6d6fa1f35b49e0e12639.js"></script>

#### Who wins here?

Here we have a completely different result. The class `CustomNumber` implements the method `<=>` to be able to compare through the mixin `Comparable` and because it we can use just `sort`. But, as we can see, it returns the worst result at the tests. So, for complex types, using `<=>` through `sort` is worse than use `sort_by` with a block.

### Conclusion about sort and sort_by

If you have a primary type object arrays, use just `sort` and if you have to access an accessor or method inside a class' instance, you should use `sort_by`.

### Sorting desc arrays

Now you know what is the better way to sort these kinds of arrays, so, we have to know also how is the better way to sort reverting the order of elements. We can use four different ways:

<script src="https://gist.github.com/linqueta/ea215aeed77445bc1096f865b834b221.js"></script>

The benchmark's result points that the method `reverse` after the better sort method ensures the best performance. For complex arrays, you can use use the method `sort_by` negativing the value, but, it's nothing clean. So, use `reverse` and be happy.

### By the author

After I made this post, I'm feeling a better person to judge (or almost it) the next pull requests (I'm kidding). I hope that it helps you when you'll code something that requires to be sorted.

