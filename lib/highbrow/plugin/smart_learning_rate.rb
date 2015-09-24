module Highbrow
  module Plugin
    # Represents smart learning rate plugin
    class SmartLearningRate < Base
      def initialize(min_rate: 0.00001, max_rate: 1.0, rate_inc: 1.05, rate_dec: 0.7, max_perf_inc: 1.04, min_perf_inc: 1.0)
        @ready = false

        @min_rate = min_rate
        @max_rate = max_rate

        @rate_inc = rate_inc
        @rate_dec = rate_dec

        @max_perf_inc = max_perf_inc
        @min_perf_inc = min_perf_inc
      end

      def init
        @trainer.learning_rate = @max_rate / @trainer.training_set.count
      end

      def pre_epoch
        @last_error = @trainer.last_epoch_error
      end

      def post_epoch
        if @ready
          ratio = @trainer.last_epoch_error / @last_error

          if ratio > @max_perf_inc
            adjust_rate @rate_dec
          elsif ratio < @min_perf_inc
            adjust_rate @rate_inc
          end
        end

        @ready = true unless @ready
      end

      private

      def adjust_rate(ratio)
        rate = @trainer.learning_rate * ratio
        #return MAX_RATE if rate > MAX_RATE
        #return MIN_RATE if rate < MIN_RATE
        #rate

        #rate = [MAX_RATE, rate].min
        #rate = [MIN_RATE, rate].max
        rate = @max_rate if rate > @max_rate
        rate = @min_rate if rate < @min_rate

        @trainer.learning_rate = rate
      end
    end
  end
end
