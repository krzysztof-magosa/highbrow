module Highbrow
  # Represents standard neuron
  class Neuron
    @@serial = 1

    attr_reader :serial
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
      # @input = 0.5 + (rand(1000) / 2000.0) if bias
      @input = 1.0 if bias
      @function = function

      @serial = @@serial
      @@serial += 1
    end

    def activate
      value = @input.nil? ? inputs_sum : @input.to_f
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

    def io_save
      {
        serial: @serial,
        bias: @bias,
      }
    end
  end
end
