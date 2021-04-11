# Binance widget for xbar

## What is it?

This Binance widget indicates your current Binance (and/or Coinbase) wallet in your fiat currency.

## Requirements

- Ruby (tested on 2.6.5 and 3.0.0)

## Usage

1. Clone this repo
2. Creates a `.env` file in this repo
3. Add your configuration in this `.env` file:

```
BINANCE_API_KEY=
BINANCE_SECRET_KEY=
COINBASE_API_KEY=
COINBASE_SECRET_KEY=
COINMARKETCAP_API_KEY=
DEFAULT_CURRENCY=EUR
```

4. Run the `./generate_plugin.sh` script
5. Refresh your plugins in xbar menu
