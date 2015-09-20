module Highbrow
  # Represents input layer
  class InputLayer < Layer
    def initialize(count)
      @neurons = []
      count.times do
        @neurons.push InputNeuron.new
      end
    end
  end
end
