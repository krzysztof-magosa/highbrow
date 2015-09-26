module Highbrow
  module Neural
    module Trainer
      # Represents base trainer
      class Base
        attr_reader :network
        attr_reader :training_set
        attr_accessor :learning_rate
        attr_accessor :momentum
        attr_accessor :goal
        attr_reader :last_epoch_error

        def initialize(network)
          @network = network
          @plugins = []
          @training_set = []
          @goal = 0.05
          @momentum = 0.7
          @learning_rate = 0.9

          @set_size = 0
        end

        # Calculates squared error for specified traing pair
        def squared_error(training_pair)
          @network.input = training_pair[0]
          @network.activate

          error = 0.0
          @network.output.zip(training_pair[1]).each do |a, e|
            error += (e - a)**2
            @set_size += 1
          end

          error
        end

        # Calculates squared error for epoch
        def squared_epoch_error
          error = 0.0
          @training_set.each do |pair|
            error += squared_error pair
          end

          @last_epoch_error = error / @set_size.to_f
          @set_size = 0.0
        end

        def plug(plugin)
          plugin.trainer = self
          plugin.init
          @plugins.push plugin
        end

        def train
          squared_epoch_error
          @plugins.each(&:pre_train)

          while @last_epoch_error > @goal
            @plugins.each(&:pre_epoch)
            epoch
            squared_epoch_error
            @plugins.each(&:post_epoch)
          end

          @plugins.each(&:post_train)
        end

        def epoch
          fail 'This method must be implemented in child class.'
        end
      end
    end
  end
end
