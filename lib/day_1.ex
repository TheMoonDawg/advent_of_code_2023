defmodule Day1 do
  @behaviour Solution

  @test_input_1 """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """

  @test_input_2 """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """

  @single_digit_mapping %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  @doc """
  iex> solve_part_1(#{inspect(@test_input_1)})
  142
  """
  def solve_part_1(input) do
    input
    |> sanitize_input()
    |> calculate_calibration()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input_2)})
  281
  """
  def solve_part_2(input) do
    input
    |> sanitize_input()
    |> calculate_calibration()
  end

  def sanitize_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn value ->
      value
      |> replace_permutations()
      |> replace_single_digits()
      |> String.replace(~r/[^\d]/, "")
    end)
  end

  def calculate_calibration(values) do
    values
    |> Enum.map(fn value ->
      first_digit = String.at(value, 0)
      last_digit = String.at(value, -1)

      String.to_integer(first_digit <> last_digit)
    end)
    |> Enum.sum()
  end

  defp replace_permutations(value) do
    Enum.reduce(get_permutations(), fn {k, v}, acc ->
      String.replace(acc, k, v)
    end)
  end

  defp replace_single_digits(value) do
    Enum.reduce(@single_digit_mapping, value, fn {k, v}, acc ->
      String.replace(acc, k, v)
    end)
  end

  defp get_permutations do
    Enum.reduce(@single_digit_mapping, %{}, fn a, acc ->
      permutations =
        @single_digit_mapping
        |> Map.delete(elem(a, 0))
        |> Enum.map(fn b -> get_permutation_key_value(a, b) end)
        |> Enum.reject(&is_nil/1)
        |> Map.new()

      Map.merge(acc, permutations)
    end)
  end

  defp get_permutation_key_value({ak, av}, {bk, bv}) do
    cond do
      String.last(bk) === String.first(ak) ->
        key = bk <> String.slice(ak, 1..-1)
        {key, bv <> av}

      String.last(ak) === String.first(bk) ->
        key = ak <> String.slice(bk, 1..-1)
        {key, av <> bv}

      true ->
        nil
    end
  end
end
