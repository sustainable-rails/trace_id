# trace\_id - Small class and tools for distributed tracing in your Rails app

[![<sustainable-rails>](https://circleci.com/gh/sustainable-rails/trace_id.svg?style=shield)](https://app.circleci.com/pipelines/github/sustainable-rails/trace_id)

Your web server or load balancer probably gives you a request ID for each web request.  It would be nice to make that available everywhere in your
Rails app for logging. It would be nice to pass that to background jobs to you can trace a request through a background job. It would be nice to
not have to write that yourself.

That is what this gem does.

It is a thin wrapper around thread local storage along with some helper classes to hook it into various parts of your Rails app that will allow a
request id from your web server to pass through background jobs and show up in your log.

## Install

In your `Gemfile`

```ruby
gem "trace_id"
```

## Usage


This gem revolves around the `TraceId` class, which has four methods.  The two you are likely to want are:

* `TraceId.get_or_initialize` - returns the current Trace Id for the current thread or generates a new one and stores that for the future
* `TraceId.reset!` - changes or sets the value to a new generated one.  This is useful in a rake task or background job not initiated by a web
request.

The other two methods, for completeness:

* `TraceId.get` - returns the current Trace Id or `nil` if there isn't one
* `TraceId.set` - sets the value. This is useful in a controller.

## Hooking Up To Your Rails App

There are four classes you can use to make it easier to integrate this into your Rails app.

### Setting the Trace Id to the value of your controller request id

In, e.g. `ApplicationController`:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base

  before_action TraceId::FromRequest
end
```

This will call `request.request_id` and put that value into `TraceId`.  This should be a relatively standard way to get the incoming request ID
generated by your infrastructure.

### Persisting Across Sidekiq Jobs

In e.g. `config/initializers/sidekiq.rb`:

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add TraceId::SidekiqServerMiddleware
  end

  config.client_middleware do |chain|
    chain.add TraceId::SidekiqClientMiddleware
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add TraceId::SidekiqClientMiddleware
  end
end
```

This will ensure that any code that queues a job will include the current Trace Id in that job's payload.  When that job is processed, it's
thread's Trace Id will be set.  This will allow you to see code executing in background jobs related to the web request that iniltiated those jobs.

### Accessing Trace Id in normal code

While you can certainly call `TraceId.get_or_initialize` wherever you want, if you have a service layer, for example, you may want a more expedient
means of doing this that you can place in your base class:

```ruby
# app/services/base_service.rb
class BaseService
  include TraceId::Method
end
```

Now, the method `trace_id` will call `TraceId.get_or_initialize` for you.

### Logging the Trace Id

The Trace Id isn't useful unless you log it.  Rails logging infrastructure is not very sophisticated, so it's hard to ensure it's included in every
call to `Rails.logger.info`.  If you have set up `TraceId::FromRequest`, then the request ID that is already logged from your controllers will be
the trace id, so that's good, but for all other code, you need more.

One option is to override the Rails logger's formatting to pull it in, but you could also adopt the use of the [https://github.com/sustainable-rails/log_method](log_method) gem, which allows you do the following:

```ruby
# config/initializers/log_method.rb

LogMethod.config do |c|
  c.trace_id_proc = ->() { TraceId.get }
end
```

Then, when you call `log`, the trace id will be included.

### Contributing

Happy to look at an accept:

* Bugfixes
* Adapters to put TraceId into more systems that need it
* New features if there is a clear problem statement that aligns with this gem

Not looking for:

* Changes related to coding style or formatting

