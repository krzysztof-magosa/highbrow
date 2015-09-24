require 'forwardable'

module Highbrow
  # Represents layer of feed forward network
  class Layer
    extend ::Forwardable
    attr_reader :neurons

    def initialize(neurons:, bias: false, function: Function::Tanh.new)
      @neurons = []
      create_neurons neurons, function
      @neurons.push Highbrow::Neuron.new(bias: true) if bias
    end

    def create_neurons(count, function)
      fail 'Layer cannot be empty' if count == 0

      count.times do
        item = Highbrow::Neuron.new
        item.function = function
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
          Connection.interconnect sn, tn
        end
      end
    end
  end
end
