defmodule Day3 do
  @behaviour Solution

  @test_input """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  7
  """
  def solve_part_1(input) do
    input
    |> trees()
    |> calculate_tree_count(3, 1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  336
  """
  def solve_part_2(input) do
    rows = trees(input)

    [
      calculate_tree_count(rows, 1, 1),
      calculate_tree_count(rows, 3, 1),
      calculate_tree_count(rows, 5, 1),
      calculate_tree_count(rows, 7, 1),
      calculate_tree_count(rows, 1, 2)
    ]
    |> Enum.reduce(&(&1 * &2))
  end

  defp calculate_tree_count(rows, right, down) do
    rows
    |> Enum.filter(fn {_, row} -> rem(row, down) == 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {line, row}, acc ->
      length = String.length(line)
      position = row * right
      index = get_index(length, position)

      if String.at(line, index) == "#" do
        acc + 1
      else
        acc
      end
    end)
  end

  defp get_index(length, position) do
    if position >= length do
      rem(position, length)
    else
      position
    end
  end

  defp trees(input) do
    input
    |> String.split()
    |> List.pop_at(0)
    |> elem(1)
    |> Enum.with_index(1)
  end
end
