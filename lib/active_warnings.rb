require "active_warnings/version"

require 'active_model'

require 'active_warnings/validator'

module ActiveWarnings
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    define_callbacks :validate_warning, scope: :name

    def errors
      @run_warning_validations ? warnings : super
    end

    protected
    # Override and change one line:
    # https://github.com/rails/rails/blob/64c1264419f766a306eba0418c1030b87489ea67/activemodel/lib/active_model/validations.rb#L406
    def run_validations!
      return super unless @run_warning_validations
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

  def warnings
    @warnings ||= ActiveModel::Errors.new(self)
  end

  def unsafe?(context=nil)
    !safe?(context)
  end
  alias_method :has_warnings?, :unsafe?

  def safe?(context=nil)
    using_warnings { valid?(context) }
  end
  alias_method :no_warnings?, :safe?

  def using_warnings
    @run_warning_validations = true
    yield
  ensure
    @run_warning_validations = nil
  end

  def using_warnings?
    !!@run_warning_validations
  end
end
