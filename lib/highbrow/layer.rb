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

    def initialize(count, function = Function::Tanh.new, bias = true)
      @neurons = []
      count.times do
        item = Highbrow::Neuron::Standard.new
        item.function = function
        @neurons.push item
      end

      @neurons.push Highbrow::Neuron::Bias.new if bias
    end

    def with_bias(enabled)
      if enabled
        return false if bias?
        @neurons.push Highbrow::Neuron::Bias.new
      else
        return false unless bias?
        @neurons.delete_if! { |n| n.type == :bias }
      end

      self
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
