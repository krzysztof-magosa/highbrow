module Highbrow
  module Plugin
    class SmartMomentum < Base
      MIN_IMPROVEMENT = 0.0001
      MAX_MOMENTUM = 4
      START_MOMENTUM = 0.1
      MOMENTUM_INCREASE = 0.01
      MOMENTUM_CYCLES = 10

      attr_accessor :trainer

      def initialize
      end

      def init
        @trainer.momentum = 0.0
      end

      def pre_epoch
      end

      def post_epoch
        @trainer.momentum = Random.rand(0.10..0.70)
      end
    end
  end
end
