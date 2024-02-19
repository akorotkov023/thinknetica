defmodule First.Lexer do

  def tokenize(line) do
    characters = String.replace(line, ["\n"], "")
                 |> String.split("", trim: true)
    tokenize(characters, [])
  end

  defp tokenize(_chars = [], tokens) do
    repeats = Enum.reduce_while(tokens, 0, fn(i, acc) ->
      if i.type == :leftparen || i.type == :rightparen ||  i.type != acc,
         do: {:cont, i.type},
         else: {:halt, false} end)

    if repeats == false do
      raise LexerError, message: "Invalid Arithmetic Expression"
    end
    Enum.reverse([First.Token.create(type: :eof, value: "") | tokens])
  end

  defp tokenize(chars = [ch | rest], tokens) do
    cond do
      is_digit(ch) -> read_number(chars, tokens)
      is_decimal_point(ch) -> raise FloatError, message: "Floats must have digits leading decimal."
      is_whitespace(ch) -> tokenize(rest, tokens)
      true -> read_next_thing(chars, tokens)
    end
  end

  defp is_decimal_point(char) do
    char == "."
  end

  defp is_digit(char) do
    "0" <= char && char <= "9"
  end

  defp is_whitespace(char) do
    char == " "
  end

  defp read_number(chars, tokens) do
    {number, rest} = Enum.split_while(chars, fn(ch) -> is_digit(ch) || is_decimal_point(ch) end)
    decimal_count = Enum.count(number, fn(ch) -> ch == "." end)
    if List.last(number) |> is_decimal_point do
      raise FloatError
    end
    number = Enum.join(number)
    token =
      case decimal_count do
        0 -> First.Token.create(type: :int, value: elem(Integer.parse(number), 0))
        1 -> First.Token.create(type: :fp, value: elem(Float.parse(number), 0))
        _ -> raise FloatError
      end
    tokenize(rest, [token | tokens])
  end

  defp read_next_thing(_chars = [ch | rest], tokens) do
    token =
      case ch do
        "+" -> First.Token.create(type: :op, value: ch)
        "-" -> First.Token.create(type: :op, value: ch)
        "*" -> First.Token.create(type: :op, value: ch)
        "/" -> First.Token.create(type: :op, value: ch)
        "(" -> First.Token.create(type: :leftparen, value: ch)
        ")" -> First.Token.create(type: :rightparen, value: ch)
        _ -> First.Token.create(type: :illegal, value: ch)
      end
    tokenize(rest, [token | tokens])
  end
end

defmodule FloatError do
  defexception message: "Poorly formatted decimal."
end

defmodule LexerError do
  defexception message: "There was a problem tokenizing."
end
