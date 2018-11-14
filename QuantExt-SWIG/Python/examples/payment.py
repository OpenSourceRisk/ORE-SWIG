
from QuantExt import *

# global data
todays_date = Date(1, November, 2018)
Settings.instance().evaluationDate = todays_date

# instrument
currency = GBPCurrency()
maturity_date = Date(1, November, 2019)
day_counter = Actual365Fixed()
nominal=100.0

# market
spot_fx = QuoteHandle(SimpleQuote(1.0))
GBP_interest_rate = 0.03

# discount curves
GBP_flat_forward = FlatForward(todays_date, GBP_interest_rate, day_counter)
GBP_discount_curve = RelinkableYieldTermStructureHandle()
GBP_discount_curve.linkTo(GBP_flat_forward)

payment=Payment(nominal,currency,maturity_date)

includeSettlementDateFlows=True
settlementDate=maturity_date
npvDate=todays_date
discountCurve=GBP_discount_curve
spotFX=spot_fx

engine = PaymentDiscountingEngine(discountCurve, spotFX, includeSettlementDateFlows,settlementDate,npvDate)

payment.setPricingEngine(engine)

print("Evaluation date: " + str(todays_date))
print("Payment settlement date: " + str(payment.cashFlow().date()))
print("Payment currency: " + payment.currency().name())
print("Payment amount: " + payment.currency().code() + " " + str(payment.cashFlow().amount()))
print("GBP interest rate: " + str(GBP_interest_rate))
print("Payment NPV: " + str(payment.NPV()))

