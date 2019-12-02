def run(opcodes)
  ip = 0

  while true
    case opcodes[ip]
    when 1
      a = opcodes[opcodes[ip + 1]]
      b = opcodes[opcodes[ip + 2]]

      opcodes[opcodes[ip + 3]] = a + b
      ip += 4
    when 2
      a = opcodes[opcodes[ip + 1]]
      b = opcodes[opcodes[ip + 2]]

      opcodes[opcodes[ip + 3]] = a * b
      ip += 4
    when 99
      break
    end
  end

  return opcodes[0]
end

input = File.read('input.txt').split(',').map(&:to_i)
range = 0..99

for noun in range
  for verb in range
    opcodes = input.dup

    opcodes[1] = noun
    opcodes[2] = verb

    if run(opcodes) == 19690720
      puts "Noun: %d Verb: %d Output: %d" % [noun, verb, 100 * noun + verb]
      exit
    end
  end
end
