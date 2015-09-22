module Highbrow
  module Plugin
    # Represents smart learning rate plugin
    class SmartLearningRate < Base
      def initialize
        @ready = false
        @last_weights = {}
      end

      def init
        @trainer.learning_rate = 1.0 / @trainer.training_set.count
      end

      def pre_epoch
        @last_error = @trainer.last_epoch_error

        @last_weights = {}
        @trainer.network.inputs.each do |conn|
          @last_weights[conn] = conn.weight
        end
      end

      def post_epoch
        if @ready
          ratio = @trainer.last_epoch_error / @last_error
          if ratio > 1.04
            adjust_rate 0.7
#
            #puts 'ROLLBACK!'
            #@trainer.network.inputs.each do |conn|
            #  conn.weight = @last_weights[conn]
            #end
#
            #@trainer.rollback
          elsif ratio < 1.0
            adjust_rate 1.05
          end
        end

        @ready = true unless @ready
      end

      private

      def adjust_rate(ratio)
        rate = @trainer.learning_rate * ratio

        rate = 1.0 if rate > 1.0
        rate = 0.01 if rate <= 0.0

        @trainer.learning_rate = rate
      end
    end
  end
end
