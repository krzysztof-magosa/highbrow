module Highbrow
  module Plugin
    # Represents monitor plugin
    class Monitor < Base
      def initialize
        @iteration = 0
        @cycles = 25
      end

      def pre_epoch
        @previous_error = @trainer.last_epoch_error
      end

      def post_epoch
        @iteration += 1
        show if @iteration % @cycles == 1
      end

      def pre_train
        @start = Time.now
      end

      def post_train
        show if @last_show != @iteration && @iteration > 0
      end

      private

      def show
        timeperiod = Time.now - @start

        puts '-' * 30
        printf "epoch          : %d\n", @iteration
        printf "batch mode     : %s\n", @trainer.batch_mode ? 'yes' : 'no'
        printf "learning_rate  : %.5f\n", @trainer.learning_rate
        printf "momentum       : %.5f\n", @trainer.momentum
        printf "goal           : %.5f\n", @trainer.goal
        printf "error          : %.5f\n", @trainer.last_epoch_error
        printf "previous error : %.5f\n", @previous_error
        printf "time           : %.2fs\n", timeperiod
        printf "speed          : %.2f epoch/s\n", @iteration / timeperiod

        @last_show = @iteration
      end
    end
  end
end
