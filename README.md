# Jobi

A simple framework for Ruby, provides a full interaction between your app/micro-service and message brokers like: (Rabbitmq, Kafka, ..etc).
</br>
Currently it only support [Rabbitmq](https://www.rabbitmq.com/).

## Requirements
- [Rabbitmq](https://www.rabbitmq.com/) server installed and ready.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jobi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jobi

## Setup
- Add the below code to your app:
```ruby
Jobi.configure do |config|
    config.rabbitmq
    config.act_as_publisher = true
    config.act_as_consumer = true
    config.jobs = ['{Your Job classes goes here}']
    config.log_file = 'log/jobi.log'
    config.log_level = :debug
end
```
- To change rabbitmq client configuration you can do the following:
```ruby
Jobi.configure do |config|
    # same as the above example
    # and you can add the below one:
    config.rabbitmq(
        {
            host: ENV['RABBITMQ_HOST'],
            port: ENV['RABBITMQ_PORT'],
            user: ENV['RABBITMQ_USER'],
            pass: ENV['RABBITMQ_PWD'],
            vhost: '/',
            auth_mechanism: 'PLAIN',
            heartbeat: 'server',
            automatically_recover: true,
            network_recovery_interval: 5.0,
            ssl: false,
            threaded: true,
            continuation_timeout: 4000,
            frame_max: 131_072
        }
    )
end
```
- For rails you can do the following:
```ruby
# config/initializers/jobi.rb
Jobi.configure do |config|
    # You can add the above examples here safely.
end
```
## Usage

- Create an asynchronous job:
```ruby
class ExampleJob < Jobi::Job
    # Queue name that will be used for publishing and consuming messages.
    # Force acknowledge of the message or not.
    # Number of consumers that will consume from this queue.
    # Queue durability to survive broker restart, by default it is true.
    # Message persistence to survive broker restart.
    options queue_name: :example,
            ack: true,
            consumers: 5,
            durable: true,
            persist: true

    # Will be called after run.
    after_run :print_sum

    # Entry point of the job
    def initialize(arg1:, arg2:)
        @arg1 = arg1
        @arg2 = arg2
    end

    def run
        # Your custom logic goes here
        @sum = @arg1 + @arg2
    end

    private

    def print_sum
        # Your custom logic that will run after
        # the execution of your job.
        puts @sum
    end
end
```

Then you can call it like this:
```ruby
ExampleJob.run(arg1: 1, arg2: 2)
```
## Examples
Below some examples that will help you to start with Jobi.
- [Ruby](https://github.com/Rudy-Zidan/jobi/blob/master/examples/normal_job.rb)
- [Rails](https://github.com/Rudy-Zidan/jobi/tree/master/examples/demo_app)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Rudy-Zidan/jobi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Rudy-Zidan/jobi/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jobi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Rudy-Zidan/jobi/blob/master/CODE_OF_CONDUCT.md).
