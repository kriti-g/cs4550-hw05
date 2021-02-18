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

  def find_bc(number, guess) do
    cows = 0
    bulls = 0
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

  def find_bc_loop(number, guess, bulls, cows) do
    if guess == [] do
      [bulls, cows]
    else
      cond do
        (hd guess) == String.at(number, 4-length(guess)) ->
          bulls = 1 + bulls;
          IO.inspect("cond 1")
          IO.inspect(cows, label: "cows")
          IO.inspect(bulls, label: "bulls")
          IO.inspect(guess, label: "guess")
          IO.inspect(number, label: "number")
        String.contains?(number, (hd guess)) ->
          cows = 1 + cows;
          IO.inspect("cond 2")
          IO.inspect(cows, label: "cows")
          IO.inspect(bulls, label: "bulls")
          IO.inspect(guess, label: "guess")
          IO.inspect(number, label: "number")
        true ->
          cows = cows;
          IO.inspect("cond 3")
          IO.inspect(cows, label: "cows")
          IO.inspect(bulls, label: "bulls")
          IO.inspect(guess, label: "guess")
          IO.inspect(number, label: "number")
      end
      IO.inspect("end")
      IO.inspect(cows, label: "cows")
      IO.inspect(bulls, label: "bulls")
      IO.inspect(guess, label: "guess")
      IO.inspect(number, label: "number")
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
