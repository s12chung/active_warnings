require "active_warnings/version"

require 'active_model'
require 'active_support/all'

module ActiveWarnings
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations

    define_callbacks :validate_warning

    def errors
      @run_warning_validations ? warnings : super
    end

    protected
    # Override and change one line:
    # https://github.com/rails/rails/blob/64c1264419f766a306eba0418c1030b87489ea67/activemodel/lib/active_model/validations.rb#L406
    def run_validations!
      super unless @run_warning_validations
      run_callbacks :validate_warning
      errors.empty?
    end

    class << self
      def warnings
        @within_warnings = true
        yield
      ensure
        @within_warnings = nil
      end

      # Change first parameter of:
      # https://github.com/rails/rails/blob/beb07fbfae845d20323a9863c7216c6b63aff9c7/activemodel/lib/active_model/validations.rb#L170
      def set_callback(name, *filter_list, &block)
        return super unless name == :validate && @within_warnings
        super(:validate_warning, *filter_list, &block)
      end
    end
  end

  protected
  def warnings
    @warnings ||= Errors.new(self)
  end

  def has_warnings?(context=nil)
    @run_warning_validations = true
    valid?(context)
  ensure
    @run_warning_validations = nil
  end

  def no_warnings?(context=nil)
    !has_warnings?(context)
  end
end
