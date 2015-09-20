require 'forwardable'

module Highbrow
  # Represents layer of feed forward network
  class Layer
    extend ::Forwardable
    def_delegator :@neurons, :map
    def_delegator :@neurons, :[]

    attr_reader :neurons

    def initialize(count, function = Function::Tanh.new, bias = false)
      @neurons = []
      count.times do
        item = Neuron.new
        item.function = function
        @neurons.push item
      end
    end

    def activate
      @neurons.each(&:activate)
    end

    def self.interconnect(source, target)
      source.neurons.each do |sn|
        target.neurons.each do |tn|
          Connection.interconnect sn, tn
        end
      end
    end
  end
end
