# frozen_string_literal:

require "open-uri"
require "net/http"
require "json"

class CoinMarketCap
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def self.fetch(symbols)
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=#{symbols.join(",")}&convert=#{ENV["DEFAULT_CURRENCY"]}&CMC_PRO_API_KEY=#{ENV["COINMARKETCAP_API_KEY"]}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    symbols.reduce({}) do |memo, symbol|
      data = json.dig("data", symbol, "quote", ENV["DEFAULT_CURRENCY"])
      memo[symbol] = self.new(data)
      memo
    end
  end

  def price
    data["price"].to_f
  end

  def percent_change_1h
    data["percent_change_1h"].to_f
  end

  def percent_change_24h
    data["percent_change_24h"].to_f
  end

  def percent_change_7d
    data["percent_change_7d"].to_f
  end
end
