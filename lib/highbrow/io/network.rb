require 'yaml'

module Highbrow
  module IO
    # Saves and loads knowledge from and to network
    class Network
      def self.save(network, path)
        result = {
          serial: 1,
          network: network.class.name,
          neurons: [],
          connections: []
        }

        network.neurons.each do |neuron|
          item = {
            serial: neuron.serial,
            bias: neuron.bias?
          }
          result[:neurons].push item
        end

        File.write path, result.to_yaml
      end
    end
  end
end
