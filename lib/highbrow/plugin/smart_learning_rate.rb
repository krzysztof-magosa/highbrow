module Highbrow
  module Plugin
    # Represents smart learning rate plugin
    class SmartLearningRate
      attr_accessor :trainer

      def initialize
        @ready = false
      end

      def init
        @trainer.learning_rate = 1.0 / @trainer.training_set.count
      end

      def pre_epoch
        @last_error = @trainer.last_epoch_error
      end

      def post_epoch
        if @ready
          ratio = @trainer.last_epoch_error / @last_error

          if ratio > 1.04
            adjust_rate 0.7
          elsif ratio < 0.0
            adjust_rate 1.02
          end
        end

        @ready = true unless @ready
      end

      private

      def adjust_rate(ratio)
        rate = @trainer.learning_rate * ratio

        rate = 1.0 if rate > 1.0
        rate = 0.000001 if rate <= 0.0

        @trainer.learning_rate = rate
      end
    end
  end
end
