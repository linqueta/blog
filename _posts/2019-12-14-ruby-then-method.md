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

```ruby
def debit!(document_number, amount)
  user_response = HttpClient.get("/users/#{document_number}")
  user = JSON.parse(user_response, symbolize_names: true)
  wallet_debit_response = HttpClient.post("/wallet/#{user[:wallet_id]}/debit", amount: amount)
  wallet_debit = JSON.parse(wallet_debit_response, symbolize_names: true)
  debit = Debit.create!(wallet_debit.slice(:external_id, :debited))
  DebitSerializer.new(debit).as_json
end
```

- Using nested calls (confuse and illegible code):

```ruby
def debit!(document_number, amount)
  DebitSerializer.new(Debit.create!(
      JSON.parse(HttpClient.post("/wallet/#{JSON.parse(HttpClient.get("/users/#{document_number}"), symbolize_names: true)[:wallet_id]}/debit", amount: amount), symbolize_names: true).slice(:external_id, :debited)
    )
  ).as_json
end
```

- Finally, using the method then:

```ruby
def debit!(document_number, amount)
  HttpClient.get("/users/#{document_number}")
            .then { |response| JSON.parse(response, symbolize_names: true) }
            .then { |user| HttpClient.post("/wallet/#{user[:wallet_id]}/debit", amount: amount) }
            .then { |response| JSON.parse(response, symbolize_names: true) }
            .then { |wallet_debit| Debit.create!(wallet_debit.slice(:external_id, :debited)) }
            .then { |debit| DebitSerializer.new(debit).as_json }
end
```

So, when we use the method `then` to execute the debit flow we have a **legible** and **understandable** code. An another point is the performance, does the method `then` is slower or consumes many resources than the other two ways? Let's test it:

- First, we'll adapt the external service request:

```ruby
def user_request(document_number)
  "{\"id\":\"c7c06dfe-28c7-491c-bd7a-dd7fab8a032e\",\"wallet_id\":\"835bf80e-879d-4f82-abb4-e3eecd7ddc61\",\"name\":\"Linqueta\"}".freeze
end

def wallet_debit_request(wallet_id, amount)
  "{\"id\":\"85397a79-c141-4407-ad73-055e87fe3c3a\",\"debited\":10.5,\"remaining\":105.1}".freeze
end

def create_debit!(options)
  OpenStruct.new(id: SecureRandom.uuid, external_id: options[:id], amount: options[:debited])
end

def serialize(debit)
  { id: debit.id, amount: debit.amount }
end
```

- Now, defining the same behaviors:

```ruby
def variables_debit!(document_number, amount)
  user_response = user_request(document_number)
  user = JSON.parse(user_response, symbolize_names: true)
  wallet_debit_response = wallet_debit_request(user[:wallet_id], amount)
  wallet_debit = JSON.parse(wallet_debit_response, symbolize_names: true)
  debit = create_debit!(wallet_debit.slice(:external_id, :debited))
  serialize(debit)
end

def nested_calls_debit!(document_number, amount)
  serialize(
    create_debit!(
      JSON.parse(
        wallet_debit_request(
          JSON.parse(
            user_request(document_number),
            symbolize_names: true
          )[:wallet_id],
          amount
        ),
        symbolize_names: true
      ).slice(:external_id, :debited)
    )
  )
end

def then_debit!(document_number, amount)
  user_request(document_number)
    .then { |response| JSON.parse(response, symbolize_names: true) }
    .then { |user| wallet_debit_request(user[:wallet_id],amount) }
    .then { |response| JSON.parse(response, symbolize_names: true) }
    .then { |wallet_debit| create_debit!(wallet_debit.slice(:external_id, :debited)) }
    .then { |debit| serialize(debit) }
end
```

- And we'll test the performance:

```ruby
document = '123456'.freeze

Benchmark.ips do |x|
  x.report(:variables) { variables_debit!(document, 10.5) }
  x.report(:nested_calls) { nested_calls_debit!(document, 10.5) }
  x.report(:then) { then_debit!(document, 10.5) }
  x.compare!
end

# Warming up --------------------------------------
#            variables     2.489k i/100ms
#         nested_calls     2.507k i/100ms
#                 then     2.439k i/100ms
# Calculating -------------------------------------
#            variables     25.035k (± 4.1%) i/s -    126.939k in   5.080486s
#         nested_calls     25.453k (± 3.4%) i/s -    127.857k in   5.029528s
#                 then     24.777k (± 3.6%) i/s -    124.389k in   5.027496s

# Comparison:
#         nested_calls:    25453.1 i/s
#            variables:    25035.2 i/s - same-ish: difference falls within error
#                 then:    24776.8 i/s - same-ish: difference falls within error

Benchmark.memory do |x|
  x.report(:variables) { variables_debit!(document, 10.5) }
  x.report(:nested_calls) { nested_calls_debit!(document, 10.5) }
  x.report(:then) { then_debit!(document, 10.5) }
  x.compare!
end

# Calculating -------------------------------------
#            variables     7.364k memsize (     0.000  retained)
#                         52.000  objects (     0.000  retained)
#                         20.000  strings (     0.000  retained)
#         nested_calls     7.364k memsize (     0.000  retained)
#                         52.000  objects (     0.000  retained)
#                         20.000  strings (     0.000  retained)
#                 then     7.596k memsize (     0.000  retained)
#                         53.000  objects (     0.000  retained)
#                         20.000  strings (     0.000  retained)

# Comparison:
#            variables:       7364 allocated
#         nested_calls:       7364 allocated - same
#                 then:       7596 allocated - 1.03x more
```

### Conclusion

So, as we can see about performance, the method `then` doesn't have any performance problem compared to other worse ways (almost the same) to do the same pipeline. Then, using the method `then` we can write better codes for our Ruby systems.