module Highbrow
  module Neuron
    # Represents standard neuron
    class Standard < Base
      attr_accessor :inputs

      def initialize
        super
        @inputs = []
      end

      def type
        :standard
      end

      def inputs_sum
        @inputs.map(&:weighed_value).reduce(:+)
      end

      def activate
        @output = @function.primary inputs_sum
      end
    end
  end
end
