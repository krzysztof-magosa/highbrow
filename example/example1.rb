require_relative '../lib/highbrow.rb'

xor_truth = [
  [[-1, -1], [-1]],
  [[1, -1], [1]],
  [[-1, 1], [1]],
  [[1, 1], [-1]]
]

net = Highbrow::Network::FeedForward.new
net.layers.push Highbrow::Layer.new(neurons: 2, bias: true, function: nil)
net.layers.push Highbrow::Layer.new(neurons: 5, bias: true)
net.layers.push Highbrow::Layer.new(neurons: 1)
net.finalize!

bp = Highbrow::Trainer::BackPropagation.new net
bp.training_set.push(*xor_truth)
bp.momentum = 0.2
bp.learning_rate = 0.25
bp.goal = 0.01
bp.plug(Highbrow::Plugin::SmartLearningRate.new)
bp.plug(Highbrow::Plugin::Monitor.new)

bp.batch_mode = true
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
