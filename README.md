# ActiveWarnings [![Build Status](https://travis-ci.org/s12chung/active_warnings.svg?branch=test_active_model)](https://travis-ci.org/s12chung/active_warnings)

`ActiveModel::Validations` separate for warnings.

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
    # to share the same validators, error related methods now correspond to warnings. ie:
    # the method #valid? == #safe? and #errors == #warnings
    validates :name, absence: true
  end
end

#
# Basic Use
#
model = BasicModel.new("some_name")

# like `#valid?`
model.safe? # => false
model.no_warnings? # => false, equivalent to #safe?
# like `#invalid?`
model.unsafe? # => true
model.has_warnings? # => true, equivalent to #unsafe?
# like `#errors`
model.warnings.keys # => [:name]

#
# Advanced Use
#
model.using_warnings? # => false, is true in validators when calling #safe?
```
