module Highbrow
  # Represents Multi Layer Perceptron
  class MLPerceptron
    attr_reader :layers

    def initialize
      @layers = LayerCollection.new
    end

    def activate
      @layers.each(&:activate)
    end

    def output
      @layers.last.map(&:output)
    end
  end
end
