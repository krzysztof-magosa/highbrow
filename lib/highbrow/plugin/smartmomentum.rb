module Highbrow
  module Plugin
    class SmartMomentum
      MIN_IMPROVEMENT = 0.0001
      MAX_MOMENTUM = 4
      START_MOMENTUM = 0.1
      MOMENTUM_INCREASE = 0.01
      MOMENTUM_CYCLES = 10

      attr_accessor :trainer

      def initialize
        @last_improvement = 0.0
        @last_error = 0.0
        @last_momentum = 0.0
        @current_momentum = 0.0
        @ready = false
      end

      def init
        @trainer.momentum = 0.0
      end

      def pre_epoch
        @last_error = @trainer.last_epoch_error
      end

      def post_epoch
        if @ready
          current_error = @trainer.last_epoch_error
#          puts "current = #{current_error}"
#          puts "last    = #{@last_error}"
          @last_improvement = (current_error - @last_error) / @last_error
#          puts @last_improvement
#          puts "improv  = #{@last_improvement}"
#          puts

          if (@last_improvement > 0.0) || (@last_improvement.abs < MIN_IMPROVEMENT)
            @last_momentum += 1

            if @last_momentum > MOMENTUM_CYCLES
              @last_momentum = 0

              if @current_momentum.to_i == 0
                @current_momentum = START_MOMENTUM
              end

              @current_momentum *= (1.0 + MOMENTUM_INCREASE)

              @trainer.momentum = @current_momentum
#              puts @current_momentum
            end
          else
            @current_momentum = 0.0
            @trainer.momentum = 0.0
          end
        end

        @ready = true unless @ready
      end
    end
  end
end
