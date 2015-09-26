require 'ostruct'

module Highbrow
  module Neural
    module Trainer
      # Represents back propagation trainer
      class BackPropagation < Base
        # Represents training data used by backpropagation
        class TrainingDataItem
          attr_accessor :delta
          attr_accessor :correction

          def initialize
            @delta = 0.0
            @correction = 0.0
          end
        end

        attr_accessor :batch_mode

        def initialize(network)
          super

          @training_data = {}
          @training_data.default_proc = proc do |hash, key|
            hash[key] = TrainingDataItem.new
          end

          @batch_corrections = Hash.new(0.0)
        end

        def derivative(neuron)
          x = neuron.activation.derivative neuron.output
          x += 0.1 if neuron.activation.flat_spot?
          x
        end

        def calc_output_deltas(neuron, ideal)
          error = ideal - neuron.output
          @training_data[neuron].delta = error * derivative(neuron)
        end

        def propagate_hidden(neuron)
          sum = 0.0

          neuron.outputs.each do |conn|
            sum += conn.weight * @training_data[conn.target].delta
          end

          @training_data[neuron].delta = derivative(neuron) * sum
        end

        def update_weights(neuron)
          training_data = @training_data[neuron]

          neuron.inputs.each do |conn|
            correction = @learning_rate * training_data.delta * conn.value
            # correction += @momentum * training_data.correction

            if @batch_mode
              @batch_corrections[conn] += correction + (@momentum * training_data.correction)
            else
              conn.weight += correction + (@momentum * training_data.correction)
            end

            training_data.correction = correction
          end
        end

        def propagate(expected)
          @network.layers[1..-1].reverse_each do |layer|
            # @back_layers.each do |layer|
            layer.neurons.each_with_index do |neuron, index|
              next if neuron.bias?

              if layer == @network.layers.last
                calc_output_deltas neuron, expected[index]
              else
                propagate_hidden neuron
              end

              update_weights neuron
            end
          end
        end

        def epoch
          @training_set.shuffle.each do |input, expected|
            @network.input = input
            @network.activate
            propagate expected
          end

          apply_batch_corrections
        end

        def apply_batch_corrections
          return false unless @batch_mode

          @batch_corrections.each do |k, v|
            k.weight += v
          end

          @batch_corrections.clear
        end
      end
    end
  end
end
