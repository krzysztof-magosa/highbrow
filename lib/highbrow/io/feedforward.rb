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
    end
  end
end
