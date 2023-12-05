defmodule Day8 do
  @behaviour Solution

  @test_input """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  @nop "nop"
  @acc "acc"
  @jmp "jmp"

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  5
  """
  def solve_part_1(input) do
    input
    |> instructions()
    |> boot
    |> elem(1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  8
  """
  def solve_part_2(input) do
    instructions = instructions(input)

    instructions
    |> Enum.filter(fn {_key, value} ->
      elem(value, 0) in [@nop, @jmp]
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce_while(nil, fn index, _ ->
      instructions
      |> Map.update!(index, fn instruction ->
        new_instruction =
          instruction
          |> elem(0)
          |> swap()

        put_elem(instruction, 0, new_instruction)
      end)
      |> boot()
      |> case do
        {:ok, accumulator} -> {:halt, accumulator}
        {:error, _} -> {:cont, nil}
      end
    end)
  end

  defp swap(@nop), do: @jmp
  defp swap(@jmp), do: @nop

  defp boot(instructions) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({instructions, 0, 0}, fn _, {instructions, index, accumulator} ->
      {instruction, argument, executed?} = Map.get(instructions, index, {nil, nil, nil})

      case executed? do
        nil ->
          {:halt, {:ok, accumulator}}

        true ->
          {:halt, {:error, accumulator}}

        false ->
          new_instructions = Map.update!(instructions, index, &put_elem(&1, 2, true))

          new_index =
            case instruction do
              @nop -> index + 1
              @acc -> index + 1
              @jmp -> index + argument
            end

          new_accumulator =
            if instruction == @acc do
              accumulator + argument
            else
              accumulator
            end

          {:cont, {new_instructions, new_index, new_accumulator}}
      end
    end)
  end

  defp instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn value ->
      [instruction, argument_str] = String.split(value, " ")
      {argument, _} = Integer.parse(argument_str)

      {instruction, argument, false}
    end)
    |> Enum.with_index()
    |> Map.new(fn {instruction, index} -> {index, instruction} end)
  end
end
