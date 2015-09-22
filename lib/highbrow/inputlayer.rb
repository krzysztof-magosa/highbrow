module Highbrow
  # Represents input layer
  class InputLayer < Layer
    def initialize(count)
      @neurons = []
      count.times do
        @neurons.push Highbrow::Neuron::Input.new
      end

      @neurons.push Highbrow::Neuron::Bias.new
    end
  end
end
