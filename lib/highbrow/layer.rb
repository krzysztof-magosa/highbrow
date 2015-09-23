require 'forwardable'

module Highbrow
  # Represents layer of feed forward network
  class Layer
    extend ::Forwardable
    def_delegator :@neurons, :map
    def_delegator :@neurons, :each
    def_delegator :@neurons, :each_with_index
    def_delegator :@neurons, :[]

    attr_reader :neurons

    def initialize(neurons:, bias: false, function: Function::Tanh.new)
      @neurons = []
      @neuron_class = Highbrow::Neuron unless @neuron_class

      create_neurons neurons, function
      create_bias if bias
    end

    def create_neurons(count, function)
      fail 'Layer cannot be empty' if count == 0

      count.times do
        item = @neuron_class.new
        item.function = function
        @neurons.push item
      end
    end

    def create_bias
      item = Highbrow::Neuron.new
      item.function = nil
      item.input = 1.0
      item.bias = true
      @neurons.push item
    end

    def bias?
      @neurons.any? { |n| n.type == :bias }
    end

    def activate
      @neurons.each(&:activate)
    end

    def self.interconnect(source, target)
      source.neurons.each do |sn|
        target.neurons.each do |tn|
          next if tn.type == :bias
          Connection.interconnect sn, tn
        end
      end
    end
  end
end
