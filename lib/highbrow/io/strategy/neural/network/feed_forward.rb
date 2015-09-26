module Highbrow
  module IO
    module Strategy
      module Neural
        # IO Strategy for FeedForward network
        class FeedForward
          def self.supported_classes
            [Highbrow::Neural::Network::FeedForward.name]
          end

          def self.version
            1
          end

          def dump(object)
            {
              meta: {
                version: self.class.version
              },
              data: object
            }
          end

          def parse(data)
            fail if data[:meta][:version] != self.class.version
            data[:data]
          end
        end
      end
    end
  end
end
