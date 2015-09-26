c = File.read 'words.txt'
words = c.strip.split.each.map { |x| x.split('=')[0] }

words.each_with_index do |item, index|
  File.write 'w' + (index+1).to_s + '.txt', item
end
