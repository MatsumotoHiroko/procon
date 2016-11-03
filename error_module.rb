#!/usr/bin/ruby
require "pry"
module ErrorModule
  def error_msg(code)
    case code
      when :name_invalid
        "正しい名前を入力してください"
      else
        "エラーです"
    end
  end
end
