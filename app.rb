# frozen_string_literal: true

require "rubygems"
require "binance-ruby"
require "bitbar"

require File.dirname(__FILE__) + "/lib/formatter"
require File.dirname(__FILE__) + "/lib/calculator"

calc = Calculator.new
calc.run

BitBar::Menu.new do
  item("#{Formatter.arrow(calc.wallet_increased?)} #{calc.wallet.round} € (#{Formatter.percent(calc.percent_24h)})", color: calc.wallet_increased? ? "green" : "red")

  separator

  calc.changes.each do |symbol, coins, price, change|
    rounding = case symbol
      when "BTC", "ETH" then 6
      else 2
      end

    item("#{symbol.strip}\t\t#{coins.round(rounding).to_s.sub(".", ",")}")

    item("#{ENV["DEFAULT_CURRENCY"]}\t\t#{price.round(2).to_s.sub(".", ",")}")

    change.each do |time, percent|
      item("#{time}\t\t #{Formatter.arrow(percent >= 0.0)} #{Formatter.percent(percent)}", color: (percent > 0) ? "green" : "red")
    end

    separator
  end
end
