defmodule Bulls.Game do

  def new do
    %{
      number: random_number(),
      guesses: []
    }
  end

  def guess(st, num) do
    [bulls, cows] = find_bc_loop(st.number, String.graphemes(num), 0, 0)
    new_guess = %{
      key: length(st.guesses),
      value: num,
      bulls: bulls,
      cows: cows
    }
    %{ st | guesses: st.guesses ++ [new_guess]}
  end

  def get_state(st) do
    revealed = ""
    if st.guesses != [] do
      if List.last(st.guesses).bulls == 4 do
        revealed = st.number
      end
    end
    %{
      secret_revealed: revealed,
      guesses: st.guesses
    }
  end

  def find_bc_loop(number, guess, bulls, cows) do
    if guess == [] do
      [bulls, cows]
    else
      cond do
        hd guess == String.at(number, 4-length(guess)) -> bulls = bulls + 1
        String.contains?(number, hd guess) -> cows = cows + 1
      end
      find_bc_loop(number, (tl guess), bulls, cows)
    end
  end

  def random_number() do
    num_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    gen_arr = []
    first_digit = Enum.random(num_arr)
    gen_arr = [first_digit | gen_arr ]
    num_arr = num_arr -- [first_digit]
    num_arr = [ 0 | num_arr ]
    random_number_loop(num_arr, gen_arr)
  end

  def random_number_loop(num_arr, gen_arr) do
    if length(gen_arr) == 4 do
      Enum.join(gen_arr, "")
    else
      digit = Enum.random(num_arr);
      gen_arr = gen_arr ++ [digit];
      num_arr = num_arr -- [digit];
      random_number_loop(num_arr, gen_arr)
    end
  end

end
