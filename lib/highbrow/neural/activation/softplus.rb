module Highbrow
  module Neural
    module Activation
      # Represents softplus function
      # https://en.wikipedia.org/wiki/Rectifier_(neural_networks)
      class Softplus < Base
        def primary(input)
          return 0.0 if input < -30.0
          return 30.0 if input > 30.0

          Math.log(1.0 + Math.exp(input))
        end

        def derivative(output)
          return 1.0 if output > 30.0
          return 0.00001 if output < -10.0

          1.0 / (1.0 + Math.exp(-output))
        end
      end
    end
  end
end
