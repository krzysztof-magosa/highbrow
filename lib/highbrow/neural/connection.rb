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
        @target.inputs.push self unless target.bias?

        randomize
      end

      def randomize
        #@weight = Random.rand(-0.5..0.5)
        #@weight = Random.rand(0.01..1.0)
        @weight = ((rand 2000) / 1000.0) - 1.0
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
