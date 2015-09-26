require_relative '../lib/highbrow.rb'

xor_truth = [
  [[0, 0], [0]],
  [[1, 0], [1]],
  [[0, 1], [1]],
  [[1, 1], [0]]
]

store_file = '/tmp/example1.yaml'
store = Highbrow::IO::Store.new
if File.exist? store_file
  net = store.load store_file
else
  net = Highbrow::Neural::Network::FeedForward.new
  net.layers.push Highbrow::Neural::Layer.new(neurons: 2, bias: true, function: nil)
  net.layers.push Highbrow::Neural::Layer.new(neurons: 3, bias: true, function: Highbrow::Neural::Activation::Sigmoid.new)
  net.layers.push Highbrow::Neural::Layer.new(neurons: 1, function: Highbrow::Neural::Activation::Sigmoid.new)
  net.finalize!

  bp = Highbrow::Neural::Trainer::BackPropagation.new net
  bp.plug(Highbrow::Neural::Trainer::Plugin::SmartLearningRate.new)
  bp.plug(Highbrow::Neural::Trainer::Plugin::Monitor.new)
  bp.training_set.push(*xor_truth)
  bp.momentum = 0.7
  bp.learning_rate = 0.25
  bp.goal = 0.00001
  bp.train

  store.save net, store_file
end

net.input = [1.0, 1.0]
net.activate
puts net.output

net.input = [0.0, 1.0]
net.activate
puts net.output
