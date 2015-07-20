# #define_callbacks needs this method
module ActiveModel
  class Validator
    def validate_warning(*args, &block)
      validate(*args, &block)
    end
  end
end