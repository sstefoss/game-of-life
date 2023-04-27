defmodule Ca do

  import Board, only: [apply_pattern: 1, print: 1]

  def run() do
    board = Board.new_board(8, 20) |> print
    generate(board, 100)
  end

  defp generate(_, 0), do: :ok

  defp generate(board, times) do
    next_board =
      board
      |> apply_pattern
      |> print

    :timer.sleep(100)
    generate(next_board, times - 1)
  end
end
