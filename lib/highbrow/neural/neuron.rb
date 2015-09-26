module Highbrow
  module Neural
    # Represents standard neuron
    class Neuron
      attr_reader :serial
      attr_accessor :input
      attr_reader :inputs
      attr_reader :bias
      alias_method :bias?, :bias
      attr_accessor :activation
      attr_reader :outputs
      attr_reader :output

      def initialize(bias: false, activation: nil)
        @inputs = []
        @outputs = []
        @output = 0.0

        @bias = bias
        # @input = 0.5 + (rand(1000) / 2000.0) if bias
        @input = 1.0 if bias
        @activation = activation
      end

      def activate
        value = @input.nil? ? inputs_sum : @input.to_f
        @output = @activation.nil? ? value : @activation.primary(value)
      end

      private

      def inputs_sum
        # @inputs.map(&:weighed_value).reduce(:+)
        sum = 0.0

        @inputs.each do |item|
          sum += item.weighed_value
        end

        sum
      end
    end
  end
end
