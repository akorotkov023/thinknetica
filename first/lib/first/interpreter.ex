defmodule First.Interpreter do

  def interp(tokens) do
    interp(tokens, [])
  end

  defp interp(_tokens=[token | rest], stack) do
    case token.type do
      :op -> handleOp(token, rest, stack)
      :int -> handleNumber(token, rest, stack)
      :fp -> handleNumber(token, rest, stack)
    end
  end

  defp interp(_tokens=[], stack) do
    [result | _stack] = stack
    result.value
  end

  defp handleOp(op_token, tokens, stack) do
    [op_2_token | stack] = stack
    [op_1_token | stack] = stack
    op_1 = op_1_token.value
    op_2 = op_2_token.value
    result =
      case op_token.value do
        "+" -> First.Token.create(type: :fp, value: op_1 + op_2)
        "-" -> First.Token.create(type: :fp, value: op_1 - op_2)
        "*" -> First.Token.create(type: :fp, value: op_1 * op_2)
        "/" -> First.Token.create(type: :fp, value: divide(op_1, op_2))
      end
    stack = [result | stack]
    interp(tokens, stack)
  end

  defp handleNumber(num_token, tokens, stack) do
    stack = [num_token | stack]
    interp(tokens, stack)
  end

  defp divide(op_1, op_2) do
    result =
      case op_1/op_2 - trunc(op_1/op_2) do
        0.0 -> trunc(op_1/op_2)
        _ -> op_1/op_2
      end
    result
  end

end
