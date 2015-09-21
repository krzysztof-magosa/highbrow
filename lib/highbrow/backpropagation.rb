require 'ostruct'

module Highbrow
  # Represents back propagation teacher
  class BackPropagation < Trainer
    def initialize(network)
      super

      @training_data = {}
      @network.neurons.each do |neuron|
        @training_data[neuron] = OpenStruct.new(gradient: 0.0, correction: 0.0)
      end
    end

    def propagate(expected)
      @network.layers.reverse[0..-2].each do |layer|
        layer.each_with_index do |neuron, index|
          # next if neuron.bias?

          if layer == @network.layers.last
            # output layer
            derivative = neuron.function.derivative(neuron.output)
            derivative += 0.1 if neuron.function.flat_spot?

            @training_data[neuron].gradient = (expected[index] - neuron.output) * derivative
          else
            # other layer - except input
            product_sum = 0.0

            neuron.outputs.each do |conn|
              product_sum += @training_data[conn.target].gradient * conn.weight
            end

            @training_data[neuron].gradient = neuron.function.derivative(neuron.output) * product_sum
          end

          neuron.inputs.each do |conn|
            correction = @learning_rate * conn.value * @training_data[neuron].gradient
            conn.weight += (correction + (@momentum * @training_data[neuron].correction))
            @training_data[neuron].correction = correction
          end
        end
      end
    end

    def epoch
      @training_set.shuffle.each do |input, expected|
        @network.input = input
        @network.activate
        propagate expected
      end
    end
  end
end
