module Highbrow
  module Neural
    module Activation
      # Represents sigmoid function
      # https://en.wikipedia.org/wiki/Sigmoid_function
      class Sigmoid < Base
        attr_accessor :beta

        def initialize
          @beta = 1.0
        end

        def primary(input)
          1.0 / (1.0 + Math.exp(-(@beta * input)))
        end

        def derivative(output)
          @beta * (1.0 - output) * output
        end

        def flat_spot?
          true
        end
      end
    end
  end
end
