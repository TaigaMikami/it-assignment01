class Drink
  attr_accessor :name, :price

  def coke
    self.new 120, :coke
  end
end

class VendingMachine
  AVAILABLE_MONEY = [10,50,100,500,1000]



  def initialize
    @total = 0
    5.times
  end

  #お金投入
  def insert(money)
    if AVAILABLE_MONEY.include?(money)
      @total += money
    else
      puts "払い戻し:#{money}円"
      return money
    end
    puts @total
  end

end


#インスタンス作成
machine = VendingMachine.new

money = gets.to_i
machine.insert(money)
