require_relative '../../lib/highbrow'

color = [100.0, 200.0, 255.0]

normalizer = Highbrow::Util::Normalizer.new 0, 255, 0, 1
normalized = normalizer.normalize_array color
denormalized = normalizer.denormalize_array normalized

puts "Input        = #{color.join(', ')}"
puts "Normalized   = #{normalized.join(', ')}"
puts "Denormalized = #{denormalized.join(', ')}"
