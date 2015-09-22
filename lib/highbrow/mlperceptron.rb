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

    def input=(data)
      data.each_with_index do |value, index|
        @layers.first[index].input = value
      end

      self
    end

    def neurons
      Enumerator.new do |x|
        @layers.each do |layer|
          layer.each do |neuron|
            x << neuron
          end
        end
      end
    end

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
  end
end
