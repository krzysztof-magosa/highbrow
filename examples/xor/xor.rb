require_relative '../../lib/highbrow'

# Training set
training_set = [
  [[-1, -1], [-1]],
  [[-1, 1], [1]],
  [[1, -1], [1]],
  [[1, 1], [-1]]
]

srand 1

# Alias module for shorter form
Neural = Highbrow::Neural

# Network structure
tanh = Neural::Activation::Tanh.new
tanh.beta = 2.0

network = Neural::Network::FeedForward.new
network.add_layer Neural::Layer.new neurons: 2, activation: nil, bias: true
network.add_layer Neural::Layer.new neurons: 2, bias: true, activation: tanh
network.add_layer Neural::Layer.new neurons: 1, activation: tanh
network.finalize!

# Training settings
trainer = Neural::Trainer::BackPropagation.new network
trainer.plug Neural::Trainer::Plugin::Monitor.new
trainer.plug Neural::Trainer::Plugin::SmartLearningRate.new
trainer.training_set.push(*training_set)
trainer.goal = 0.01
trainer.max_epochs = 2000
trainer.momentum = 0.70
trainer.batch_mode = true
trainer.train

# Test
puts "\nTest"
puts '==========='
training_set.each do |item|
  network.input = item[0]
  network.activate
  printf "%2.0f XOR %2.0f = %f\n", item[0][0], item[0][1], network.output[0]
end
