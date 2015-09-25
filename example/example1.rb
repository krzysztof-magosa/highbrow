require_relative '../lib/highbrow.rb'

xor_truth = [
  [[0, 0], [0]],
  [[1, 0], [1]],
  [[0, 1], [1]],
  [[1, 1], [0]]
]

if File.exists? '/tmp/example1.yml'
  net = Highbrow::Network::FeedForward.load '/tmp/example1.yml'
else
net = Highbrow::Network::FeedForward.new
net.layers.push Highbrow::Layer.new(neurons: 2, bias: true, function: nil)

net.layers.push Highbrow::Layer.new(neurons: 3, bias: true, function: Highbrow::Function::Sigmoid.new)
net.layers.push Highbrow::Layer.new(neurons: 1, function: Highbrow::Function::Sigmoid.new)

# net.layers.push Highbrow::Layer.new(neurons: 5, bias: true)
# net.layers.push Highbrow::Layer.new(neurons: 1)

net.finalize!


end

bp = Highbrow::Trainer::BackPropagation.new net
bp.training_set.push(*xor_truth)
bp.momentum = 0.7
bp.learning_rate = 0.25
bp.goal = 0.01

bp.plug(Highbrow::Plugin::SmartLearningRate.new)
bp.plug(Highbrow::Plugin::Monitor.new)

# bp.batch_mode = true
bp.train


net.save '/tmp/example1.yml'

#Highbrow::IO::Network.save net, '/tmp/knowledge.json'

#File.write '/tmp/net.data', Marshal.dump(net)

# bp.batch_mode = true
# bp.goal = 0.01

# bp.train

puts '---'

net.input = [1.0, 1.0]
net.activate
puts net.output

require 'benchmark'

puts Benchmark.measure {
  net.input = [0.0, 1.0]
  net.activate
  puts net.output
}

