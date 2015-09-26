module Highbrow
  module Neural
    # Represents layer of feed forward network
    class Layer
      attr_reader :neurons

      def initialize(neurons:, bias: false, activation: Activation::Tanh.new)
        @neurons = []
        create_neurons neurons, activation
        @neurons.push Highbrow::Neural::Neuron.new(bias: true) if bias
      end

      def create_neurons(count, activation)
        count.times do
          item = Highbrow::Neural::Neuron.new
          item.activation = activation
          @neurons.push item
        end
      end

      def bias?
        # bias neuron is usually on the end
        @neurons.reverse.any?(&:bias?)
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
