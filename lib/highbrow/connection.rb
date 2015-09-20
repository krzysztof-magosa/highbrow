module Highbrow
  # Represents connection between neurons
  class Connection
    attr_reader :source
    attr_reader :target
    attr_reader :weight

    def initialize(source, target)
      @source = source
      @target = target
      @weight = 0.5 # @TODO random number
    end

    def value
      @source.output
    end

    def weighed_value
      value * @weight
    end

    def self.interconnect(source, target)
      connection = new source, target
      source.outputs.push connection
      target.inputs.push connection

      connection
    end
  end
end
