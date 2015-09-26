module Highbrow
  module Neural
    module Activation
      # Represents rectifier activation function
      # https://en.wikipedia.org/wiki/Rectifier_(neural_networks)
      class ReLU < Base
        def primary(input)
          [0.0, input].max
        end

        def derivative(output)
          output <= 0.0 ? 0.0 : 1.0
        end
      end
    end
  end
end
