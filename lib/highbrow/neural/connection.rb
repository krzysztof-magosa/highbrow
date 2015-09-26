module Highbrow
  module Neural
    # Represents connection between neurons
    class Connection
      attr_reader :source
      attr_reader :target
      attr_accessor :weight

      def initialize(source, target)
        @source = source
        @target = target
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

      def parameters
        {
          source: @source,
          target: @target,
          weight: @weight
        }
      end

      def self.from_parameters(parameters)
        instance = interconnect parameters[:source], parameters[:target]
        instance.weight = parameters[:weight]
        instance
      end

      def self.interconnect(source, target)
        connection = new source, target
        source.outputs.push connection
        target.inputs.push connection unless target.bias?

        connection
      end
    end
  end
end
