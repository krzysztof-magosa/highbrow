module Highbrow
  # Represents standard neuron
  class Neuron
    attr_accessor :input
    attr_accessor :inputs
    attr_reader :bias
    alias_method :bias?, :bias
    attr_accessor :function
    attr_reader :outputs
    attr_reader :output

    def initialize(bias: false)
      @inputs = []
      @outputs = []
      @output = 0.0

      @bias = bias
      @input = 1.0 if bias
    end

    def inputs_sum
      @inputs.map(&:weighed_value).reduce(:+)
    end

    def activate
      value = @input.nil? ? inputs_sum : @input
      @output = @function.nil? ? value : @function.primary(value)
    end
  end
end
