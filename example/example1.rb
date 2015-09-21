require_relative '../lib/highbrow.rb'

xor_truth = [
  [[-1, -1], [-1]],
  [[-1, 1], [1]],
  [[1, -1], [1]],
  [[1, 1], [-1]]
]

net = Highbrow::MLPerceptron.new
net.layers.push Highbrow::InputLayer.new(2)
net.layers.push Highbrow::Layer.new(3)
net.layers.push Highbrow::Layer.new(1)

bp = Highbrow::BackPropagation.new net
bp.training_set.push(*xor_truth)

bp.plug(Highbrow::Plugin::SmartLearningRate.new)

1.times do
  bp.train
end

#puts

net.input = [1.0, 1.0]
net.activate
#puts net.output
