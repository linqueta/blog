---
layout: post
title: How to test your gem in a Rails application
date: 2020-02-02 19:00
categories: ruby rspec rails tests dummy
tags: ruby rspec rails tests dummy
summary: Learning how to create a dummy Rails app into your gem's tests
description: Learning how to create a dummy Rails app into your gem's tests
image: https://fakeimg.pl/950x300/?text=dummy%20tests
---

<style>
img[alt=image]{
  border-radius: 10px;
}
</style>

![image]({{ page.image }})

Many gems in [RubyGems](https://rubygems.org/) require Rails to work as well and many of them are developed to use together with a Rails application like a [plugin](https://guides.rubyonrails.org/plugins.html). How is known, the best way to ensure that some code is working as well is writing unit tests for it. But, for gems that depend or work together Rails, there is a nice way to test it into a Rails application, the name of it is **Dummy tests**.

The meaning of the word dummy is a kind of mannequin or replica of humans, but in ruby context, it's a kind of scope for you test your gem, in this case, a Rails application. I've added recently dummy tests in my gem [rails-healthcheck](https://github.com/linqueta/rails-healthcheck) in this [pull request](https://github.com/linqueta/rails-healthcheck/pull/26) to check if this gem is rightly imported and have responded in success and failure cases as is waited.

These are the steps to add dummy tests into your gem using RSpec:

### Create a Rails application into folder /spec:

```shell
rails new spec/dummy --skip-gemfile --skip-git --api
```

### Require your gem in the dummy application:

A Rails application will require all gems into Gemfile's environments blocks using bundler, but, here we wanna test your local gem:

<script src="https://gist.github.com/linqueta/a29c40beb3712ebdb5e046e6b0b342ef.js"></script>

If your gem requires to run some setup, it's the moment to do it.

### Add the gem [rspec-rails](https://github.com/rspec/rspec-rails) as a development dependency:

<script src="https://gist.github.com/linqueta/a84e5a108ec91412ec6ff9cb11d15d1a.js"></script>

### Require dummy files and rspec-rails in tests:

<script src="https://gist.github.com/linqueta/f310f109c52a69c8410b6a1c05b9f342.js"></script>

### Code your test:

For this example, my gem provides the method `rgb_to_hex` and it is used in the dummy's model Color. This model has the attributes red, green and blue.

<script src="https://gist.github.com/linqueta/2d861a2406d07a4b8efee52fbee2d113.js"></script>

### Run rspec to test them:

```shell
rspec spec/color_spec.rb # or just rspec for all tests

# Color
#   #configure
#     with Dim Gray color
#       is expected to eq "3B3638"
#     with White Smoke color
#       is expected to eq "F9F7F7"
# Finished in 0.05234 seconds (files took 3.83 seconds to load)
# 2 examples, 0 failures
```

This example is so basic, but with dummy test you can test routes, controllers, helpers any what you want in a Rails application, for example, in the gem  rails-healthcheck was tested all responses of `Healthcheck::HealthcheckController#check` mounted in the route `/healthcheck` or any route set in the initializer.
