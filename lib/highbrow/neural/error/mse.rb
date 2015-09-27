module Highbrow
  module Neural
    module Error
      # Represents Mean Squared Error function
      class MSE
        def initialize
          reset
        end

        def reset
          @total_error = 0.0
          @pattern_count = 0.0
        end

        def calculate(actual, expected)
          result = Array.new expected.count, 0.0

          expected.each_with_index do |e, index|
            result[index] = e - actual[index]
            @total_error += result[index]**2
          end

          @pattern_count += 1
          result
        end

        def total_error
          x = @total_error / (2.0 * @pattern_count)
        end
      end
    end
  end
end
