layer = File
  .read("input.txt")
  .scan(/.{#{25 * 6}}/)
  .map(&.[0])
  .min_by(&.count('0'))

puts layer.count('1') * layer.count('2')
