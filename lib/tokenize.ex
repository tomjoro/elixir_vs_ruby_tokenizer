defmodule Tokenize do

  def main(args) do
    str1 = "%{ [ ]  =>, , , , ,, ,, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
    str2 = "%{ [ ]  =>, , , , ,, ,, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
    str3 = "%{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "

    list = [ str1, str2, str3 ]

    result = Enum.map(list, fn(str) ->
        :timer.tc(fn -> Tokenize.tokenize(str) end)
      end)

    IO.inspect(result)
  end

  def tokenize(str) do
    result = []
    c = Regex.compile("%{|}|\[|\]|=>|\,")

    final = _tokenize(str, result)
    final = Enum.reverse(final)
  end

   # match the empty string (must be before)
  def _tokenize("--end--", result) do
     result
  end

   def _tokenize("", result) do
     result
   end

  def _tokenize(str, result) do
    lex = Regex.run(~r/%{|}|\[|\]|=>|\,/, str)

    #IO.inspect(lex)
    match = case List.first(lex) do
      "%{" -> { :tk_start_hash, "%{"}
      "}" -> { :tk_end_hash,  "}" }
      "=>" -> { :tk_kv, "=>" }
      "\"" -> { :tk_quote_value, "\"" }
      "," -> { :tk_comma, "," }
      "#" -> { :tk_object_value,  "#"  }
      "[" -> { :tk_start_array,  "["  }
      "]" -> { :tk_end_array, "]"  }
      _ ->  { :tk_done, "_" }
    end

    { token, matcher } = match

    case token do
      :tk_done ->
       _tokenize("--end--", [ result | match ])
      _ ->
        base = String.length(matcher)
        {_, str_out} = String.split_at(str, base)
        #str_out = String.slice(str, base..-1)
        _tokenize(String.lstrip(str_out), [ match | result ])
     end
  end


"""
   Tokenize of ", , " will result in termination, because it will split on
   space, and spaces will result in an ampty string

"""

end
