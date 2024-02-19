defmodule First.Token do
  @enforce_keys [:type, :value]
  defstruct [:type, :value]

  @tokens %{
    int: "INTEGER",
    op: "OPERATOR",
    leftparen: "(",
    rightparen: ")",
    eof: "END",
    illegal: "ILLEGAL",
    fp: "FLOAT",
    space: "SPACE"
  }

  def create(type: type, value: value) do
    if Map.has_key?(@tokens, type) do
      %__MODULE__{type: type, value: value}
    else
      raise TokenError, message: "Invalid Token Type - #{inspect(type)}"
    end
  end
end

defmodule TokenError do
  defexception message: "There was a problem with this a token."
end
