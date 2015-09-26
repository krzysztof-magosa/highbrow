module Highbrow
  module Neural
    module Activation
      # Represents base class for function
      class Base
        def primary(_input)
          fail 'Subclass must implement this method.'
        end

        def derivative(_output)
          fail 'Subclass must implement this method.'
        end
      end
    end
  end
end
