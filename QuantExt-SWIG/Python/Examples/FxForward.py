
# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from QuantExt import *

def formatPrice(p,digits=2):
    format = '%%.%df' % digits
    return format % p

# global data
todays_date = Date(4, October, 2018);
Settings.instance().evaluationDate = todays_date

# instrument
currency1 = GBPCurrency()
currency2 = EURCurrency()
maturity_date = Date(4, October, 2022)
day_counter = Actual365Fixed()
pay_currency1 = True
nominal1 = 1000.0

# market
spot_fx = QuoteHandle(SimpleQuote(1.1))
GBP_interest_rate = 0.03
EUR_interest_rate = 0.02

# discount curves
GBP_flat_forward = FlatForward(todays_date, GBP_interest_rate, day_counter)
EUR_flat_forward = FlatForward(todays_date, EUR_interest_rate, day_counter)
GBP_discount_curve = RelinkableYieldTermStructureHandle()
EUR_discount_curve = RelinkableYieldTermStructureHandle()
GBP_discount_curve.linkTo(GBP_flat_forward)
EUR_discount_curve.linkTo(EUR_flat_forward)

# fair forward rate
forward_rate = (EUR_discount_curve.discount(maturity_date) \
     / GBP_discount_curve.discount(maturity_date)) * spot_fx.value()
nominal2 = nominal1 / forward_rate 

# make FX forward
instrument = FxForward(nominal1, currency1, nominal2, currency2, 
                       maturity_date, pay_currency1);
engine = DiscountingFxForwardEngine(currency1, GBP_discount_curve, 
                                    currency2, EUR_discount_curve,
                                    spot_fx)
instrument.setPricingEngine(engine)

print(instrument.currency1().code() + "/" + instrument.currency2().code(),
         "FX Forward, NPV = " + formatPrice(instrument.NPV()),
         instrument.currency1().code())


