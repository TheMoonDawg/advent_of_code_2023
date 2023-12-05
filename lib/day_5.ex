defmodule Day5 do
  @behaviour Solution

  @test_input_one """
  BFFFBBFRRR
  """

  @test_input_two """
  FFFBBBFRRR
  """

  @test_input_three """
  BBFFBBFRLL
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input_one)})
  567

  iex> solve_part_1(#{inspect(@test_input_two)})
  119

  iex> solve_part_1(#{inspect(@test_input_three)})
  820
  """
  def solve_part_1(input) do
    input
    |> boarding_passes()
    |> get_seat_ids()
    |> Enum.max()
  end

  def solve_part_2(input) do
    input
    |> boarding_passes()
    |> get_seat_ids()
    |> Enum.sort()
    |> Enum.reduce_while(0, fn seat_id, last_id ->
      if last_id != 0 and seat_id - last_id > 1 do
        {:halt, seat_id - 1}
      else
        {:cont, seat_id}
      end
    end)
  end

  defp get_seat_ids(passes) do
    Enum.map(passes, fn pass ->
      {row, column} = String.split_at(pass, 7)

      get_location(row, 0..127) * 8 + get_location(column, 0..7)
    end)
  end

  defp get_location(pass, range, position \\ 0) do
    if Enum.count(range) == 1 do
      List.first(range)
    else
      split_by =
        range
        |> Enum.count()
        |> div(2)

      {lower, upper} = Enum.split(range, split_by)

      if upper_half?(String.at(pass, position)) do
        get_location(pass, upper, position + 1)
      else
        get_location(pass, lower, position + 1)
      end
    end
  end

  defp upper_half?(str), do: str == "B" or str == "R"

  defp boarding_passes(input) do
    String.split(input, "\n", trim: true)
  end
end
