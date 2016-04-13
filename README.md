# ActiveWarnings [![Build Status](https://travis-ci.org/s12chung/active_warnings.svg?branch=test_active_model)](https://travis-ci.org/s12chung/active_warnings)

Separate `ActiveModel::Validations` errors for warnings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_warnings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_warnings

## Usage

```ruby
class BasicModel
  include ActiveWarnings

  attr_accessor :name
  def initialize(name); @name = name; end

  warnings do
    validates :name, absence: true
    
    # Example custom validation
    validate { errors.add(:name, "is some_name") if name == "some_name" }
  end
end

#
# Basic Use
#
model = BasicModel.new("some_name")

# Regular ActiveModel::Validations errors work separately
model.valid? # => true		
model.errors.full_messages # => []

# like `#valid?`
model.safe? # => false
model.no_warnings? # => false, equivalent to #safe?
# like `#invalid?`
model.unsafe? # => true
model.has_warnings? # => true, equivalent to #unsafe?
# like `#errors`
model.warnings.full_messages # => ["Name must be blank", "Name is some_name"]

#
# Advanced Use
#
model.using_warnings? # => false, is true in validators when calling #safe?
```
