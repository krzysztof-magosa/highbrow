module Highbrow
  module Neural
    module Trainer
      module Plugin
        # Represents monitor plugin
        class Monitor < Base
          def initialize
            @cycles = 20
          end

          def post_epoch
            show if @trainer.iteration % @cycles == 1
          end

          def pre_train
            @start = Time.now
          end

          def post_train
            show if @last_show != @trainer.iteration && @trainer.iteration > 0
          end

          private

          def show
            timeperiod = Time.now - @start

            puts '-' * 30
            printf "epoch          : %d\n", @trainer.iteration
            printf "batch mode     : %s\n", @trainer.batch_mode ? 'yes' : 'no'
            printf "learning_rate  : %.5f\n", @trainer.learning_rate
            printf "momentum       : %.5f\n", @trainer.momentum
            printf "goal           : %.5f\n", @trainer.goal
            printf "error          : %.5f\n", @trainer.prev_epoch_error
            printf "time           : %.2fs\n", timeperiod
            printf "speed          : %.2f epoch/s\n", @trainer.iteration / timeperiod
            printf "epoch time     : %.5f s\n", timeperiod / @trainer.iteration

            @last_show = @trainer.iteration
          end
        end
      end
    end
  end
end
