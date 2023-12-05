defmodule Solver do
  def solve(day, part) do
    input = read_input(day)
    module = day_module(day)

    case part do
      1 -> module.solve_part_1(input)
      2 -> module.solve_part_2(input)
    end
  end

  def read_input(day) do
    File.read!("inputs/day_#{day}.txt")
  end

  def day_module(day) do
    String.to_atom("Elixir.Day#{day}")
  end
end
