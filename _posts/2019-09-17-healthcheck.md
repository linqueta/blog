---
layout: post
title: Healthcheck an app using Rails::Healthcheck
date: 2019-09-17 12:00
categories: rails healthcheck opensource
summary: Easy and simple way to check your app's health
description: Easy and simple way to check your app's health
tags: rails healthcheck opensource
image: https://res.cloudinary.com/linqueta/image/upload/v1568688510/healthcheck_ypelrf.png
repo: https://github.com/linqueta/rails-healthcheck
---

[![image]({{ page.image }})]({{ page.repo }})

In the last Sunday, at 3:00 a.m., I was without sleep and I was already thinking about a way to check if my applications are running without errors, mainly on the nights. I'd searched and I didn't find one gem to attend my requirements:
  - Easy to plug in a Ruby on Rails application
  - Simple to configure the route and the HTTP codes
  - Fast to run (parallelized if possible)

After this search, I've motivated to create my library, so I created the gem [rails-healthcheck]({{ page.repo }}) to attend my requirements. This gem is open source, so the community can contribute to holding it always updated and without security issues.

So, in this post, I will teach how to install and use the gem.

### Installing

First I will create a Rails app with the following command:

```
rails new my_app -d=postgresql
```

Now I will set the gem [rails-healthcheck]({{ page.repo }}) where I have to append in my Gemfile to get it:

```ruby
gem 'rails-healthcheck'
```

Afer added I have to run the command `bundle` to get this gem's source from RubyGems and run a rake to plug the health check route and set the initializer file with this command below:

```
rails healthcheck:install

#  -  invoke        Rails::Healthcheck
#  -    create      config/initializers/healthcheck.rb
#  -    modify      config/routes.rb
```

This rake plugs the `Healthcheck::Router` in your _config/routes.rb_, like this code:

```ruby
Rails.application.routes.draw do
  Healthcheck.routes(self)

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
```

And create the initializer in _config/initializers/healthcheck.rb_ where you will set the settings for this gem works as well:

```ruby
# frozen_string_literal: true

Healthcheck.configure do |config|
  config.success = 200
  config.error = 503
  config.verbose = false
  config.route = '/healthcheck'
  config.method = :get

  # -- Checks --
  # Check if the db is available
  # config.add_check :database, -> { ActiveRecord::Base.connection.execute('select 1') }
  # Check if the db is available and without pending migrations
  # config.add_check :migrations,-> { ActiveRecord::Migration.check_pending! }
  # Check if the cache is available
  # config.add_check :cache, -> { Rails.cache.read('some_key') }
  # Check if the application required envs are defined
  # config.add_check :environments, -> { Dotenv.require_keys('ENV_NAME', 'ANOTHER_ENV') }
end
```

### Setting my checks and testing

In my test project, I will set the first validation to check if the database is available:

```ruby
# config/intializers/healthcheck.rb
# ...
  config.add_check :database, -> { ActiveRecord::Base.connection.execute('select 1') }
#...
```

And now, I will send a request to GET /healthcheck:

```
curl -i localhost:3000/healthcheck

HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
Referrer-Policy: strict-origin-when-cross-origin
Content-Type: text/html
Cache-Control: no-cache
X-Request-Id: 7e8440d4-e3be-4df6-a87d-3c2d1b2e877b
X-Runtime: 0.028443
Transfer-Encoding: chunked
```

Wow, how my database is available, the API returned 200. Now, I will force an error, so, in the initializer, I will add a check to execute a division by zero:

```ruby
# config/intializers/healthcheck.rb
# ...
  config.add_check :database, -> { ActiveRecord::Base.connection.execute('select 1') }
  config.add_check :zero_division, -> { 10/0 }
#...
```

And send a request again:

```
curl -i localhost:3000/healthcheck

HTTP/1.1 503 Service Unavailable
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
Referrer-Policy: strict-origin-when-cross-origin
Content-Type: text/html
Cache-Control: no-cache
X-Request-Id: 0850e8c0-acea-4b98-932d-69da957a303f
X-Runtime: 0.023687
Transfer-Encoding: chunked
```

Nice, now I have the HTTP code 503, it meanings that some check raises an error when was executed the checks. I can set to get in the response what raises error setting the verbose mode in the initializer:

```ruby
# config/intializers/healthcheck.rb
# ...
  config.verbose = true
#...
```

Lastly, I will send another request to get the errors:

```
curl -i localhost:3000/healthcheck

HTTP/1.1 503 Service Unavailable
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
Referrer-Policy: strict-origin-when-cross-origin
Content-Type: application/json; charset=utf-8
Cache-Control: no-cache
X-Request-Id: 0bc3c278-d036-48e5-8ad9-9353719212a0
X-Runtime: 0.025519
Transfer-Encoding: chunked

{
  "code":503,
  "errors":[
    {
      "name":"zero_division",
      "exception":"ZeroDivisionError",
      "message":"divided by 0"
    }
  ]
}
```

In the last, the response includes what errors were raised in checks.

### Why should you use this gem:

The gem [rails-healthcheck]({{ page.repo }}) have many benefits:
  - Open Source: The community can improve and let safe from security issues
  - Fast: This gem runs the checks in parallel without using any library to execute them, just ruby and ActionController in the controller.
  - Simple: You just have to run the command `rails healthcheck:install` and use the health check API
  - Test coverage 100%: At least all lines were tested

<style>
a:hover{
  background-image: none
}
</style>