module Highbrow
  module Function
    class Tanh
      def primary(input)
        Math.tanh(input)
      end

      def derivative(output)
        1.0 - (output * output)
      end

      def upper_limit
        1.0
      end

      def lower_limit
        -1.0
      end

      def has_flat_spot
        false
      end
    end
  end
end
