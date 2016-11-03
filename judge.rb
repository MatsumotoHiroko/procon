#!/usr/bin/ruby
require 'active_support'
require 'active_support/core_ext'
class Judge
  NAME_LIST = {}
  MAX_SIZE = 2
  def initialize
    # fine read
    open("file.txt").each do |line|
      father, son = line.chomp!.split(",")
      NAME_LIST[father] ||= []
      NAME_LIST[father] << son
    end
    NAME_LIST.freeze
    @names = []
  end

  def valid?(str)
    NAME_LIST.key?(str) or NAME_LIST.value?(str)
  end

  def input(str)
    @names << str
  end

  def max_size?
    @names.size >= MAX_SIZE
  end

  def message(code)
    case code
      when :input_wait
        "#{@names.size+1}人目の名前を入力してください"
      when :connection
        key = self.get_connection
        if key
          puts key.capitalize
        else
          puts "関係が存在しません"
        end
    end
  end

  def get_connection
    %w{me father son uncle}.each do |key|
      if self.send("#{key}?")
        return key
      end
    end
    return nil
  end

  def me?
    @names[0] == @names[1]
  end
  %w{father}.each do |type|
    helper = <<-END
      def #{type}?
        #{type}(@names[0]) == @names[1]
      end
    END
    class_eval helper, __FILE__, __LINE__
  end

  %w{son uncle}.each do |type|
    helper = <<-END
      def #{type}?
        if values = self.send("#{type.pluralize}", @names[0])
          values.include?(@names[1])
        else
          false
        end
      end
    END
    class_eval helper, __FILE__, __LINE__
  end
  def father(str)
    NAME_LIST.find{|key, list| key if list.include?(str) }.try(:first)
  end

  def sons(str)
    NAME_LIST[str] if NAME_LIST.key?(str)
  end

  def uncles(str)
    if father = self.father(str)
      binding.pry
      if grandfather = self.father(father)
        binding.pry
        self.sons(grandfather).reject{|son| son == father }
      end
    end
  end
end
