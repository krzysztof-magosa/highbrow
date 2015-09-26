module Highbrow
  module Neural
    module Activation
      # Represents sigmoid function
      # https://en.wikipedia.org/wiki/Sigmoid_function
      class Sigmoid < Base
        def primary(input)
          1.0 / (1.0 + Math.exp(-1.0 * input))
        end

        def derivative(output)
          output * (1.0 - output)
        end

        def flat_spot?
          true
        end
      end
    end
  end
end
