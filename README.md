# Shoryuken::SNS

A Shoryuken extension that allows sending message to SNS.

## Installation

Add to the application's Gemfile:

```ruby
gem 'shoryuken'
gem 'shoryuken-sns'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install shoryuken-sns

## Usage

When consuming messages, this extension changes absolutely nothing in Shoryuken.
The full documentation can be found [here](https://github.com/phstc/shoryuken/wiki/Getting-Started).

Just as the documentation points out, consumers can be added by including `Shoryuken::Worker`:

```ruby
class HelloWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'hello'

  def perform(sqs_msg, name)
    puts "Hello, #{name}"
  end
end
```

If a work will be both consuming and publishing, the extended worker should
be used, `Shoryuken::Sns::Worker` and both `queue` and `topic` should be set:

```ruby
class HelloWorker
  include Shoryuken::Sns::Worker

  shoryuken_options queue: 'hello', topic: 'hello'

  def perform(sqs_msg, name)
    puts "Hello, #{name}"
  end
end
```

When a publisher and consmer aren't within the same code-base, it is important
that the two workers share the same class name:

For the consumer:

```ruby
class HelloWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'hello'

  def perform(sqs_msg, name)
    puts "Hello, #{name}"
  end
end
```

...and for the publisher:

```ruby
class HelloWorker
  include Shoryuken::Worker

  shoryuken_options topic: 'hello'
end
```

### Options

Only the `topic` option has been added and it **must** be the topic's ARN

## TODO

- Custom message sanitization
- Server middleware to wrapped the message in a custom format
- Server middleware to publish the result of the consumer to SNS

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fuseit/shoryuken-sns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Fuseit/shoryuken-sns/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Shoryuken::Sns project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fuseit/shoryuken-sns/blob/master/CODE_OF_CONDUCT.md).
