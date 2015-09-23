module Highbrow
  module Neuron
    # Represents standard neuron
    class Standard
      attr_accessor :input
      attr_accessor :inputs
      attr_accessor :bias

      attr_accessor :function
      attr_accessor :outputs
      attr_reader :output

      def initialize
        @inputs = []
        @outputs = []
        @output = 0.0
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
