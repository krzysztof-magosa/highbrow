module Highbrow
  module Neural
    module Trainer
      module Plugin
        # Represents base plugin
        class Base
          attr_accessor :trainer

          def init
          end

          def pre_epoch
          end

          def post_epoch
          end

          def pre_train
          end

          def post_train
          end
        end
      end
    end
  end
end
