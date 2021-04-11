# frozen_string_literal: true

require "binance-ruby"
require File.dirname(__FILE__) + "/service_helper"

Binance::Api::Configuration.api_key = ENV["BINANCE_API_KEY"]
Binance::Api::Configuration.secret_key = ENV["BINANCE_SECRET_KEY"]

class BinanceHelper
  include ServiceHelper

  attr_accessor :balances, :symbols, :positive_symbols

  def available?
    ENV["BINANCE_API_KEY"].present? && ENV["BINANCE_SECRET_KEY"].present?
  end

  def fetch
    reset
    binance_info = Binance::Api.info!
    @balances = binance_info[:balances]
  end

  def reset
    @symbols = nil
    @positive_symbols = nil
    @balances = nil
  end

  def symbols
    @symbols ||= balances.map { |a| a[:asset] }
  end

  def positive_symbols
    @positive_symbols ||= symbols.select { |symbol| coins_for(symbol).positive? }
  end

  def balance_for(symbol)
    balances.find { |a| a[:asset] == symbol }
  end

  def coins_for(symbol)
    balance_for(symbol)[:free].to_f
  end
end
