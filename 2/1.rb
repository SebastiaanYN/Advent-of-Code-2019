opcodes = File.read('input.txt').split(',').map(&:to_i)

opcodes[1] = 12
opcodes[2] = 2

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

puts opcodes[0]
