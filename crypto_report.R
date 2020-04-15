# We have 0.42 Bitcoin. 
# Let's write an R script reporting on the current value of this asset in USD.

library(binancer)
library(data.table)

coins <- data.table(binance_coins_prices(unit = "USDT"))
head(coins)

value <- 0.42 * coins[symbol == "BTC",2]
value

# binance_coins_prices(unit = "USDT")[symbol == "BTC", usd]

# = = = = = = = = = = = = = = = = = =
# Report on the current price of 0.42 BTC in HUF

# we need the rate of USD and HUF:
# foreigen exchange rate API: exchangeratesapi.io

# base USD
# GET https://api.exchangeratesapi.io/latest?base=USD HTTP/1.1


# HUF, base EUR
# GET https://api.exchangeratesapi.io/latest?symbols=HUF HTTP/1.1

readLines("https://api.exchangeratesapi.io/latest?base=USD HTTP/1.1")

library(binancer)
library(jsonlite)
0.42 * binance_coins_prices()[symbol == "BTC", usd] * fromJSON("https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF")$rates$HUF

# = = = = = = = = = = = = = = = = = =
# Improve script
library(binancer)
library(jsonlite)
library(logger)
library(checkmate) 


BITCOINS <- 0.42
log_info("Number of Bitcoins: {BITCOINS}") #glue

get_bitcoin_price <- function() {
  tryCatch(
  binance_coins_prices()[symbol == 'BTC', usd],
  error = function(e) get_bitcoin_price())
}

btcusdt <- binance_coins_prices()[symbol == "BTC", usd]
log_info("Value of 1 BTC in USD: {btcusdt}")
assert_number(btcusdt, lower = 1000) # makes sure this is a number and not lower than 1000

usdhuf <- fromJSON("https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF")$rates$HUF
log_info("Value of 1 USD in HUF: {usdhuf}")
assert_number(usdhuf, lower = 250, upper = 500)

BITCOINS * btcusdt * usdhuf



