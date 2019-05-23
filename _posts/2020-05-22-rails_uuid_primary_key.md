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
- It turns hard to discover others valid UUIDs for your model into your database
- Is not required there is a centralized entity to make new identifiers

It've been used in many kinds of applications, like banks, payment gateways or systems that requires strong and not predictable keys.

### Using it on Rails project with ActiveRecord and Postgresql

Ruby on Rails trought ActiveRecord allows to use UUID in primary keys as default using a Postgresql's function. For make, it's necessary to hability some extensions in the database. For start a project, we may use the code bellow:

```bash
  rails new uuid_app -M -C -J -T -d postgresql
```

After create the project you should set the generator for set automactly primary key type as UUID. Add this code into the file application.rb:
<script src="https://gist.github.com/linqueta/83483b70289eb832588f012f94021367.js"></script>

Now your project will set automactly id as UUID, but, you need to set some extensions to Postgresql works with UUID. Make a migration typing this command:

```bash
  rails g migration enable_uuid_extension_and_pgcrypto
```

And set the Postgresql extensions:
<script src="https://gist.github.com/linqueta/eeb7419a131516060c7d0be27a9707d6.js"></script>


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

