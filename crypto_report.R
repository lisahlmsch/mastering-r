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

BITCOINS <- 0.42
log_info("Number of Bitcoins: {BITCOINS}") #glue

## TODO the Binance API is a bit of mess .. need to add retries => tryCatch

get_bitcoin_price <- function() {
  tryCatch(
  binance_coins_prices()[symbol == 'BTC', usd],
  error = function(e) get_bitcoin_price())
}
get_bitcoin_price()

# tryCatch(binance_coins_prices()[symbol == "BTC", usd],
#          error = function(e) { # e is the error message
#            binance_coins_prices()[symbol == "BTC", usd]
#          }) 

btcusdt <- binance_coins_prices()[symbol == "BTC", usd]
log_info("Value of 1 BTC in USD: {btcusdt}")

usdhuf <- fromJSON("https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF")$rates$HUF
log_info("Value of 1 USD in HUF: {usdhuf}")

BITCOINS * btcusdt * usdhuf



