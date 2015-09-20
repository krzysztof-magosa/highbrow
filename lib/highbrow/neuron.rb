module Highbrow
  # Represents one neuron
  class Neuron
    attr_accessor :function
    attr_reader :inputs
    attr_reader :outputs
    attr_reader :output

    def initialize
      @inputs = []
      @outputs = []
    end

    def inputs_sum
      @inputs.inject(0) do |sum, input|
        sum + input.weighed_value
      end
    end

    def activate
      @output = @function.primary(inputs_sum)
    end
  end
end
