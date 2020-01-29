require 'json'
require_relative 'invoice'

f1 = File.open("data/invoices.json")
f2 = File.open("data/plays.json")

invoices = JSON.parse(f1.read)
plays = JSON.parse(f2.read)

print statement(invoices.first, plays)
