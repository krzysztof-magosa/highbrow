# coding: utf-8
require_relative '../lib/highbrow.rb'

langs = %w(en fr it pl)
$alphabet = ('a'..'z').to_a + [' ', '.', ',', "'", 'ą', 'ć', 'ę', 'ó', 'ł', 'ś', 'ż', 'ź', 'à', 'è', 'é', 'ì', 'í', 'î', 'ò', 'ù', 'ú']
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

  if lang == 'pl'
    (1..20).each do |y|
      freq = calc_freq File.read("#{dir}/langs/#{lang}/w#{y}.txt")
      output = Array.new(langs.count, 0.0)
      output[index] = 1.0

      training_set.push [freq, output]
    end
  end
end

store = Highbrow::IO::Store.new

if File.exists? '/tmp/lang.net'
  net = store.load '/tmp/lang.net'
else
  net = Highbrow::Network::FeedForward.new
  net.layers.push Highbrow::Layer.new(neurons: $alphabet.count, bias: true, function: nil)
  net.layers.push Highbrow::Layer.new(neurons: 35, bias: true, function: Highbrow::Function::Sigmoid.new)
  net.layers.push Highbrow::Layer.new(neurons: langs.count, function: Highbrow::Function::Sigmoid.new)
  net.finalize!
end
  bp = Highbrow::Trainer::BackPropagation.new net
  bp.training_set.push(*training_set)
  bp.momentum = 0.7
  bp.learning_rate = 0.3
  bp.goal = 0.01
  bp.plug(Highbrow::Plugin::SmartLearningRate.new)
  bp.plug(Highbrow::Plugin::Monitor.new)
  bp.train

  store.save net, '/tmp/lang.net'

pl_freq = calc_freq "Sepp Blatter, the president of Fifa, is under criminal investigation for corruption"
pl_freq = calc_freq "Kocham"
net.input = pl_freq
net.activate
puts langs.join(', ')
puts net.output.inspect
