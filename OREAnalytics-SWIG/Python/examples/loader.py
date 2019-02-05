
# Copyright (C) 2019 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREAnalytics import *

#20160205 CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/4Y -0.008303
date = Date(5, February, 2016)
name = "CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/4Y"
value = -0.008303

def check_data(loader):
    assert loader.has(name, date)

    quote = loader.get(name, date)
    assert quote.name() == name
    assert quote.quote().value() == value
    assert quote.asofDate() == date
    assert quote.instrumentType() == MarketDatum.InstrumentType_CC_BASIS_SWAP
    assert quote.quoteType() == MarketDatum.QuoteType_BASIS_SPREAD

    quote2 = loader.get(StringBoolPair(name, True), date)
    assert quote.name() == quote2.name()
    assert quote.quote().value() == quote2.quote().value()
    assert quote.asofDate() == quote2.asofDate()
    assert quote.instrumentType() == quote2.instrumentType()
    assert quote.quoteType() == quote2.quoteType()

    quote2 = loader.loadQuotes(date)[19]
    assert quote.name() == quote2.name()
    assert quote.quote().value() == quote2.quote().value()
    assert quote.asofDate() == quote2.asofDate()
    assert quote.instrumentType() == quote2.instrumentType()
    assert quote.quoteType() == quote2.quoteType()

csv_loader = CSVLoader("Input/market_20160205.txt", "Input/fixings_20160205.txt", True)
check_data(csv_loader)

im_loader = InMemoryLoader()
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/3M", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/1Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/2Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/3Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/4Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/5Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/6Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/7Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/8Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/9Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/10Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/12Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/15Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/20Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/25Y", 0.8)
im_loader.add(date, "BMA_SWAP/RATIO/USD/3M/30Y", 0.8)
im_loader.add(date, "CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/1Y", -0.006119)
im_loader.add(date, "CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/2Y", -0.006647)
im_loader.add(date, "CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/3Y", -0.007387)
im_loader.add(date, "CC_BASIS_SWAP/BASIS_SPREAD/USD/3M/CHF/3M/4Y", -0.008303)

check_data(im_loader)

