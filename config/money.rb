require 'csv'

Money.default_currency = Money::Currency.new("GBP")

CSV.foreach(File.expand_path '../exchange_rates.csv', __FILE__)  do |row|
  Money.add_rate(*row)
end
