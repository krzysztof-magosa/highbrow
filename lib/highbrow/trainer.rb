module Highbrow
  class Trainer
    attr_reader :network
    attr_accessor :training_set
    attr_accessor :learning_rate
    attr_accessor :momentum
    attr_reader :last_epoch_error

    def initialize(network)
      @network = network
      @plugins = []
      @training_set = []
      @goal = 0.05
      @momentum = 0.3
      @learning_rate = 0.3
    end

    # Calculates squared error for specified traing pair
    def squared_error(training_pair)
      @network.input = training_pair[0]
      @network.activate

      error = 0.0
      @network.output.zip(training_pair[1]).each do |a, e|
        error += (a - e)**2
      end

      error
    end

    # Calculates squared error for epoch
    def squared_epoch_error
      error = 0.0
      @training_set.each do |pair|
        error += squared_error pair
      end

      @last_epoch_error = Math.sqrt(error / @training_set.count)
    end

    def plug(plugin)
      plugin.trainer = self if plugin.respond_to? :trainer=
      plugin.init
      @plugins.push plugin
    end

    def train
      squared_epoch_error

      nr = 0
      while @last_epoch_error > @goal
        @plugins.each(&:pre_epoch)
        epoch
        squared_epoch_error
        @plugins.each(&:post_epoch)

        #puts @last_epoch_error
        nr += 1
      end

      puts nr
    end

    def epoch
      fail 'This method must be implemented in child class.'
    end
  end
end
