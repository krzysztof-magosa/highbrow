require_relative '../lib/highbrow.rb'

xor_truth = [
  [[-0.9, -0.9], [-0.9]],
  [[0.9, -0.9], [0.9]],
  [[-0.9, 0.9], [0.9]],
  [[0.9, 0.9], [-0.9]]
]

net = Highbrow::Network::MLPerceptron.new
net.layers.push Highbrow::InputLayer.new(2)
net.layers.push Highbrow::Layer.new(8, Highbrow::Function::Tanh.new)
net.layers.push Highbrow::Layer.new(1, Highbrow::Function::Tanh.new, false)

bp = Highbrow::Trainer::BackPropagation.new net
bp.training_set.push(*xor_truth)
bp.momentum = 0.1
bp.learning_rate = 0.25
bp.goal = 0.05
# bp.learning_rate = 0.9
bp.plug(Highbrow::Plugin::SmartLearningRate.new)
#bp.plug(Highbrow::Plugin::SmartMomentum.new)
bp.plug(Highbrow::Plugin::Monitor.new)

bp.train

#bp.batch_mode = true
#bp.goal = 0.01

#bp.train

puts '---'

net.input = [1.0, 1.0]
net.activate
puts net.output

net.input = [-1.0, 1.0]
net.activate
puts net.output
