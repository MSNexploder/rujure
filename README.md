# Rujure

Rujure helps you to interoperate between Clojure and JRuby on JVM.

## Installation

Add this line to your application's Gemfile:

    gem 'rujure'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rujure

## Usage

### Calling single Clojure function

```ruby
sort = Rujure.function 'clojure.core', 'sort'
sort.invoke([3, 2, 1]) # => [1, 2, 3]
```

### Including Clojure namespaces

```ruby
module IncludeAll
  extend Rujure::Helpers
  include_clojure_namespace 'clojure.core'
end
```

```ruby
module IncludeSome
  extend Rujure::Helpers
  include_clojure_namespace 'clojure.core', functions: %w(some string? swap! select-keys)
end
```

```ruby
module IncludeWithoutAutoConversion
  extend Rujure::Helpers
  include_clojure_namespace 'clojure.core', auto_conversion: false
end
```

```ruby
module IncludeMultiple
  extend Rujure::Helpers
  include_clojure_namespace 'clojure.core', functions: %w(some)
  include_clojure_namespace 'clojure.core', functions: %w(symbol), auto_conversion: false
end
```

## Contributing

1. Fork it ( https://github.com/msnexploder/rujure/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
