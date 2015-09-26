require_relative '../lib/highbrow.rb'

Neural = Highbrow::Neural
knowledge_file = File.dirname(__FILE__) + '/example1.yaml'

xor_truth = [
  [[0, 0], [0]],
  [[1, 0], [1]],
  [[0, 1], [1]],
  [[1, 1], [0]]
]

store = Highbrow::IO::Store.new
if File.exist? knowledge_file
  net = store.load knowledge_file
else
  net = Highbrow::Neural::Network::FeedForward.new
  net.add_layer Highbrow::Neural::Layer.new(
    neurons: 2,
    bias: true,
    activation: nil
  )
  net.add_layer Highbrow::Neural::Layer.new(
    neurons: 3,
    bias: true,
    activation: Highbrow::Neural::Activation::Sigmoid.new
  )
  net.add_layer Highbrow::Neural::Layer.new(
    neurons: 1,
    activation: Highbrow::Neural::Activation::Sigmoid.new
  )
  net.finalize!

  bp = Highbrow::Neural::Trainer::BackPropagation.new net
  bp.plug(Highbrow::Neural::Trainer::Plugin::SmartLearningRate.new)
  bp.plug(Highbrow::Neural::Trainer::Plugin::Monitor.new)
  bp.training_set.push(*xor_truth)
  bp.momentum = 0.7
  bp.learning_rate = 0.25
  bp.goal = 0.01
  bp.train

  store.save net, knowledge_file
end

net.input = [1.0, 1.0]
net.activate
puts net.output

net.input = [0.0, 1.0]
net.activate
puts net.output
