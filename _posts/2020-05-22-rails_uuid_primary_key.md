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

It's known ActiveRecord uses sequencial number in this field id as default. It's common on relational databases and for make sequencial numbers many relational databases use something like a Sequence, to get a new number t oeach interaction. But use a sequencial number as a record identifier can bring many problems:
  - Easy prediction previous and next ids
  - Centralized entity to make new sequecial numbers

There is an another way to make this identifiers without these problems. The way is to use **UUID** as a record identifier.

### UUID
UUID is a universally unique identifier (UUID) is a 16-octets/128-bit number used to identify information in computer systems. The UUID value is standardized by RFC 4122 to ensure that distributed systems be able to use it.

In its canonical textual representation, the 16 octets of a UUID are represented as 32 hexadecimal (base-16) digits, displayed in 5 groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and 4 hyphens). For example:

`123e4567-e89b-12d3-a456-426655440000`

When generated according to the standard methods, UUIDs are for practical purposes unique, without depending for their uniqueness on a central registration authority or coordination between the parties generating them, unlike most other numbering schemes. While the probability that a UUID will be duplicated is not zero, it is close enough to zero to be negligible.

#### The why you should use it

UUID has many benefits if compared with sequential id, like these:
- It turns hard to discover others valid UUIDs
- Is not required there is a centralized entity to make new identifiers



#### Commons applications

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

