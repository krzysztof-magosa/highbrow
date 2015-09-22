module Highbrow
  # Represents input layer
  class InputLayer < Layer
    def initialize(count, bias = true)
      @neurons = []
      count.times do
        @neurons.push Highbrow::Neuron::Input.new
      end

      @neurons.push Highbrow::Neuron::Bias.new if bias
    end
  end
end
