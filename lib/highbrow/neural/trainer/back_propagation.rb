require 'ostruct'

module Highbrow
  module Neural
    module Trainer
      # Represents back propagation trainer
      class BackPropagation < Base
        attr_accessor :batch_mode

        def initialize(network)
          super

          @batch_corrections = Hash.new(0.0)
          @deltas = Hash.new(0.0)
          @last_changes = Hash.new(0.0)

          @flat_spots = {}
          @network.neurons.map(&:activation).uniq.each do |func|
            next if func.nil?
            @flat_spots[func] = func.flat_spot? ? 0.1 : 0.0
          end

          @neurons = @network.neurons.to_a
          @error_function = Neural::Error::MSE.new
        end

        def derivative(neuron)
          x = neuron.activation.derivative neuron.output
          @flat_spots[neuron.activation] + x
          #neuron.activation.flat_spot? ? (x + 0.1) : x
        end

        def update_neuron_weights(neuron)
          neuron.inputs.each do |conn|
            change = @learning_rate * @deltas[neuron] * conn.value
            change += @momentum * @last_changes[neuron]
            @last_changes[neuron] = change

            if @batch_mode
              @batch_corrections[conn] += change
            else
              conn.weight += change
            end
          end
        end

        def calc_output_deltas(pattern_error)
          @network.layers.last.neurons.each_with_index do |neuron, index|
            @deltas[neuron] = pattern_error[index] * derivative(neuron)
            update_neuron_weights neuron
          end
        end

        def calc_internal_deltas
          @network.layers.reverse[1..-2].each do |layer|
            layer.neurons.each do |neuron|
              next if neuron.bias?

              delta_sum = 0.0
              neuron.outputs.each do |conn|
                delta_sum += conn.weight * @deltas[conn.target]
              end

              @deltas[neuron] = derivative(neuron) * delta_sum

              update_neuron_weights neuron
            end
          end
        end

        def propagate(pattern_error)
          calc_output_deltas pattern_error
          calc_internal_deltas
        end

        def epoch
          @training_set.each do |input, expected|
            @network.input = input
            @network.activate

            @pattern_error = @error_function.calculate @network.output, expected
            propagate @pattern_error
          end
        end

        def apply_batch_corrections
          return false unless @batch_mode

          @batch_corrections.each do |conn, value|
            conn.weight += value
          end

          @batch_corrections.clear
        end
      end
    end
  end
end
