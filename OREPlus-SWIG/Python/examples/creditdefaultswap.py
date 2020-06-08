
"""
 Copyright (C) 2019, 2020 Quaternion Risk Management Ltd
 All rights reserved.
"""

from OREPlus import *

"""
Index Credit Default Swap Example
"""

# Parameters
todays_date = Date(4, October, 2018)
Settings.instance().evaluationDate = todays_date
pay_tenor = Period(Quarterly)
calendar = TARGET()
settlement_date = calendar.advance(todays_date, Period(2, Years))
maturity_date = calendar.advance(todays_date, Period(5, Years))
bdc = ModifiedFollowing
day_counter = Actual365Fixed()
notional = 10000000
underlyingNotionals = [10000000, 20000000, 30000000]
spread = 0.01
side = Protection.Buyer
upfront = 0
settles_accrual = True
protection_payment_time = QLECreditDefaultSwap.atDefault

# Define CDS schedule
schedule = Schedule(settlement_date, maturity_date,
                    pay_tenor, calendar,
                    bdc, bdc, DateGeneration.Forward, False)

# Define CDS
cds = IndexCreditDefaultSwap(side, notional, underlyingNotionals,
                             upfront, spread,
                             schedule, bdc, day_counter,
                             settles_accrual, protection_payment_time,
                             settlement_date)


# Define the probability curve and discount curve
recovery_rate = 0.4
hazard_rate = 0.02
hazard_curve = FlatHazardRate(todays_date, QuoteHandle(SimpleQuote(hazard_rate)), day_counter)
probability_curve = DefaultProbabilityTermStructureHandle(hazard_curve)
discount_curve = YieldTermStructureHandle(FlatForward(todays_date, 0.01, day_counter))

# Define pricing engine and attach it to the CDS
engine = MidPointIndexCdsEngine(probability_curve, recovery_rate, discount_curve)
cds.setPricingEngine(engine)

# Test Simple Inspectors
assert cds.side() == side
assert cds.notional() == notional
assert cds.runningSpread() == spread
assert cds.settlesAccrual() == settles_accrual
assert cds.protectionPaymentTime() == protection_payment_time
assert cds.protectionStartDate() == settlement_date
assert cds.protectionEndDate() == maturity_date
assert tuple(cds.underlyingNotionals()) == tuple(underlyingNotionals)

# Test Consistency
fair_spread = cds.fairSpread()
# Recreate CDS using fair spread. NPV should be 0
fair_cds = IndexCreditDefaultSwap(side, notional, underlyingNotionals,
                                  upfront, fair_spread,
                                  schedule, bdc, day_counter,
                                  settles_accrual, protection_payment_time,
                                  settlement_date)
fair_cds.setPricingEngine(engine)
tol = 1e-8
assert abs(fair_cds.NPV()) < tol

# Calculate implied hazard rate. It should match the input hazard rate
implied_hazard_rate = cds.impliedHazardRate(cds.NPV(), discount_curve, day_counter,
                                            recovery_rate, 1.0e-12)
assert abs(implied_hazard_rate - hazard_rate) < tol


"""
Index Credit Default Swap Option Example
"""

# Extra parameters for CDS Option
exercise_date = calendar.advance(todays_date, Period(1, Years))
exercise = EuropeanExercise(exercise_date)
cds_option = IndexCdsOption(cds, exercise)

# Define volatility curve
vol = 0.03
volatility = BlackConstantVol(0, calendar, QuoteHandle(SimpleQuote(vol)), day_counter)
volatility_curve = BlackVolTermStructureHandle(volatility)

# Define pricing engine and attach it to the CDSOption
option_engine = BlackIndexCdsOptionEngine(probability_curve, recovery_rate,
                                          discount_curve, volatility_curve)
cds_option.setPricingEngine(option_engine)

# Test Simple Inspectors
assert cds_option.underlyingSwap().notional() == cds.notional()
assert cds_option.underlyingSwap().side() == cds.side()


# Test Consistency
atm_rate = cds_option.atmRate()
# Recreate CDS and CDSOptions using atm rate. NPV of buyer option should match NPV of seller option
buyer_cds = IndexCreditDefaultSwap(Protection.Buyer, notional, underlyingNotionals,
                                   upfront, atm_rate,
                                   schedule, bdc, day_counter,
                                   settles_accrual, protection_payment_time,
                                   settlement_date)
seller_cds = IndexCreditDefaultSwap(Protection.Seller, notional, underlyingNotionals,
                                    upfront, atm_rate,
                                    schedule, bdc, day_counter,
                                    settles_accrual, protection_payment_time,
                                    settlement_date)
buyer_cds.setPricingEngine(engine)
seller_cds.setPricingEngine(engine)
buyer_cds_option = IndexCdsOption(buyer_cds, exercise)
seller_cds_option = IndexCdsOption(seller_cds, exercise)
buyer_cds_option.setPricingEngine(option_engine)
seller_cds_option.setPricingEngine(option_engine)
assert abs(buyer_cds_option.NPV() - seller_cds_option.NPV()) < tol

# Calculate implied volatility. It should match the input volatility
implied_vol = cds_option.impliedVolatility(cds_option.NPV(), discount_curve,
                                           probability_curve, recovery_rate)
tol = 1e-5
assert abs(implied_vol - vol) < tol


"""
Using vector of underlying default probability curves
"""
# Define the probability curves and discount curve
recovery_rates = [0.4, 0.39, 0.37]
hazard_rates = [0.02, 0.022, 0.021]
hazard_curves = [FlatHazardRate(todays_date, QuoteHandle(SimpleQuote(h)), day_counter) for h in hazard_rates]
probability_curves = DefaultProbailityTermStructureHandleVector([
    DefaultProbabilityTermStructureHandle(hc) for hc in hazard_curves])
discount_curve = YieldTermStructureHandle(FlatForward(todays_date, 0.01, day_counter))

# Define pricing engine and attach it to the CDS
engine = MidPointIndexCdsEngine(probability_curves, recovery_rates, discount_curve)
cds.setPricingEngine(engine)
assert cds.fairSpread() - fair_spread > tol

option_engine = BlackIndexCdsOptionEngine(probability_curves, recovery_rates,
                                          discount_curve, volatility_curve)
cds_option.setPricingEngine(option_engine)
assert cds_option.atmRate() - atm_rate > tol
