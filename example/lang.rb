# coding: utf-8
require_relative '../lib/highbrow.rb'

langs = %w(en fr it pl)
$alphabet = ('a'..'z').to_a + [' ', '.', ',', "'", 'ą', 'ć', 'ę', 'ó', 'ł', 'ś', 'ż', 'ź']
training_set = []
dir = File.dirname __FILE__

def calc_freq(input)
  content = input.downcase
  counter = Array.new($alphabet.count, 0)

  content.split('').each do |char|
    counter[$alphabet.index char] += 1 if $alphabet.include? char
  end

  total = counter.reduce(:+).to_f

  freq = counter.map do |letter|
    (letter / total)
  end
end

langs.each_with_index do |lang, index|
  (1..3).each do |x|
    freq = calc_freq File.read("#{dir}/langs/#{lang}/#{x}.txt")

    output = Array.new(langs.count, 0.0)
    output[index] = 1.0

    training_set.push [freq, output]
  end
end

if File.exists? '/tmp/lang.net'
  net = Highbrow::Network::FeedForward.load '/tmp/lang.net'
else
  net = Highbrow::Network::FeedForward.new
  net.layers.push Highbrow::Layer.new(neurons: $alphabet.count, bias: true, function: nil)
  net.layers.push Highbrow::Layer.new(neurons: 75, bias: true, function: Highbrow::Function::Sigmoid.new)
  net.layers.push Highbrow::Layer.new(neurons: langs.count, function: Highbrow::Function::Sigmoid.new)
  net.finalize!
end

bp = Highbrow::Trainer::BackPropagation.new net
bp.training_set.push(*training_set)
bp.momentum = 0.7
bp.learning_rate = 0.3
bp.goal = 0.05
bp.plug(Highbrow::Plugin::SmartLearningRate.new)
bp.plug(Highbrow::Plugin::Monitor.new)

# bp.batch_mode = true
bp.train

net.save '/tmp/lang.net'

#pl_freq = calc_freq File.read("#{dir}/tests/pl.txt")
pl_freq = calc_freq "I'm in love with you"
net.input = pl_freq
net.activate
puts net.output.inspect

