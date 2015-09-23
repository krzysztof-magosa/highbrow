module Highbrow
  # Represents input layer
  class InputLayer < Layer
    def initialize(neurons:, bias: true)
      @neuron_class = Highbrow::Neuron::Input
      super
    end
  end
end
