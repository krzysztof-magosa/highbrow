module Highbrow
  module IO
    # Class loads/saves FeedForward network from/to YAML file
    class FeedForward
      def initialize(net: nil)
        @net = net
      end

      def serialize_layers
        result = {}
        @net.layers.each do |layer|
          result[layer.object_id] = {
            class: layer.class.name,
            parameters: layer.respond_to?(:parameters) ? layer.parameters : {},
            neurons: layer.neurons.map(&:object_id)
          }
        end

        result
      end

      def serialize_functions
        result = {}
        @net.neurons.map(&:function).uniq.each do |function|
          parameters = function.respond_to?(:parameters) ? function.parameters : {}

          result[function.object_id] = {
            class: function.class.name,
            parameters: parameters
          }
        end

        result
      end

      def serialize_neurons
        result = {}
        @net.neurons.each do |neuron|
          parameters = neuron.respond_to?(:parameters) ? neuron.parameters : {}
          parameters[:function] = parameters[:function].object_id

          result[neuron.object_id] = {
            class: neuron.class.name,
            parameters: parameters
          }
        end

        result
      end

      def serialize_connections
        result = {}
        @net.neurons.map(&:inputs).concat(@net.neurons.map(&:outputs)).flatten.uniq.each do |conn|
          parameters = conn.respond_to?(:parameters) ? conn.parameters : {}
          parameters[:source] = parameters[:source].object_id
          parameters[:target] = parameters[:target].object_id

          result[conn.object_id] = {
            class: conn.class.name,
            parameters: parameters
          }
        end

        result
      end

      def save(path)
        fail 'You must construct this object with net.' if @net.nil?

        result = {
          serial: 1,
          class: net.class.name,
          layers: serialize_layers,
          functions: serialize_functions,
          neurons: serialize_neurons,
          connections: serialize_connections
        }

        File.write path, result.to_yaml
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
