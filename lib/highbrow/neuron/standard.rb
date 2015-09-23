module Highbrow
  module Neuron
    # Represents standard neuron
    class Standard < Base
      attr_accessor :input
      attr_accessor :inputs
      attr_accessor :bias

      def initialize
        super
        @inputs = []
      end

      def type
        @bias ? :bias : :standard
      end

      def inputs_sum
        @inputs.map(&:weighed_value).reduce(:+)
      end

      def activate
        value = @input.nil? ? inputs_sum : @input
        @output = @function.nil? ? value : @function.primary(value)
      end
    end
  end
end
