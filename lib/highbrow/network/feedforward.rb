module Highbrow
  module Network
    # Represents feed forward network
    class FeedForward
      attr_reader :layers

      def initialize
        @layers = []
      end

      def activate
        @layers.each(&:activate)
      end

      def output
        @layers.last.map(&:output)
      end

      def input=(data)
        data.each_with_index do |value, index|
          @layers.first[index].input = value
        end

        self
      end

      # Returns enumerator of all neurons in network
      def neurons
        Enumerator.new do |x|
          @layers.each do |layer|
            layer.each do |neuron|
              x << neuron
            end
          end
        end
      end

      # Returns enumerator of all inputs in network
      def inputs
        Enumerator.new do |x|
          @layers.each do |layer|
            layer.each do |neuron|
              next unless neuron.respond_to? :inputs

              neuron.inputs.each do |conn|
                x << conn
              end
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
    end
  end
end
