module Highbrow
  module Util
    class Normalizer
      def initialize(min_in, max_in, min_out, max_out)
        @min_in = min_in.to_f
        @max_in = max_in.to_f
        @in_range = @max_in - @min_in

        @min_out = min_out.to_f
        @max_out = max_out.to_f
        @out_range = @max_out - @min_out
      end

      def normalize_value(value)
        @min_out + (((value - @min_in) / @in_range) * @out_range)
      end

      def normalize_array(array)
        array.map { |value| normalize_value(value) }
      end

      def denormalize_value(value)
        @min_in + (((value - @min_out) / @out_range) * @in_range)
      end

      def denormalize_array(array)
        array.map { |value| denormalize_value(value) }
      end
    end
  end
end
