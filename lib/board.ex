defmodule Board do
  def new_board(rows, cols) do
    grid = for row <- 1..rows, col <- 1..cols, into: %{}, do: {{row, col}, Enum.random([" ", "#"])}

    %{grid: grid, rows: rows, cols: cols}
  end

  def apply_pattern(%{grid: grid, cols: cols, rows: rows}) do

    updated_cells = for row <- 1..rows do
      for col <- 1..cols do
        cell = {row, col}
        neighbours = get_neighbours(grid, cell, rows, cols)

        birth = check_birth(neighbours, grid[cell])
        death = check_death(neighbours, grid[cell])
        survival = check_survival(neighbours, grid[cell])

        new_cell = case [birth, death, survival] do
          [true, _, _] -> "#"
          [_, _, true] -> "#"
          [_, true, _] -> " "
          _ -> grid[cell]
        end

        {cell, new_cell}
      end
    end
    |> List.flatten
    |> Enum.into(%{})

    new_grid =
      grid
      |> Enum.map(fn {cell, val} ->
        updated_value = updated_cells[cell];

        case updated_value do
          nil -> {cell, val}
          _ -> {cell, updated_value}
        end
      end)
      |> Enum.into(%{})

    %{grid: new_grid, cols: cols, rows: rows}
  end

  def get_neighbours(grid, {row, col}, max_row, max_col) do
    rows = get_rows(row, max_row)
    cols = get_cols(col, max_col)

    for row <- rows, col <- cols do
      {{row, col}}
    end
    |> Enum.reduce(%{alive: 0, dead: 0}, fn {{r, c}}, acc ->
      if {r, c} == {row, col} do
        acc
      else
        cell_value = grid[{r, c}]
        if cell_value == "#" do
          %{acc | alive: acc.alive + 1}
        else
          %{acc | dead: acc.dead + 1}
        end
      end
    end)
  end

  @spec check_birth(any, any) :: boolean
  def check_birth(%{ dead: _, alive: 3}, " "), do: true
  def check_birth(_, _), do: false

  def check_survival(%{ dead: _, alive: 3}, "#"), do: true
  def check_survival(_, _), do: false

  def check_death(%{dead: _, alive: 2}, "#"), do: false
  def check_death(_, _), do: true

  defp get_rows(row, max_row) do
    if (row == 1) do
      [max_row, 1, 2]
    else
      [row - 1, row, row + 1]
    end
  end

  defp get_cols(col, max_col) do
    if (col == 1) do
      [max_col, 1, 2]
    else
      [col - 1, col, col + 1]
    end
  end

  def print(%{grid: grid, rows: rows, cols: cols}) do
    printed = for row <- 1..rows do
      for col <- 1..cols do
        " " <> grid[{row, col}]
      end
      |> Enum.join(" |")
    end
    |> Enum.join("\n" <> String.duplicate("---+", cols)  <> "\n")

    IO.write("\r" <> printed <> "\n\n")
    %{grid: grid, rows: rows, cols: cols}
  end
end
