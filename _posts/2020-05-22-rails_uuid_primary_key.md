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

When we create a model in Rails, most specifically using the ActiveRecord through migration, is common to use an id field as the primary key. This field has some responsibilities:
  - Identify the record
  - Allow that other models refer to this record

It's known ActiveRecord uses the sequential number or Sequential ID in this field id as default. It's common on relational databases and for make sequential numbers many relational databases use something like a Sequence, to get a new number to each interaction. But use a sequential number as a record identifier can bring many problems:
  - Easy prediction for previous and next ids
  - A centralized entity to make new sequential numbers

There is another way to make this identifier without these problems, using **UUID** as a record identifier.

### Universally Unique Identifier
Universally Unique Identifier or UUID is a 16-octets/128-bit number used to identify information in computer systems. The UUID value is standardized by RFC 4122 to ensure that distributed systems be able to use it.

In its canonical textual representation, the 16 octets of a UUID are represented as 32 hexadecimal (base-16) digits, displayed in 5 groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and 4 hyphens). For example:

```
123e4567-e89b-12d3-a456-426655440000
```


When generated according to the standard methods, UUIDs are for practical purposes unique, without depending for their uniqueness on a central registration authority or coordination between the parties generating them, unlike most other numbering schemes. While the probability that a UUID will be duplicated is not zero, it is close enough to zero to be negligible.

#### The why you should use it

UUID has many benefits if compared with the Sequential ID, like these below:
- It turns hard to discover others valid UUIDs for your model into your database
- Is not required there is a centralized entity to make new identifiers

It has been used in many kinds of applications, like banks, payment gateways or systems that require strong and not predictable keys.

### Using UUID on Rails project with ActiveRecord and Postgresql

#### Setting generator, extensions and models

Ruby on Rails through ActiveRecord allows using UUID in primary keys as default using a Postgresql's function. For make, it's necessary to ability some extensions in the database. For create the project, we may use the code below:

```bash
  rails new uuid_app -M -C -J -T -d postgresql
```

After creating the project you should set the generator for set automatically primary key type as UUID. Add this code into the file application.rb:
<script src="https://gist.github.com/linqueta/83483b70289eb832588f012f94021367.js"></script>

Now, your project will set automatically id as UUID, but, you need to set some extensions to Postgresql works with UUID. Make a migration typing this command:

```bash
  rails g migration enable_uuid_extension_and_pgcrypto
```

After creating the migration, you must set the Postgresql extensions:
<script src="https://gist.github.com/linqueta/eeb7419a131516060c7d0be27a9707d6.js"></script>

Now, run `rails db:migrate` and we will have the follow database's schema:
<script src="https://gist.github.com/linqueta/118db0a8c9cdccf476e3d66e65c4c50d.js"></script>

With the required extensions we can create the first model, typing this command below:
```bash
  rails g model Author title:string
```

And was generated this code:
<script src="https://gist.github.com/linqueta/28723187543309a125427062d23df897.js"></script>

And now, we will create the second model related to the previous:
```bash
  rails g model Book title:string author:references
```

After ran the command above, set the references type like this code bellow:
<script src="https://gist.github.com/linqueta/99bc1920f8df580e368c80b2627b46af.js"></script>

We created all models, but, we need to run again to do a migration on the database. Type it again:
```bash
  rails db:migrate
```

And by final, we have the follow database's schema:
<script src="https://gist.github.com/linqueta/ce9f8f70f517a1da926e29017b83452a.js"></script>

As we can see the migrations using UUID on the primary key (the field id) instead a sequential number and the value is made using a native Postgresql function:
```sql
  gen_random_uuid()
```

Besides that, the schema was generated with an index on foreign keys (references) like when we use a sequential number:
```ruby
  t.index ["author_id"], name: "index_books_on_author_id"
```

#### It's time (Bruce Buffer saying!)

Now, after all configurations, we can create, find and use other ActiveRecord::Base methods with our models:
<script src="https://gist.github.com/linqueta/8df73bf474b1125999de00e4bfd8c7f4.js"></script>

##### Warning!

When we use UUID with ActiveRecord, some methods like `first` and `last`, the Active Record sorting records by the id as default, but, UUID values aren't sequential, then, we may get an incorrect value. To show it, we will create some authors and search the first.

Creating some authors with UUID on the field `id`:
<script src="https://gist.github.com/linqueta/a7319c1435b72e35dd307e50aab23f00.js"></script>

Finding the first Author:
<script src="https://gist.github.com/linqueta/0fea04d627734618ca0598cfc0baa3e6.js"></script>

As we can see the first Author created was the famous (or almost it) Yukihiro Matsumoto, but was returned as the first the Rails creator, David Heinemeier Hansson. It happened because ActiveRecord uses the field `id` to order fields as can be seeing in the log:
```ruby
  Author Load (1.2ms)  SELECT  "authors".* FROM "authors" ORDER BY "authors"."id" ASC LIMIT $1  [["LIMIT", 1]]
```

To resolve this problem, when we use UUID on the field `id` we should use the timestamp `created_at` to order correctly. For make it, we can use the method `default_scope`:
<script src="https://gist.github.com/linqueta/16bf6fbf616156c63305a9ddfc1bbe82.js"></script>

And finding again:
<script src="https://gist.github.com/linqueta/018a44cf2bf78ec7c3f49bedaa6db06a.js"></script>

Yeah, at now we have the correct first Author created.

#### About performance...

Here are some tests for checking how UUID behaves when compared with Sequential ID. Both tests ran with the localhost database and local application. They are:

##### Creating new authors:
<script src="https://gist.github.com/linqueta/8d83d16e4275b0a98168c9ed2e6794ce.js"></script>

##### Finding authors by id:
<script src="https://gist.github.com/linqueta/074553deab4b9fc512a162837b08f204.js"></script>

### Final words

I think that you should consider to use it in your next project because UUID is a secure and strong id for models. Besides that, UUID performance is the same using Sequential ID and it has an easy implementation using ActiveRecord and Postgresql.

#### Fonts
- https://en.wikipedia.org/wiki/Universally_unique_identifier
