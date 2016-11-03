#!/usr/bin/ruby
class Judge
  NAME_LIST = {}
  MAX_SIZE = 2
  def initialize
    # fine read
    open("file.txt").each do |line|
      father, son = line.chomp!.split(",")
      NAME_LIST[father] ||= []
      binding.pry
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
        binding.pry
        if key
          puts key.capitalize
        else
          puts "関係が存在しません"
        end
    end
  end

  def get_connection
    %w{me father son}.each do |key|
    binding.pry
      if self.send("#{key}?")
        binding.pry
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
  def son?
    if sons = self.sons(@names[0])
      return sons.include?(@names[1])
    end
    false
  end
  def father(str)
  binding.pry
    NAME_LIST.select{|list| list.values.find{|name| name == str} }.try(:key)
  end

  def sons(str)
  binding.pry
    if NAME_LIST.key?(str)
      NAME_LIST[str]
    end   
  end
end
