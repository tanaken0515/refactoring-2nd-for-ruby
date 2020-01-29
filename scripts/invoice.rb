class Invoice
  def statement(invoice, plays)
    total_amount = 0
    volume_credits = 0
    result = "Statement for #{invoice['customer']}\n"

    # @tanaken0515: `Intl.NumberFormat` の代わり
    fmt = lambda do |num|
      amount = num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
      "$#{amount}.00"
    end

    invoice['performances'].each do |performance|
      play = plays[performance['playID']]
      this_amount = amount_for(performance, play)

      # ボリューム特典ポイントを加算
      volume_credits += [performance['audience'] - 30, 0].max
      # 喜劇のときは 10 人につき、さらにポイントを追加
      if play['type'] == 'comedy'
        volume_credits += performance['audience'] / 5 # @tanaken0515: "5" じゃなくて "10" では？
      end
      # 注文の内訳を出力
      result += "\t#{play['name']}: #{fmt.call(this_amount / 100)} (#{performance['audience']} seats)\n"
      total_amount += this_amount
    end

    result += "Amount owed is #{fmt.call(total_amount / 100)}\n"
    result += "You earned #{volume_credits} credits\n"
    result
  end

  def amount_for(performance, play)
    result = 0

    case play['type']
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
      raise "unknown type: #{play['type']}"
    end

    result
  end
end
