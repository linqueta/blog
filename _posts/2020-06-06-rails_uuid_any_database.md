---
layout: post
title: UUID on Ruby on Rails with any database
date: 2019-06-04 20:00
categories: rails uuid active_record any_database
summary: You can use it in any database. Trust in me!
description: You can use it in any database. Trust in me!
tags: rails uuid active_record any_database
image: https://res.cloudinary.com/linqueta/image/upload/v1559515605/archive_ntekdh.jpg
---

![image]({{ page.image }})

How have been demonstrated in this [post](https://linqueta.com/rails/uuid/active_record/2019/05/24/rails_uuid_primary_key/) about to use UUID on Ruby on Rails with Postgresql, UUID brings many benefits for your application and that project
used Postgresql's internal function to generate UUID value, turning easier to use UUID. But, if you don't use Postgresql in your project, you can adapt your application to generate UUID in a few minutes.

## The application
### Creating the app
To initialize it, you could create an app with this command below:
```bash
  rails new uuid_app -M -C -J -T
```

The project will use SQLite as a database as default. After creating the app, you could create the database with this command:
```bash
  rails db:create
```

### Setting id type generator
You could set a generator to set automatically id type as String with this code below:
<script src="https://gist.github.com/linqueta/70afb49360b74394af19a30f733282a4.js"></script>

If you don't set it, you can set manually in each migration.

### Creating the models
Type these commands below to create Author and Book models:
```bash
  rails g model Author name:string
  rails g model Book title:string author:references
```

These commands will generate the models and migrations files. In Book migration, you should set the id type as String and set as an index like the code below:
<script src="https://gist.github.com/linqueta/69c353a21ce72f4777aaf7831c5439c9.js"></script>

About the models, you could set `has_many` relation in the model Author :
<script src="https://gist.github.com/linqueta/36007847531dd58e41cef1c3fdac9596.js"></script>

After it, you could apply these migrations on the database this command below:
```bash
  rails db:migrate
```

This last command has generated the database schema, like this:
<script src="https://gist.github.com/linqueta/d40cc749023f676d6c641f2a36ea4a5f.js"></script>

### Setting some behaviors
In the file `application_record.rb` you should use two ActiveRecord's methods to use correctly UUID. The first is to set UUID value in the field id every time that created a new record. The another is to set to order records by the field `created_at`.

Set your project file `application_record.rb` like this below:
<script src="https://gist.github.com/linqueta/74718ed77d7d139694970a20835e53e9.js"></script>

## Lets test!
- Lets create some authors and books
<script src="https://gist.github.com/linqueta/2dd8609408c6f111edbce81435fb5185.js"></script>

- Using ActiveRecord's methods
<script src="https://gist.github.com/linqueta/198cae0ed1b2a252727e73f6f6cdec96.js"></script>

## That's it!

If you want to see a project using the whole that has been said in this post, you can see this [repository](https://github.com/linqueta/rails-uuid-any-database) in my [Github](https://github.com/linqueta).