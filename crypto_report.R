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
