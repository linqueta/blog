---
layout: post
title: Using UUID as a primary key in Ruby on Rails
date: 2019-05-12 17:00
categories: rails uuid active_record
summary: Make strong and secure ids for your models!
description: Make strong and secure ids for your models!
tags: rails uuid active_record
image: https://res.cloudinary.com/linqueta/image/upload/v1558403259/keys_ygx9qv.jpg
---

![image]({{ page.image }})

When we create a model in Rails, most specifically using the ActiveRecord through a migration, is common to use a id field as primary key. This field has the some resposabilities:
  - Identify the record
  - Allow that other models refer to this record

But, as default, the Ruby on Rails framework, main ActiveRecord uses sequencial number in this field id. It's common on relational databases, there is a structure called Sequence responsible to give a new sequencial number when a new model record is created. But this pattern to make primary key number may bring some problems:
  - Easy prediction previous and next ids
  - Centralized database to make sequece numbers

#### Do you know what is UUID?
- Explanation
- Why use it
- Commons applications

#### The library Secure Random

#### Using UUID as a primary key in a project

 - Create the project
 - Set extensions
 - Set generator
 - create book model
 - create author model
 - create reference between book and author
 - belongs and has many
 - default_scope

### Compare performance beetween UUID create, find, joins

### Conclusion

