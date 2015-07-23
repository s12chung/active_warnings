# ActiveWarnings

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

  attr_accessor :name, :warning_name

  validates :name, presence: true

  warnings do
    # to use same validators,
    # calling #valid? or #errors will be #no_errors? and #warnings, respectively (on self or record)
    validates :warning_name, presence: true
  end
end

model = BasicModel.new(name: "a")
model.valid? # => true
model.errors.keys # => []

model.safe? # => false
model.no_warnings? # => false, equivalent to #safe?
model.warnings.keys # => [:warning_name]

model.with_warnings? # => false, is true if warnings are on (within #safe call)

```
