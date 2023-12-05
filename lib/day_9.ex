defmodule Day9 do
  @behaviour Solution

  @test_input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)}, 5)
  127
  """
  def solve_part_1(input, preamble \\ 25) do
    input
    |> xmas()
    |> invalid_cipher_member(preamble)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)}, 5)
  62
  """
  def solve_part_2(input, preamble \\ 25) do
    cipher = xmas(input)
    invalid_number = invalid_cipher_member(cipher, preamble)

    encryption_weakness(cipher, invalid_number)
  end

  defp invalid_cipher_member(cipher, preamble, index \\ 0) do
    if index < preamble do
      invalid_cipher_member(cipher, preamble, index + 1)
    else
      value = Enum.at(cipher, index)

      sums =
        cipher
        |> Enum.slice(index - preamble, preamble)
        |> calculate_sums()

      if MapSet.member?(sums, value) do
        invalid_cipher_member(cipher, preamble, index + 1)
      else
        value
      end
    end
  end

  defp calculate_sums(chunk) do
    chunk
    |> Enum.flat_map(fn num_one ->
      Enum.map(chunk, fn num_two ->
        if num_one != num_two do
          num_one + num_two
        else
          nil
        end
      end)
    end)
    |> Enum.reject(&is_nil/1)
    |> MapSet.new()
  end

  defp encryption_weakness(cipher, invalid_number) do
    cipher
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {_, index}, _ ->
      {_, chunk} = Enum.split(cipher, index)

      weakness =
        chunk
        |> Enum.with_index()
        |> Enum.reduce_while(0, fn {value, index}, sum ->
          new_sum = sum + value

          cond do
            new_sum == invalid_number and index != 0 ->
              {min, max} =
                chunk
                |> Enum.slice(0..index)
                |> Enum.min_max()

              {:halt, min + max}

            new_sum >= invalid_number ->
              {:halt, nil}

            true ->
              {:cont, new_sum}
          end
        end)

      if is_nil(weakness) do
        {:cont, nil}
      else
        {:halt, weakness}
      end
    end)
  end

  defp xmas(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
