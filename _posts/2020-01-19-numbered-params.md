---
layout: post
title: Numbered Parameters in Ruby 2.7
date: 2020-01-19 20:40
categories: ruby 2.7 numbered_params
tags: ruby 2.7 numbered_params
summary: Knowing and understanding this sugar feature
description: Knowing and understanding this sugar feature
image: https://res.cloudinary.com/linqueta/image/upload/v1579472034/numbered-params_h5zimc.png
---

<style>
img[alt=image]{
  border-radius: 10px;
}
</style>

![image]({{ page.image }})

We had recently a new [release](https://www.ruby-lang.org/en/news/2019/12/25/ruby-2-7-0-released/) of Ruby (MRI) and it brought many features. One of them is a sugar feature to improve the quality of your code, turn easy to write blocks and follow what other programming languages have released.

## Numbered Parameters

Before this feature, we write blocks in these ways:

- Extensive variable name:

<script src="https://gist.github.com/linqueta/4f5e65ca77688de5395b21f7525ecf67.js"></script>

- Not understandable variables name:

<script src="https://gist.github.com/linqueta/c35c3b1a1eeb250120ac6124a2ee5be7.js"></script>

- Just a char name (it's not understandable too):

<script src="https://gist.github.com/linqueta/94c54cb78b9b27b960cc996b85bd19eb.js"></script>

And using **Numbered Parameters**:

<script src="https://gist.github.com/linqueta/c82c5bc91ce7506cdbf10d59c962f6ba.js"></script>

This feature decreases the params' name length and turns simple to understand the order of the params compared with return of the last block or the last method called.

### Mistake

Numbered Params is nice but it has a some mistake. When you have a block and you have to call a block method inside this block, Numbered Parameters doesn't work as well. Example:

<script src="https://gist.github.com/linqueta/ddefadf3f217d7793ed1a47beab64335.js"></script>

It's an unusual example but it explains you have to choose in what block you will use the numbered parameters.