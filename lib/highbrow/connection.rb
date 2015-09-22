module Highbrow
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
      @weight = ((rand 2000)/1000.0) - 1
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
      target.inputs.push connection if target.respond_to? :inputs=

      connection
    end
  end
end
