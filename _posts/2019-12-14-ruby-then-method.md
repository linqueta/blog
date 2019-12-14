---
layout: post
title: Improve your code using the method then
date: 2019-12-14 12:00
categories: ruby then
tags: ruby then
summary: Turning your code more legible and simple
description: Turning your code more legible and simple
image: https://res.cloudinary.com/linqueta/image/upload/v1576355503/d4d5db.png_text_vbuc0h.png
---

![image]({{ page.image }})

Ruby 2.5 brought the method `yield_self` and at version 2.6 this method was renamed as `then`. The approach between them is to simplify your stack methods call avoiding unnecessary variables and confuse nested methods calls. It looks like the pipeline operator in Elixir (|>).
To understand as well the method `then` I'll create a flow to resolve the scenario below:

We need to build a service to debit user's wallet in an external service. To do this the service should call two external REST APIs:

* GET  /users/:document_number
* POST /wallet/:wallet_id/debit

After debit on external service, the service needs to save the Debit in our database and serialize the message.

- Using variables (all is used once):

<script src="https://gist.github.com/linqueta/fd75036eecbbd99dd0e896104f44e107.js"></script>

- Using nested calls (confuse and illegible code):

<script src="https://gist.github.com/linqueta/763a6eea3a6428fa3fb6747a00439911.js"></script>

- Finally, using the method then:

<script src="https://gist.github.com/linqueta/260a06f97420005a620a0421b5054607.js"></script>

So, when we use the method `then` to execute the debit flow we have a **legible** and **understandable** code. An another point is the performance, does the method `then` is slower or consumes many resources than the other two ways? Let's test it:

- First, we'll adapt the external service request:

<script src="https://gist.github.com/linqueta/3d16c8449d98763825f9a12824a2771e.js"></script>

- Now, defining the same behaviors:

<script src="https://gist.github.com/linqueta/e503cc85901c6da6d08709b58daa69e2.js"></script>

- And we'll test the performance:

<script src="https://gist.github.com/linqueta/45a2d614d8a5f5dbbe936a40ce0ed6d3.js"></script>

### Conclusion

So, as we can see about performance, the method `then` doesn't have any performance problem compared to other worse ways (almost the same) to do the same pipeline. Then, using the method `then` we can write better codes for our Ruby systems.