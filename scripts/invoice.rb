class Invoice
  def initialize(plays)
    @plays = plays
  end

  def statement(invoice)
    result = "Statement for #{invoice['customer']}\n"

    invoice['performances'].each do |performance|
      # 注文の内訳を出力
      result += "\t#{play_for(performance)['name']}: #{usd(amount_for(performance) / 100)} (#{performance['audience']} seats)\n"
    end

    result += "Amount owed is #{usd(total_amount(invoice) / 100)}\n"
    result += "You earned #{total_volume_credits(invoice)} credits\n"
    result
  end

  def amount_for(performance)
    result = 0

    case play_for(performance)['type']
    when 'tragedy'
      result = 40000
      if performance['audience'] > 30
        result += 1000 * (performance['audience'] - 30)
      end
    when 'comedy'
      result = 30000
      if performance['audience'] > 20
        result += 10000 + 500 * (performance['audience'] - 20)
      end
      result += 300 * performance['audience']
    else
      raise "unknown type: #{play_for(performance)['type']}"
    end

    result
  end

  def play_for(performance)
    @plays[performance['playID']]
  end

  def volume_credits_for(performance)
    result = 0
    result += [performance['audience'] - 30, 0].max
    if play_for(performance)['type'] == 'comedy'
      result += performance['audience'] / 5 # @tanaken0515: "5" じゃなくて "10" では？
    end
    result
  end

  def usd(num)
    # @tanaken0515: `Intl.NumberFormat` の代わり
    amount = num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
    "$#{amount}.00"
  end

  def total_volume_credits(invoice)
    volume_credits = 0
    invoice['performances'].each do |performance|
      volume_credits += volume_credits_for(performance)
    end
    volume_credits
  end

  def total_amount(invoice)
    total_amount = 0
    invoice['performances'].each do |performance|
      total_amount += amount_for(performance)
    end
    total_amount
  end
end
