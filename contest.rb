#!/usr/bin/ruby
require "./error_module"
require "./judge"
include ErrorModule

loop do
  judge = Judge.new
  input_names = []
  loop do
    puts judge.message(:input_wait)
    str = STDIN.gets.chomp!
    if judge.valid?(str)
      judge.input(str)
      break if judge.max_size?
    else
      puts error_msg(:name_invalid)
    end
  end
  
  judge.message(:connection)

  str = STDIN.gets.chomp!
  break if str == "E"
end
