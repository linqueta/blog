---
layout: post
title: Health checking a Rails app using Rails::Healthcheck
date: 2019-09-17 12:00
categories: rails healthcheck opensource
summary: Easy and simple way to check your app's health
description: Easy and simple way to check your app's health
tags: rails healthcheck opensource
image: https://res.cloudinary.com/linqueta/image/upload/v1568688510/healthcheck_ypelrf.png
repo: https://github.com/linqueta/rails-healthcheck
---

[![image]({{ page.image }})]({{ page.repo }})

In the last Sunday, at 3:00 a.m., I was without sleep and I was already thinking about a way to check if my applications are running without errors, mainly on the nigths. I'd searched and I didn't find one that attend my requirements:
  - Easy to plug in a Ruby on Rails application
  - Simple to configure the route and the http codes in its responses

After this search, I've motivated to create my own library, so I created the gem [rails-healthcheck]({{ page.repo }}) to attend my requirements. This gem is open source, so the community can contribute to hold it always updated and without security issues.

So, in this post I will teach how to install and use the gem.

### Installing

First, I will create a Rails app with this command:

```
rails new my_app -d=postgresql
```

To set the gem is very simple, you just have to set in your Gemfile:

```ruby
gem 'rails-healthcheck'
```

And, after it, you have to run to get the gem from RubyGems server and run a rake to install to plug the route and set the initializer file:

```
rails healthcheck:install

#  -  invoke        Rails::Healthcheck
#  -    create      config/initializers/healthcheck.rb
#  -    modify      config/routes.rb
```

This rake plug the Healthcheck::Router in your _config/routes.rb_, like this code:

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



In my test project, I will set firt a validation to check if database is available:

```ruby
# frozen_string_literal: true
```

<style>
a:hover{
  background-image: none
}
</style>