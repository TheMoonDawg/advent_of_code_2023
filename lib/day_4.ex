defmodule Day4 do
  @behaviour Solution

  @test_input """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  """

  @invalid_input """
  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007
  """

  @valid_input """
  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  """

  @byr "byr"
  @iyr "iyr"
  @eyr "eyr"
  @hgt "hgt"
  @hcl "hcl"
  @ecl "ecl"
  @pid "pid"
  @cid "cid"

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  2
  """
  def solve_part_1(input) do
    input
    |> passports()
    |> Enum.reduce(0, fn passport, sum ->
      if passport_fields_present?(passport) do
        sum + 1
      else
        sum
      end
    end)
  end

  @doc """
  iex> solve_part_2(#{inspect(@invalid_input)})
  0

  iex> solve_part_2(#{inspect(@valid_input)})
  4
  """
  def solve_part_2(input) do
    input
    |> passports()
    |> Enum.reduce(0, fn passport, sum ->
      if passport_fields_present?(passport) and passport_valid?(passport) do
        sum + 1
      else
        sum
      end
    end)
  end

  defp passport_fields_present?(passport) do
    cond do
      map_size(passport) == 8 -> true
      map_size(passport) == 7 and not Map.has_key?(passport, @cid) -> true
      true -> false
    end
  end

  defp passport_valid?(passport) do
    validate_field(passport, &validate_byr/1)
    |> validate_field(passport, &validate_iyr/1)
    |> validate_field(passport, &validate_eyr/1)
    |> validate_field(passport, &validate_hgt/1)
    |> validate_field(passport, &validate_hcl/1)
    |> validate_field(passport, &validate_ecl/1)
    |> validate_field(passport, &validate_pid/1)
  end

  defp validate_field(valid? \\ true, passport, validate), do: valid? and validate.(passport)

  defp validate_byr(passport), do: year_valid?(passport, @byr, 1920, 2002)

  defp validate_iyr(passport), do: year_valid?(passport, @iyr, 2010, 2020)

  defp validate_eyr(passport), do: year_valid?(passport, @eyr, 2020, 2030)

  defp year_valid?(passport, key, min, max) do
    year =
      passport
      |> Map.get(key)
      |> String.to_integer()

    year >= min and year <= max
  end

  defp validate_hgt(passport) do
    {height, units} =
      passport
      |> Map.get(@hgt)
      |> Integer.parse()

    case units do
      "cm" -> height >= 150 and height <= 193
      "in" -> height >= 59 and height <= 76
      _ -> false
    end
  end

  defp validate_hcl(passport) do
    {hash, chars} =
      passport
      |> Map.get(@hcl)
      |> String.graphemes()
      |> List.pop_at(0)

    valid_characters = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f"
    ]

    hash == "#" and length(chars) == 6 and Enum.all?(chars, &(&1 in valid_characters))
  end

  defp validate_ecl(passport) do
    eye_color = Map.get(passport, @ecl)

    valid_colors = [
      "amb",
      "blu",
      "brn",
      "gry",
      "grn",
      "hzl",
      "oth"
    ]

    eye_color in valid_colors
  end

  defp validate_pid(passport) do
    digits =
      passport
      |> Map.get(@pid)
      |> String.graphemes()

    length(digits) == 9 and Enum.all?(digits, &is_number?/1)
  end

  defp is_number?(str) do
    str
    |> Integer.parse()
    |> case do
      {_, ""} -> true
      _ -> false
    end
  end

  defp passports(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn passport ->
      passport
      |> String.replace("\n", " ")
      |> String.trim()
    end)
    |> Enum.map(fn passport ->
      passport
      |> String.split()
      |> Map.new(fn passport_data ->
        [field, data] = String.split(passport_data, ":")

        {field, data}
      end)
    end)
  end
end
