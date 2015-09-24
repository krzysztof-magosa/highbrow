require 'ostruct'

module Highbrow
  module Trainer
    # Represents back propagation trainer
    class BackPropagation < Base
      # Represents training data used by backpropagation
      class TrainingDataItem
        attr_accessor :gradient
        attr_accessor :correction

        def initialize
          @gradient = 0.0
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

      def propagate_output(neuron, ideal)
        derivative = neuron.function.derivative(neuron.output)
        error = ideal - neuron.output
        @training_data[neuron].gradient = error * derivative
      end

      def propagate_hidden(neuron)
        product_sum = 0.0

        neuron.outputs.each do |conn|
          product_sum += @training_data[conn.target].gradient * conn.weight
        end

        @training_data[neuron].gradient = neuron.function.derivative(neuron.output) * product_sum
      end

      def update_weights(neuron)
        training_data = @training_data[neuron]

        neuron.inputs.each do |conn|
          correction = @learning_rate * conn.value * training_data.gradient
          correction += @momentum * training_data.correction

          if @batch_mode
            @batch_corrections[conn] += correction
          else
            conn.weight += correction
          end

          training_data.correction = correction
        end
      end

      def propagate(expected)
        @network.layers.reverse[0..-2].each do |layer|
          layer.neurons.reject(&:bias?).each_with_index do |neuron, index|
            if layer == @network.layers.last
              propagate_output neuron, expected[index]
            else
              propagate_hidden neuron
            end

            update_weights neuron
          end
        end
      end

      def backup
        # fail
        @training_data_backup = {}
        @training_data.each do |key, item|
          @training_data_backup[key] = Marshal.dump(item)
        end
      end

      def rollback
        # fail
        @training_data_backup.each do |key, item|
          @training_data[key] = Marshal.load(item)
        end
      end

      def epoch
        # backup

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
