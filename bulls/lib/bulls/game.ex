defmodule Bulls.Game do

  def new do
    %{
      number: random_number(),
      guesses: []
    }
  end

  def guess(st, num) do
    [b, c, ind] = find_bc(st.number, num)
    new_guess = %{
      key: length(st.guesses),
      value: num,
      bulls: b,
      cows: c
    }
    %{ st | guesses: st.guesses ++ [new_guess]}
  end

  def get_state(st) do
    if st.guesses != [] do
      if List.last(st.guesses).bulls == 4 || length(st.guesses) > 7 do
        %{
          win: true,
          guesses: st.guesses
        }
      else
        %{
          win: false,
          guesses: st.guesses
        }
      end
    end

  end

  def find_bc(number, guess) do
    guess_array = String.graphemes(guess)
    function = fn(x, [b, c, ind]) ->
      cond do
        x == String.at(number, ind) -> [b+1, c, ind+1]
        String.contains?(number, x) -> [b, c+1, ind+1]
        true -> [b, c, ind+1]
      end
    end
    Enum.reduce(guess_array, [0,0,0], function)
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
