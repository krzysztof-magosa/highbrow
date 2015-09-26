module Highbrow
  module Neural
    module Activation
      # Represents hyperbolic tangent function
      # https://en.wikipedia.org/wiki/Hyperbolic_function
      class Tanh < Base
        def primary(input)
          Math.tanh(input)
        end

        def derivative(output)
          1.0 - (output * output)
        end
      end
    end
  end
end
