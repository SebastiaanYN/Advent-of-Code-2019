width = 25
height = 6

layers = File
  .read("input.txt")
  .scan(/.{#{width * height}}/)
  .map(&.[0])

image = ""
(width * height).times do |i|
  color = layers
    .map(&.[i])
    .find('0', &.!= '2')

  image += color == '1' ? '#' : ' '
end

puts image
  .scan(/.{#{width}}/)
  .map(&.[0])
  .join('\n')
