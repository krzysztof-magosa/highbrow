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
        attr_accessor :max_epochs
        attr_reader :prev_epoch_error
        attr_reader :iteration

        def initialize(network)
          @network = network
          @plugins = []
          @training_set = []
          @goal = 0.05
          @max_epochs = Float::INFINITY
          @momentum = 0.7
          @learning_rate = 0.9
          @iteration = 0

          @set_size = 0
        end

        def plug(plugin)
          plugin.trainer = self
          plugin.init
          @plugins.push plugin
        end

        def pre_train
          @iteration = 0
          @plugins.each(&:pre_train)
        end

        def pre_epoch
          @iteration += 1
          @prev_epoch_error = @error_function.total_error
          @error_function.reset
          @plugins.each(&:pre_epoch)
        end

        def post_epoch
          apply_batch_corrections
          @plugins.each(&:post_epoch)
        end

        def post_train
          @plugins.each(&:post_train)
        end

        def train
          pre_train

          loop do
            pre_epoch
            epoch
            post_epoch

            break if @prev_epoch_error <= @goal
            break if @iteration >= @max_epochs
          end

          post_train
        end

        def epoch
          fail 'This method must be implemented in child class.'
        end
      end
    end
  end
end
