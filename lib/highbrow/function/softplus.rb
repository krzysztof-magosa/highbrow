module Highbrow
  module Function
    # Represents softplus function
    # https://en.wikipedia.org/wiki/Rectifier_(neural_networks)
    class Softplus < Base
      E = 2.71828183

      def primary(input)
        input = 700.0 if input > 700.0
        Math.log(1.0 + E**input)
      end

      def derivative(output)
        1.0 / (1.0 + E**-output)
      end
    end
  end
end
