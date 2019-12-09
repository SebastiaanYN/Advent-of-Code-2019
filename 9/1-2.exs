defmodule Intcode do
  defp add(memory, addr, modes) do
    sum = get(memory, addr + 1, mode(modes, 0)) + get(memory, addr + 2, mode(modes, 1))
    set(memory, addr + 3, mode(modes, 2), sum)
  end

  defp mul(memory, addr, modes) do
    sum = get(memory, addr + 1, mode(modes, 0)) * get(memory, addr + 2, mode(modes, 1))
    set(memory, addr + 3, mode(modes, 2), sum)
  end

  defp gets(memory, addr, modes) do
    input = IO.gets("Input: ") |> String.trim() |> String.to_integer()
    set(memory, addr + 1, mode(modes, 0), input)
  end

  defp puts(memory, addr, modes) do
    output = get(memory, addr + 1, mode(modes, 0))
    IO.puts(output)
    memory
  end

  defp jnz(memory, addr, modes) do
    bool = get(memory, addr + 1, mode(modes, 0))

    if bool != 0 do
      new_addr = get(memory, addr + 2, mode(modes, 1))
      {new_addr, memory}
    else
      {addr + 3, memory}
    end
  end

  defp jz(memory, addr, modes) do
    bool = get(memory, addr + 1, mode(modes, 0))

    if bool == 0 do
      new_addr = get(memory, addr + 2, mode(modes, 1))
      {new_addr, memory}
    else
      {addr + 3, memory}
    end
  end

  defp lt(memory, addr, modes) do
    a = get(memory, addr + 1, mode(modes, 0))
    b = get(memory, addr + 2, mode(modes, 1))

    result = if a < b, do: 1, else: 0

    set(memory, addr + 3, mode(modes, 2), result)
  end

  defp eq(memory, addr, modes) do
    a = get(memory, addr + 1, mode(modes, 0))
    b = get(memory, addr + 2, mode(modes, 1))

    result = if a == b, do: 1, else: 0

    set(memory, addr + 3, mode(modes, 2), result)
  end

  defp base(memory, addr, modes) do
    Map.put(memory, :base, memory[:base] + get(memory, addr + 1, mode(modes, 0)))
  end

  defp mode(modes, index), do: Enum.at(modes, index, 0)
  
  defp get(memory, addr, 0), do: memory[memory[addr]] || 0
  defp get(memory, addr, 1), do: memory[addr] || 0
  defp get(memory, addr, 2), do: memory[memory[addr] + memory[:base]] || 0

  defp set(memory, addr, 0, value), do: Map.put(memory, memory[addr], value)
  defp set(memory, addr, 1, value), do: Map.put(memory, addr, value)
  defp set(memory, addr, 2, value), do: Map.put(memory, memory[addr] + memory[:base], value)

  defp opcode_mode(instruction) do
    case Integer.digits(instruction) |> Enum.reverse() do
      [op2, op1 | modes] -> {op1 * 10 + op2, modes}
      [op] -> {op, []}
    end
  end

  defp handle_instruction(memory, addr) do
    case memory[addr] |> opcode_mode() do
      {1, modes} -> {addr + 4, add(memory, addr, modes)}
      {2, modes} -> {addr + 4, mul(memory, addr, modes)}
      {3, modes} -> {addr + 2, gets(memory, addr, modes)}
      {4, modes} -> {addr + 2, puts(memory, addr, modes)}
      {5, modes} -> jnz(memory, addr, modes)
      {6, modes} -> jz(memory, addr, modes)
      {7, modes} -> {addr + 4, lt(memory, addr, modes)}
      {8, modes} -> {addr + 4, eq(memory, addr, modes)}
      {9, modes} -> {addr + 2, base(memory, addr, modes)}
      {99, _} -> {:halt, memory}
    end
  end

  defp list_to_map(list) do
    Stream.zip(Stream.iterate(0, &(&1 + 1)), list) |> Enum.into(%{})
  end

  defp run_program(memory, addr) do
    case handle_instruction(memory, addr) do
      {:halt, memory} -> memory
      {addr, memory} -> run_program(memory, addr)
    end
  end

  def run_program(memory) do
    memory_map = list_to_map(memory) |> Map.put(:base, 0)
    run_program(memory_map, 0)
  end
end

File.read!("input.txt") 
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> Intcode.run_program()
