require 'yaml'

module Highbrow
  module IO
    # Dumps, parses, loads and saves Highbrow objects
    class Store
      def initialize
        @strategies = {}
        register_builtin_strategies
      end

      def self.version
        1
      end

      def dump(object)
        fail unless @strategies.key? object.class.name
        strategy = Object.const_get(@strategies[object.class.name]).new

        {
          meta: {
            version: self.class.version,
            system: {
              highbrow: '0.1.0', # @TODO
              ruby: RUBY_VERSION
            },
            io_strategy: strategy.class.name,
            object: object.class.name,
            timestamp: Time.now.to_i
          },
          data: strategy.dump(object)
        }
      end

      def parse(content)
        dump = YAML.load content

        fail if dump[:meta][:version] != self.class.version
        fail unless @strategies.keys.include? dump[:meta][:object]
        strategy = Object.const_get(@strategies[dump[:meta][:object]]).new
        strategy.parse(dump[:data])
      end

      def save(object, path)
        data = dump object
        File.write path, data.to_yaml
      end

      def load(path)
        content = File.read path
        parse content
      end

      def register_strategy(strategy_name)
        strategy = Object.const_get strategy_name
        strategy.supported_classes.each do |class_name|
          fail if @strategies.key? class_name
          @strategies[class_name] = strategy_name
        end
      end

      protected

      def register_builtin_strategies
        register_strategy Highbrow::IO::Strategy::Neural::FeedForward.name
      end
    end
  end
end
