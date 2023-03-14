# Annotable

Annotable is a module that can extend any class or module to add the ability to annotate its methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "annotable"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install annotable

## Usage
```ruby
require "annotable" # Require the gem

class Needy
  extend Annotable # Extend your class or module with Annotable
  annotable :my_annotation, :my_other_annotation # Declare your annotations

  my_annotation 42, hello: "world!" # Annotate your methods
  def method_needing_meta_data
    # ...
  end

  def regular_method
    # ...
  end
end
```

`Annotable` adds several methods to your class or module, providing access to annotations and their metadata:
```ruby
Needy.annotated_method_exist? :method_needing_meta_data
# => true
Needy.annotated_method_exist? :regular_method
# => false
Needy.annotated_methods
# => [#<Annotable::Method
#   @annotations=[
#     #<Annotable::Annotation
#       @name=:my_annotation,
#       @options={:hello=>"world!"},
#       @params=[42]>
#   ],
#   @name=:method_needing_meta_data>
# ]
```

`Annotable::Method` represents a method name along with its annotations:
```ruby
method = Needy.annotated_methods.first
method.name
# => :method_needing_meta_data
method.annotations
# => [
#   #<Annotable::Annotation
#     @name=:my_annotation,
#     @options={:hello=>"world!"},
#     @params=[42]>
# ]
```

`Annotable::Annotation` contains annotation's name and metadata:
```ruby
annotation = method.annotations.first
annotation.name
# => :my_annotation
annotation.params
# => [42]
annotation.options
# => {:hello => "world!"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ductr-io/annotable.

## License

The gem is available as open source under the terms of the [LGPLv3 or later](https://opensource.org/license/lgpl-3-0/).
