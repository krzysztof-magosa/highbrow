module Highbrow
  module Neural
    # Represents layer of feed forward network
    class Layer
      attr_reader :neurons

      def initialize(neurons:, bias: false, activation: Activation::Sigmoid.new)
        @neurons = []

        neurons.times do
          item = Neuron.new
          item.activation = activation
          @neurons.push item
        end

        @neurons.push Neuron.new(bias: true) if bias
      end

      def bias?
        @neurons.any?(&:bias?)
      end

      def activate
        @neurons.each(&:activate)
      end

      def self.interconnect(source, target)
        source.neurons.each do |sn|
          target.neurons.each do |tn|
            next if tn.bias?
            Connection.new sn, tn
          end
        end
      end
    end
  end
end
