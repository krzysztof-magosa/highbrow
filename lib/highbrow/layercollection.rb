require 'forwardable'

module Highbrow
  # Represents collection of layers
  class LayerCollection
    extend ::Forwardable
    def_delegator :@layers, :each
    def_delegator :@layers, :count
    def_delegator :@layers, :first
    def_delegator :@layers, :last

    def initialize
      @layers = []
    end

    def push(*items)
      items.each do |item|
        @layers.push item
        Layer.interconnect @layers[-2], @layers[-1] if @layers.count >= 2
      end

      self
    end
  end
end
