defmodule Bulls.Game do

  def new do
    %{
      number: random_number(),
      guesses: [],
      text: ""
    }
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
