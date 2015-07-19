require 'spec_helper'

describe ActiveWarnings do
  it 'has a version number' do
    expect(ActiveWarnings::VERSION).not_to be nil
  end

  context "instance" do
    class BasicModel
      include ActiveWarnings

      attr_accessor :name, :warning_name

      validates :name, presence: true

      warnings do
        validates :warning_name, presence: true
      end
    end

    let(:instance) { BasicModel.new }

    describe "#run_validations!" do
      subject { instance.send :run_validations! }

      it "only runs the warning validations" do
        subject
        expect(instance.errors.keys).to eql :warning_name
      end
    end
  end

  context "class" do
    describe "::warnings" do
      let(:klass) do
        Class.new do
          include ActiveWarnings

          def self.raise_error
            return unless @within_warnings
            raise "true"
          end

          warnings do
            raise_error
          end
        end
      end

      subject { klass }

      it "makes @within_warnings true" do
        expect { subject }.to raise_error
      end
    end

    describe "::set_callback" do
      let(:klass) { Class.new { include ActiveWarnings } }

      def callback_chain_size(name)
        klass.send(:get_callbacks, name).send(:chain).size
      end

      context "when setting non-validate callback" do
        let(:options) { {} }

        subject do
          klass.define_callbacks :save
          klass.set_callback(:save, options) { }
        end

        it "adds the callback to save" do
          subject
          expect(callback_chain_size(:save)).to eql 1
          expect(callback_chain_size(:validate_warning)).to eql 0
        end
      end

      context "when setting a validate callback" do
        subject do
          klass.validates(:name, presence: true)
        end

        it "adds the callback to save to validate" do
          subject
          expect(callback_chain_size(:validate)).to eql 1
          expect(callback_chain_size(:validate_warning)).to eql 0
        end

        context "within warnings block" do
          let(:klass) do
            Class.new do
              include ActiveWarnings
              warnings do
                validates(:name, presence: true)
              end
            end
          end

          subject { klass }

          it "adds the callback to save to validate_warning" do
            subject
            expect(callback_chain_size(:validate_warning)).to eql 1
          end
        end
      end
    end
  end
end
