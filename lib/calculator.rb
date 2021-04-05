# frozen_string_literal: true

require "./lib/binance_helper"
require "./lib/coin_market_cap"

class Calculator
  attr_accessor :binance,
    :coin_market_cap,
    :symbols,
    :wallet,
    :percent_24h,
    :has_wallet_increased,
    :changes

  def initialize
    @binance = BinanceHelper.new
    @wallet = 0.0
    @percent_24h = 0.0
    @changes = []
    @symbols = []
  end

  def run
    binance.fetch
    @symbols = binance.positive_symbols
    @coin_market_cap = CoinMarketCap.fetch(symbols)

    symbols.each do |symbol|
      coins = binance.coins_for(symbol)
      market = coin_market_cap[symbol]
      price = coins * market.price
      @wallet += price
      change = {
        "1h" => market.percent_change_1h,
        "24h" => market.percent_change_24h,
        "7j" => market.percent_change_7d,
      }.map do |time, percent|
        [time, percent]
      end
      @changes << [symbol, coins, price, change, market.percent_change_24h]
    end

    changes.each do |symbol, coins, price, change, percent|
      @percent_24h += price / wallet * percent
    end

    @has_wallet_increased = percent_24h >= 0.0
  end

  def wallet_increased?
    has_wallet_increased
  end
end
