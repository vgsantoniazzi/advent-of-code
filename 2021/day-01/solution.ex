defmodule SonarSweep do
  def right_direction_count(array) do
    Enum.map(Enum.chunk_every(array, 2, 1), fn distance ->
      if Enum.at(distance, 1) && Enum.at(distance, 1) > Enum.at(distance, 0), do: 1, else: 0
    end) |> Enum.sum
  end

  def right_direction_sliding_window_count(array) do
    Enum.map(Enum.chunk_every(Enum.chunk_every(array, 3, 1), 2, 1), fn distance ->
      if Enum.at(distance, 1) && Enum.sum(Enum.at(distance, 1)) > Enum.sum(Enum.at(distance, 0)), do: 1, else: 0
    end) |> Enum.sum
  end
end

{:ok, file} = File.read("input.txt")

measurements = Enum.map(Enum.drop(String.split(file, "\n"), -1), &String.to_integer/1)

IO.inspect SonarSweep.right_direction_count(measurements)
IO.inspect(SonarSweep.right_direction_sliding_window_count(measurements))
