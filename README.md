# ElixirInspectToMongoJson

Note: currently I only have the tokenizer done, but that's really the interesting part.

In this project I wanted to parse the output from a Inspect of data returned from Elixir MongoDB client.

The purpose was to practice Elixir programming and be able to generate formats for MongoDB console (Json),
Ruby MongoDB drivers (hashes, lists), and maybe other representations.

I developed the tokenizer in both Elixir and then in Ruby and compare the code and performance between these.

I tried to follow a similar code structure in both languages.

lib/tokenize.ex
lib/tokenize.rb

One optimization in Elixir is to construct the list in reverse order by always pre-pending (add to head) instead
the tail of the list. This give much better memory performance as the immutable lists don't need
to be copied on each iteration. Then in the final step I reverse the list.


#Table:

 Find "value" =>

 %{
| PARSED                                    | PUSH to Array |
| key => value                              |  key, value |
| key => [ something, something ]           |  key => [ something, something ] |
| #BSON.ObjectId<53d80bbc4566210472805984>  |    %BSON.ObjectId{value: "53d80bbc4566210472805984"}   |
| #BSON.DateTime<2016-01-10T21:33:43.737000Z> |  %BSON.DateTime{utc: "2016-01-10T21:33:43.737000Z"}   |
}



# Results

The code is actually pretty similar! The major difference is the tail recursion in Elixir compared to the
loop (while) in Ruby.

Once you get your head around the idea that a loop is really a special case of recursion, then life is easier.

Also, since you don't have side effects in Elixir you always have to pass your accumulator
(in this case the list of tokenized things) along with each recursion.
call.

With Elixir there was more thinking up-front, and less testing by running. At the same time working
with Elixir's ability to fun in Iex is really handy. I found I code written in Elixir was more likely
to run :)

# Performance

Elixir/Erlang yields about 2x performance for test cases 600micro seconds, vs 300microsends.

