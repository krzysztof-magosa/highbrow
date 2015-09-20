module Highbrow
  # Represents input neuron
  class InputNeuron < Neuron
    attr_accessor :input

    def initialize
      super
    end

    def activate
      @output = @input
    end
  end
end
