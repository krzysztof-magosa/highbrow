require 'ostruct'

module Highbrow
  # Represents back propagation teacher
  module Trainer
    # Represents back propagation trainer
    class BackPropagation < Base
      attr_accessor :batch_mode

      def initialize(network)
        super

        @training_data = {}
        @network.neurons.each do |neuron|
          @training_data[neuron] = OpenStruct.new(gradient: 0.0, correction: 0.0)
        end

        @corrections = Hash.new(0.0)
      end

      def propagate(expected)
        @network.layers.reverse[0..-2].each do |layer|
          layer.each_with_index do |neuron, index|
            next if neuron.type == :bias

            if layer == @network.layers.last
              # output layer
              derivative = neuron.function.derivative(neuron.output)

              @training_data[neuron].gradient = (expected[index] - neuron.output) * derivative
            else
              # other layer - except input
              product_sum = 0.0

              neuron.outputs.each do |conn|
                product_sum += @training_data[conn.target].gradient * conn.weight
              end

              @training_data[neuron].gradient = neuron.function.derivative(neuron.output) * product_sum
#              puts "i=#{neuron.inputs_sum}"
#              puts "o=#{neuron.output}"
              ##@training_data[neuron].gradient = neuron.function.derivative(neuron.inputs_sum) * product_sum
            end

            neuron.inputs.each do |conn|
              correction = @learning_rate * conn.value * @training_data[neuron].gradient

              correction += (@momentum * @training_data[neuron].correction)
              # conn.weight += (correction + (@momentum * @training_data[neuron].correction))

              if @batch_mode
                @corrections[conn] += correction
              else
                conn.weight += correction
              end

              @training_data[neuron].correction = correction
            end
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

        @corrections.clear if @batch_mode
        @training_set.shuffle.each do |input, expected|
          @network.input = input
          @network.activate
          propagate expected
        end

        if @batch_mode
          @corrections.each do |k, v|
            k.weight += v
          end
        end
      end
    end
  end
end
