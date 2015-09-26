module Highbrow
  module Neural
    # Represents connection between neurons
    class Connection
      attr_reader :source
      attr_reader :target
      attr_accessor :weight

      def initialize(source, target)
        fail if target.bias?

        @source = source
        @target = target

        @source.outputs.push self
        @target.inputs.push self

        randomize
      end

      def randomize
        @weight = rand(-0.5..0.5)
      end

      def value
        @source.output
      end

      def weighed_value
        value * @weight
      end
    end
  end
end
