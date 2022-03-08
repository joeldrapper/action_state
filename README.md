# action_state

ActionState provides a simple DSL for defining model states and allows you to query the state as an ActiveRecord scope on the class and a predicate on the instance.

For example, the following state definition defines a class scope `Article.published` and an instance predicate `article.published?`.

```ruby
class Article < ApplicationRecord
  state(:published) { where(published_at: ..Time.current) }
  ...
end
```

## Usage

ActionState supports a small subset of ActiveRecord queries for the predicate definition, and delegates the scope definition to ActiveRecord.

It's not meant to comprehensively support every possible ActiveRecord query; rather it supports a few features that tend to lend themselves well to predicate definitions.

### `where`

The `where` method checks for inclusion in an Enumerable, coverage by a Range, and equality with other types of value.

#### Inclusion in an Enumerable

```ruby
state(:crafter) { where(role: ["designer", "developer"]) }
```

#### Covered by a Range

```ruby
state(:negative) { where(stars: 1..4 }
state(:indifferent) { where(stars: 5..6) }
state(:positive) { where(stars: 7..9) }

state(:recently_published) { where(published_at: 1.week.ago..) }
```

#### Equality

```ruby
state(:featured) { where(featured: true) }
```

### `where.not`

The counterpart to `where` is `where.not` which checks for exclusion from an Enumerable or Range, and inequality with other types of value.

```ruby
state(:deleted) { where.not(deleted_at: nil) }
```

### `excluding`

The `excluding` method excludes specific instances of a model.

```ruby
state(:normal) { excluding(special_post) }
```

### Passing arguments

States can also be defined to accept arguments.

```ruby
state(:before) { |whenever| where(created_at: ..whenever) }
state(:after) { |whenever| where(created_at: whenever..) }
```

### Composing states

You can chain query methods together to form more complex queries.

```ruby
state(:can_edit) { where(role: "admin").where.not(disabled: true) }
```

You can also compose multiple states together.

```ruby
state(:published) { where(published: true) }
state(:featured) { published.where(featured: true) }
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "action_state"
```

And then execute:

```other
$ bundle
```

Or install it yourself as:

```other
$ gem install action_state
```

Finally, include `ActionState` in your model class or `ApplicationRecord`:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActionState
  ...
end
```

## Contributing

Contributions are welcome. Please feel free top open a PR / issue / discussion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

