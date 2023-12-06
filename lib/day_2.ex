defmodule Day2 do
  @behaviour Solution

  @test_input """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  @max_red 12
  @max_green 13
  @max_blue 14

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  8
  """
  def solve_part_1(input) do
    input
    |> sanitize_input()
    |> Enum.filter(fn %{rounds: rounds} ->
      Enum.all?(rounds, &valid_round?(&1))
    end)
    |> Enum.map(& &1.game_number)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  2286
  """
  def solve_part_2(input) do
    input
    |> sanitize_input()
    |> Enum.map(fn %{rounds: rounds} ->
      rounds
      |> List.flatten()
      |> Enum.reduce(%{}, fn val, acc ->
        [{k, v}] = Map.to_list(val)

        cond do
          not Map.has_key?(acc, k) -> Map.put(acc, k, v)
          v > acc[k] -> Map.put(acc, k, v)
          true -> acc
        end
      end)
    end)
    |> Enum.map(fn max_colors ->
      max_colors
      |> Map.values()
      |> Enum.reduce(1, fn val, acc -> acc * val end)
    end)
    |> Enum.sum()
  end

  def sanitize_input(input) do
    game_number_regex = ~r/Game (\d+):\s/

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      game_number = Regex.run(game_number_regex, game) |> Enum.at(1)

      rounds =
        Regex.split(game_number_regex, game)
        |> Enum.at(1)
        |> String.split("; ")
        |> Enum.map(fn round ->
          round
          |> String.split(", ")
          |> Enum.map(fn amount ->
            [number, color] = String.split(amount, " ")

            %{color => String.to_integer(number)}
          end)
        end)

      %{game_number: String.to_integer(game_number), rounds: rounds}
    end)
  end

  defp valid_round?(results) do
    Enum.all?(results, &possible_amount?(&1))
  end

  defp possible_amount?(%{"red" => amount}), do: amount <= @max_red
  defp possible_amount?(%{"green" => amount}), do: amount <= @max_green
  defp possible_amount?(%{"blue" => amount}), do: amount <= @max_blue
end
