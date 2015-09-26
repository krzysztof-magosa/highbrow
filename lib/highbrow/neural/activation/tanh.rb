module Highbrow
  module Neural
    module Activation
      # Represents hyperbolic tangent function
      # https://en.wikipedia.org/wiki/Hyperbolic_function
      class Tanh < Base
        attr_accessor :beta

        def initialize
          @beta = 1.0
        end

        def primary(input)
          Math.tanh(@beta * input)
        end

        def derivative(output)
          @beta * (1.0 - (output * output))
        end

        def flat_spot?
          false
        end
      end
    end
  end
end
