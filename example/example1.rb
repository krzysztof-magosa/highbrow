require_relative '../lib/highbrow.rb'

xor_truth = [
  [[-1, -1], [-1]],
  [[1, -1], [1]],
  [[-1, 1], [1]],
  [[1, 1], [-1]]
]

net = Highbrow::MLPerceptron.new
net.layers.push Highbrow::InputLayer.new(2)
net.layers.push Highbrow::Layer.new(2, Highbrow::Function::Tanh.new, true)
net.layers.push Highbrow::Layer.new(1, Highbrow::Function::Tanh.new, false)

bp = Highbrow::BackPropagation.new net
bp.training_set.push(*xor_truth)
bp.momentum = 0.5
#bp.learning_rate = 0.9
bp.plug(Highbrow::Plugin::SmartLearningRate.new)
# bp.plug(Highbrow::Plugin::SmartMomentum.new)

bp.train

puts '---'

net.input = [1.0, 1.0]
net.activate
puts net.output

net.input = [0.0, 1.0]
net.activate
puts net.output
