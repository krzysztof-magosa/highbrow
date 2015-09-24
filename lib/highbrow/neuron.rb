module Highbrow
  # Represents standard neuron
  class Neuron
    attr_accessor :input
    attr_reader :inputs
    attr_reader :bias
    alias_method :bias?, :bias
    attr_accessor :function
    attr_reader :outputs
    attr_reader :output

    def initialize(bias: false, function: nil)
      @inputs = []
      @outputs = []
      @output = 0.0

      @bias = bias
      @input = 1.0 if bias
      @function = function
    end

    def activate
      value = @input.nil? ? inputs_sum : @input
      @output = @function.nil? ? value : @function.primary(value)
    end

    private

    def inputs_sum
      # @inputs.map(&:weighed_value).reduce(:+)
      sum = 0.0

      @inputs.each do |item|
        sum += item.weighed_value
      end

      sum
    end
  end
end
