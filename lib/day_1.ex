defmodule Day1 do
  @behaviour Solution

  @test_input """
  1721
  979
  366
  299
  675
  1456
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  514579
  """
  def solve_part_1(input) do
    expense_report = expenses(input)

    for num_one <- expense_report,
        num_two <- expense_report do
      if num_one + num_two == 2020 do
        num_one * num_two
      end
    end
    |> Enum.find(&is_integer/1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  241861950
  """
  def solve_part_2(input) do
    expense_report = expenses(input)

    for num_one <- expense_report,
        num_two <- expense_report,
        num_three <- expense_report do
      if num_one + num_two + num_three == 2020 do
        num_one * num_two * num_three
      end
    end
    |> Enum.find(&is_integer/1)
  end

  defp expenses(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
