defmodule First.Calc do

  def main() do
    result = IO.gets("> ")
             |> eval()
    IO.puts("#{inspect(result)}")

    main()
  end

  def eval(line) do
    First.Lexer.tokenize(line)
    |> First.Parser.parse()
    |> First.Interpreter.interp()
  end

end
