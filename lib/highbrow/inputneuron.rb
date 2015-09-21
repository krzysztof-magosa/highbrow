module Highbrow
  # Represents input neuron
  class InputNeuron < Neuron
    attr_accessor :input

    def initialize
      super
    end

    # Input neuron just pass input to output
    def activate
      # do nothing
    end

    # Provide input value into output
    def output
      @input
    end
  end
end
