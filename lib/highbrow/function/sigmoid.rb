#require 'nnmath'

module Highbrow
  module Function
    # Represents sigmoid function
    # https://en.wikipedia.org/wiki/Sigmoid_function
    class Sigmoid < Base
 #     include NNMath

      def initialize
        @slope = 1.0
      end

      def primary(input)
        #1.0 / (1.0 + Math.exp(-@slope * input))
        #0.5 * (input * @slope / (1 + (input*@slope).abs)) + 0.5
        1.0 / (1.0 + Math.exp(-1.0 * input))
        #sigmoid(input)

        #input / (1.0 + input.abs)
      end

      def derivative(output)
        # 0.1 to fix flat spot problem
        # (@slope * output * (1.0 - output)) + 0.01

        (output * (1.0 - output)) + 0.01
        #sigmoid_derivative(output) + 0.0001
      end
    end
  end
end
