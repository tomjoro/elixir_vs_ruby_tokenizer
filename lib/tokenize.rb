require 'benchmark'
module Tokenize


  def self.tokenize(str)

    result = []

    while(1)
      match = str.match(/%{|\}|\[|\]|=>|,/)
      if match
        val = case match[0]
                when "%{"
                  { tk_start_hash: "%{"}
                when "}"
                  { tk_end_hash:  "}" }
                when "=>"
                  { tk_kv: "=>" }
                when "#"
                   { tk_object_value:  "#"  }
                when "["
                  { tk_start_array:  "["  }
                when "]"
                  { tk_end_array: "]"  }
                when ","
                  { tk_comma: ","  }
                else
                  { unknown: "xxx"}
              end
        result << val
        str = str.split(match[0], 2)
        str = str[1]
      else
        break
      end
    end

    puts "result #{result}"
  end
end


str = "%{ [ ]  =>, , , , ,, ,, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
str2 = "%{ [ ]  =>, , , , ,, ,, , , , => [ ], , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
str3 = "%{ [ ]  =>, , , , , => => [ , , ]  , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "


[str, str2, str3].each do | str |
  beginning_time = Time.now
  Tokenize.tokenize(str)
  end_time = Time.now
  puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
end

#puts Benchmark.measure { Tokenize.tokenize(str) }