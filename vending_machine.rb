class Drink
  attr_accessor :name, :price

  def initialize(name ,price)
    @name = name
    @price = price
  end

  def self.coke
    self.new(:coke,120)
  end

  def self.redbull
    self.new(:redbull,200)
  end

  def self.water
    self.new(:water,100)
  end

end

class VendingMachine
  AVAILABLE_MONEY = [10,50,100,500,1000]

  attr_accessor :total, :sale_amount # -> [typo] sale_proceeds
  def initialize
    @total = 0
    @drink_menu = {} #飲み物のハッシュ配列 -> [Bad]ハッシュ配列…？一瞬理解を悩ませるので、「ハッシュの配列」と書いたほうが良いです 
    @sale_proceeds = 0
    5.times{ store Drink.coke}  # [Good!]5回登録するというのが理解しやすい！
                                # [Hmm...] できることなら ↑ の5は変数にしてしまって、変数を書き換えれば商品数が管理できるようにする形にしたほうが良い 
  end

  def insert(money)#お金投入
    if AVAILABLE_MONEY.include?(money)
      @total += money
    else
      puts "払い戻し:#{money}円"
      return money
    end
    puts @total # [Bad]何が起きているのかわかりにくいので、「#{@total} 円投入されています」とかのほうが良さそう
  end

  def store(drink)#飲み物格納
    nil.tap do
      if !(@drink_menu.has_key?(drink.name)) #drink.nameの飲み物がない時格納 -> [Question] unless は使わないのですか？ 
        @drink_menu[drink.name] = { price: drink.price, drinks: [] }
      end
      #名前があれば在庫追加
      @drink_menu[drink.name][:drinks].push(drink)
    end

    # [Suggestion]登録本数を引数で受け取れるようにして、回数分登録できるようにすれば拡張しやすいかも
  end

  def stock_info#飲み物格納情報 -> [Hmm...] 細かいですが、 display_stock とかにすれば、なんのためのメソッド化理解しやすいと思います
    puts @drink_menu.map{|name, info|  [name, { price: info[:price], stock: info[:drinks].size }]}
  end

  # [Suggiestion] purchase でだけ呼び出すことが可能になるように private メソッドにしてしまってもいいのでは？
  def available_puchase(drink_name)#購入可能確認 -> [typo] purchase 
    can_buy = @drink_menu.select{|_, info| total >= info[:price] && info[:drinks].any?}.keys
    puts "購入可能#{can_buy}" # [Good!] この書き方だと可読性が高い！
    puts can_buy.include?(drink_name) # [Question] これはデバッグ用に表示していたものですか？
    return can_buy.include?(drink_name)
  end

  def purchase(drink_name) # [Good!] メソッドの処理が見通しやすいです！
    if available_puchase(drink_name)
      drink = @drink_menu[drink_name][:drinks].pop
      @sale_proceeds += drink.price
      @total -= drink.price
      puts "釣り銭：#{@total}"
      puts "売り上げ金額：#{@sale_proceeds}"
    end
  end
end


#インスタンス作成 <- コードを読めばわかるので、コメント内容は「自販機の作成」とかのほうが良さそうです。 
machine = VendingMachine.new

money = gets.to_i # [Bad]いきなり入力待ちにすると、どうすればいいのかわからなくなるので、インフォメーションを表示する 
machine.insert(money) # [Good!]動作対象.処理内容（）という形でメソッド名等を付けてる 
money = gets.to_i 
machine.insert(money)

# [Hmm...] 新しいドリンクの登録は自販機の初期化のタイミングのほうがわかりやすいです。 
machine.store(Drink.water)
machine.store(Drink.redbull)

machine.stock_info
machine.available_puchase(:coke)  # [Hmm...] これは結果を true/false を返すようにした方が理解しやすいかも？ 
                                  # [Bad] available_purchase だと日本語では「購入可能な購入」とかになってしまって、意味が通じにくいので、 check_purchaseとかにするとわかりやすそう 
machine.purchase(:coke) # [Bad] available_purchase は purchase の中で読んでいるので、改めて呼ぶ必要はないと思います