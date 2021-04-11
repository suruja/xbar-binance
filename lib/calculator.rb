# frozen_string_literal: true

require File.dirname(__FILE__) + "/binance_helper"
require File.dirname(__FILE__) + "/coinbase_helper"
require File.dirname(__FILE__) + "/coin_market_cap"

class Calculator
  attr_accessor :services,
    :coin_market_cap,
    :symbols,
    :wallet,
    :percent_24h,
    :has_wallet_increased,
    :changes

  def initialize
    @services = [
      BinanceHelper.new,
      CoinbaseHelper.new,
    ].select(&:available?)

    @wallet = 0.0
    @percent_24h = 0.0
    @changes = []
    @symbols = []
  end

  def run
    services.each(&:fetch)
    @symbols = services.map(&:positive_symbols).reduce(:+)
    @coin_market_cap = CoinMarketCap.fetch(symbols)
    services.each { |service| build(service) }

    @changes = changes.sort_by { |symbol, coins, price, change, percent| price }.reverse

    changes.each do |symbol, coins, price, change, percent|
      @percent_24h += price / wallet * percent
    end

    @has_wallet_increased = percent_24h >= 0.0
  end

  def build(service)
    service.positive_symbols.each do |symbol|
      coins = service.coins_for(symbol)
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
  end

  def wallet_increased?
    has_wallet_increased
  end
end
