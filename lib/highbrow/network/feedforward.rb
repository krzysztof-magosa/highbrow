require 'json'

module Highbrow
  module Network
    # Represents feed forward network
    class FeedForward
      attr_reader :layers

      def initialize
        @layers = []
      end

      # Activate all neurons in network.
      # Forward over all layers.
      def activate
        @layers.each(&:activate)
      end

      # Returns values from output layer
      def output
        @layers.last.neurons.map(&:output)
      end

      # Sets input for network
      def input=(data)
        layer = @layers.first

        count = layer.neurons.count - (layer.bias? ? 1 : 0)
        fail 'Mismatch between input data and neurons' if count != data.count

        data.each_with_index do |value, index|
          layer.neurons[index].input = value
        end
      end

      def add_layer(layer)
        @layers.push layer
        self
      end

      # Returns enumerator of all neurons in network
      def neurons
        Enumerator.new do |enum|
          @layers.each do |layer|
            layer.neurons.each do |neuron|
              enum << neuron
            end
          end
        end
      end

      # Returns enumerator of all inputs in network
      def inputs
        Enumerator.new do |enum|
          neurons.each do |neuron|
            neuron.inputs.each do |conn|
              enum << conn
            end
          end
        end
      end

      # Finalizes network structures.
      # Creates connections between neurons and so on.
      def finalize!
        fail 'Network must have at least 2 layers.' if @layers.count < 2
        fail 'Bias cannot be placed in output layer.' if @layers.last.bias?

        # 1,2,3 => 1->2, 2->3
        @layers[0...-1].zip(@layers[1..-1]).each do |pair|
          Layer.interconnect pair[0], pair[1]
        end
      end

      def self.load(path)
        content = File.read(path)
        yaml = YAML.load(content)

        fail if yaml[:serial] != 1
        fail if yaml[:class] != name

        net = Object.const_get(yaml[:class]).new # from_parameters?

        functions = {}
        yaml[:functions].each do |id, item|
          next if item[:class] == 'NilClass'
          functions[id] = Object.const_get(item[:class]).from_parameters(item[:parameters])
        end

        neurons = {}
        yaml[:neurons].each do |id, item|
          item[:parameters][:function] = functions[item[:parameters][:function]]
          neurons[id] = Object.const_get(item[:class]).from_parameters(item[:parameters])
        end

        layers = {}
        yaml[:layers].each do |id, item|
          layers[id] = Object.const_get(item[:class]).from_parameters(item[:parameters])
          net.layers.push layers[id]

          item[:neurons].each do |nid|
            layers[id].neurons.push neurons[nid]
          end
        end

        connections = {}
        yaml[:connections].each do |id, item|
          item[:parameters][:source] = neurons[item[:parameters][:source]]
          item[:parameters][:target] = neurons[item[:parameters][:target]]
          connections[id] = Object.const_get(item[:class]).from_parameters(item[:parameters])
        end

        net
      end
    end
  end
end
