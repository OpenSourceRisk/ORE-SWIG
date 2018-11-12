
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
nominal1 = 1000.0
nominal2 = 1000.0
currency1 = GBPCurrency()
currency2 = EURCurrency()
maturity_date = Date(4, October, 2022)
pay_currency1 = True
 
instrument = FxForward(nominal1, currency1, nominal2, currency2, maturity_date, pay_currency1);

# spot fx
spot_fx = QuoteHandle(SimpleQuote(1.1))

# discount curves
tsDayCounter = Actual365Fixed()
GBP_flat_forward = FlatForward(todays_date, 0.03, tsDayCounter)
EUR_flat_forward = FlatForward(todays_date, 0.02, tsDayCounter)
GBP_discount_term_structure = RelinkableYieldTermStructureHandle()
EUR_discount_term_structure = RelinkableYieldTermStructureHandle()
GBP_discount_term_structure.linkTo(GBP_flat_forward)
EUR_discount_term_structure.linkTo(EUR_flat_forward)

engine = DiscountingFxForwardEngine(currency1, GBP_discount_term_structure, 
                                    currency2, EUR_discount_term_structure,
                                    spot_fx)

instrument.setPricingEngine(engine)

print(instrument.currency1().code() + "/" + instrument.currency2().code(),
         "FX Forward, NPV = " + formatPrice(instrument.NPV()),
         instrument.currency1().code())


