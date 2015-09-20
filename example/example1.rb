require_relative '../lib/highbrow.rb'

net = Highbrow::MLPerceptron.new
input_layer = Highbrow::InputLayer.new(26)
net.layers.push input_layer
net.layers.push Highbrow::Layer.new(100)
net.layers.push Highbrow::Layer.new(5)
net.activate



#net.output.each_with_index do |v, i|
#  puts "#{i} -> #{v}"
#end
