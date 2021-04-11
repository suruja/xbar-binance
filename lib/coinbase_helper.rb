# frozen_string_literal: true

require "coinbase/wallet"
require File.dirname(__FILE__) + "/service_helper"

class CoinbaseHelper
  include ServiceHelper

  attr_accessor :client, :balances

  def initialize
    @client = Coinbase::Wallet::Client.new(
      api_key: ENV["COINBASE_API_KEY"],
      api_secret: ENV["COINBASE_SECRET_KEY"],
    )
  end

  def fetch
    @balances = client.accounts
  end

  def reset
    @symbols = nil
    @positive_symbols = nil
    @balances = nil
  end

  def symbols
    @symbols ||= balances.map { |a| a.currency }
  end

  def positive_symbols
    @positive_symbols ||= symbols.select { |symbol| coins_for(symbol).positive? }
  end

  def balance_for(symbol)
    balances.find { |a| a.currency == symbol }
  end

  def coins_for(symbol)
    balance_for(symbol).dig("balance", "amount").to_f
  end
end
