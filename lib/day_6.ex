defmodule Day6 do
  @behaviour Solution

  @test_input """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  11
  """
  def solve_part_1(input) do
    input
    |> groups()
    |> Enum.map(fn group ->
      group
      |> Enum.flat_map(&String.graphemes/1)
      |> MapSet.new()
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  6
  """
  def solve_part_2(input) do
    input
    |> groups()
    |> Enum.map(fn group ->
      group
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.reduce(%{}, fn answer, acc -> Map.update(acc, answer, 1, &(&1 + 1)) end)
      |> Map.values()
      |> Enum.filter(&(&1 == length(group)))
      |> length()
    end)
    |> Enum.sum()
  end

  defp groups(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end
end
