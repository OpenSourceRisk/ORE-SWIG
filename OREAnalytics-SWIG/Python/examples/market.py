
# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREAnalytics import *

print ("Loading parameters...")
params = Parameters()
print ("   params is of type", type(params))
params.fromFile("Input/ore.xml")
print ("   setup/asofdate = " + params.get("setup","asofDate"))

print ("Building ORE App...")
ore = OREApp(params)
print ("   ore is of type", type(ore))

print ("Running ORE process...");
# Run it all 
# ore.run()
# Run bootstraps only (conventions, curve configuration, construction)
ore.buildMarket()

print ("Retrieve market object from ORE...");
market = ore.getMarket()
print ("   retrieved market is of type", type(market))
asof = market.asofDate();
print ("   retrieved market's asof date is", asof)

ccy = "EUR"
index = "EUR-EURIBOR-6M"
print ("Get term structures for ccy ", ccy, "and index", index);

discountCurve = market.discountCurve(ccy)
print ("   discount curve is of type", type(discountCurve))

iborIndex = market.iborIndex(index)
print ("   ibor index is of type", type(iborIndex))

forwardCurve = iborIndex.forwardingTermStructure()
print ("   forward curve is of type", type(forwardCurve))

print ("Evaluate term structures");
date = asof + 10*Years;
zeroRateDc = Actual365Fixed()
discount = discountCurve.discount(date)
zero = discountCurve.zeroRate(date, zeroRateDc, Continuous)
fwdDiscount = forwardCurve.discount(date)
fwdZero = forwardCurve.zeroRate(date, zeroRateDc, Continuous)
print ("   10y discount factor (discount curve) is", discount)
print ("   10y discout factor (forward curve) is", fwdDiscount)
print ("   10y zero rate (discount curve) is", zero)
print ("   10y zero rate (forward curve) is", fwdZero)

print("Done")
