
"""
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
"""

from OREPlus import *
import unittest

class IndexCDSOptionTest(unittest.TestCase):
    def setUp(self):
        """ Set-up IndexCDSOption and engine"""
        self.todays_date = Date(4, October, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.pay_tenor = Period(Quarterly)
        self.calendar = TARGET()
        self.settlement_date = self.calendar.advance(self.todays_date, Period(2, Years))
        self.maturity_date = self.calendar.advance(self.todays_date, Period(5, Years))
        self.exercise_date = self.calendar.advance(self.todays_date, Period(1, Years))
        self.exercise = EuropeanExercise(self.exercise_date)
        self.bdc = ModifiedFollowing
        self.day_counter = Actual365Fixed()
        self.notional = 10000000
        self.underlyingNotionals = [10000000, 20000000, 30000000]
        self.schedule = Schedule(self.settlement_date, self.maturity_date,
                                 self.pay_tenor, self.calendar,
                                 self.bdc, self.bdc, DateGeneration.Forward, False)
        self.spread = 0.01
        self.side = Protection.Buyer
        self.upfront = 0
        self.recovery_rate = 0.4
        self.settles_accrual = True
        self.pays_at_default = True
        self.discount_curve = YieldTermStructureHandle(FlatForward(self.todays_date, 0.01, self.day_counter))
        self.hazard_curve = FlatHazardRate(self.todays_date, QuoteHandle(SimpleQuote(0.02)), self.day_counter)
        self.probability_curve = DefaultProbabilityTermStructureHandle(self.hazard_curve)
        self.vol = 0.03
        self.volatility = BlackConstantVol(0, self.calendar, QuoteHandle(SimpleQuote(self.vol)), self.day_counter)
        self.volatility_curve = BlackVolTermStructureHandle(self.volatility)
        self.cds = IndexCreditDefaultSwap(self.side, self.notional, self.underlyingNotionals,
                                          self.upfront, self.spread,
                                          self.schedule, self.bdc, self.day_counter,
                                          self.settles_accrual, self.pays_at_default,
                                          self.settlement_date)
        self.cds_engine = MidPointIndexCdsEngine(self.probability_curve, self.recovery_rate, self.discount_curve)
        self.cds.setPricingEngine(self.cds_engine)
        self.cds_option = IndexCdsOption(self.cds, self.exercise)
        self.engine = BlackIndexCdsOptionEngine(self.probability_curve, self.recovery_rate, 
                                                self.discount_curve, self.volatility_curve)
        self.cds_option.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test IndexCDSOption simple inspectors. """
        self.assertEqual(self.cds_option.underlyingSwap().notional(), self.cds.notional())
        self.assertEqual(self.cds_option.underlyingSwap().side(), self.cds.side())
        
    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-8
        atm_rate = self.cds_option.atmRate()
        buyer_cds = IndexCreditDefaultSwap(Protection.Buyer, self.notional, self.underlyingNotionals,
                                           self.upfront, atm_rate,
                                           self.schedule, self.bdc, self.day_counter,
                                           self.settles_accrual, self.pays_at_default,
                                           self.settlement_date)
        seller_cds = IndexCreditDefaultSwap(Protection.Seller, self.notional, self.underlyingNotionals,
                                            self.upfront, atm_rate,
                                            self.schedule, self.bdc, self.day_counter,
                                            self.settles_accrual, self.pays_at_default,
                                            self.settlement_date)
        buyer_cds.setPricingEngine(self.cds_engine)
        seller_cds.setPricingEngine(self.cds_engine)
        buyer_cds_option = IndexCdsOption(buyer_cds, self.exercise)
        seller_cds_option = IndexCdsOption(seller_cds, self.exercise)
        buyer_cds_option.setPricingEngine(self.engine)
        seller_cds_option.setPricingEngine(self.engine)
        self.assertFalse(abs(buyer_cds_option.NPV() - seller_cds_option.NPV()) > tolerance)
        implied_vol = self.cds_option.impliedVolatility(self.cds_option.NPV(), self.discount_curve,
                                                        self.probability_curve, self.recovery_rate)
        self.assertFalse(abs(implied_vol - self.vol) > 1.0e-5)
        
        
class IndexCreditDefaultSwapTest(unittest.TestCase):
    def setUp(self):
        """ Set-up IndexCreditDefaultSwap and engine"""
        self.todays_date = Date(4, October, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.settlement_date = Date(6, October, 2018)
        self.swap_tenor = Period(2, Years)
        self.pay_tenor = Period(Quarterly)
        self.calendar = TARGET()
        self.maturity_date = self.calendar.advance(self.settlement_date, self.swap_tenor)
        self.bdc = ModifiedFollowing
        self.day_counter = Actual365Fixed()
        self.notional = 10000000
        self.underlyingNotionals = [10000000, 20000000, 30000000]
        self.schedule = Schedule(self.settlement_date, self.maturity_date,
                                 self.pay_tenor, self.calendar,
                                 self.bdc, self.bdc, DateGeneration.Forward, False)
        self.spread = 0.012
        self.side = Protection.Buyer
        self.upfront = 0
        self.settles_accrual = True
        self.pays_at_default = True
        self.discount_curve = YieldTermStructureHandle(FlatForward(self.todays_date, 0.01, self.day_counter))
        self.recovery_rate = 0.4
        self.hazard_rate = 0.015
        self.hazard_curve = FlatHazardRate(self.todays_date, QuoteHandle(SimpleQuote(self.hazard_rate)), self.day_counter)
        self.probability_curve = DefaultProbabilityTermStructureHandle(self.hazard_curve)
        self.cds = IndexCreditDefaultSwap(self.side, self.notional, self.underlyingNotionals,
                                          self.upfront, self.spread,
                                          self.schedule, self.bdc, self.day_counter,
                                          self.settles_accrual, self.pays_at_default,
                                          self.settlement_date)
        self.engine = MidPointIndexCdsEngine(self.probability_curve, self.recovery_rate, self.discount_curve)
        self.cds.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test IndexCreditDefaultSwap simple inspectors. """
        self.assertEqual(self.cds.side(), self.side)
        self.assertEqual(self.cds.notional(), self.notional)
        self.assertEqual(self.cds.runningSpread(), self.spread)
        self.assertEqual(self.cds.settlesAccrual(), self.settles_accrual)
        self.assertEqual(self.cds.paysAtDefaultTime(), self.pays_at_default)
        self.assertEqual(self.cds.protectionStartDate(), self.settlement_date)
        self.assertEqual(self.cds.protectionEndDate(), self.maturity_date)
        self.assertEqual(tuple(self.cds.underlyingNotionals()), tuple(self.underlyingNotionals))
        
    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-8
        fair_spread = self.cds.fairSpread()
        cds = IndexCreditDefaultSwap(self.side, self.notional, self.underlyingNotionals,
                                     self.upfront, fair_spread,
                                     self.schedule, self.bdc, self.day_counter,
                                     self.settles_accrual, self.pays_at_default,
                                     self.settlement_date)
        cds.setPricingEngine(self.engine)
        self.assertFalse(abs(cds.NPV()) > tolerance)
        #implied_hazard_rate = self.cds.impliedHazardRate(self.cds.NPV(), self.discount_curve, self.day_counter,
        #                                                 self.recovery_rate, 1.0e-12)
        #self.assertFalse(abs(implied_hazard_rate - self.hazard_rate) > tolerance)


if __name__ == '__main__':
    import QuantExt
    print('testing OREPlus ' + OREPlus.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(IndexCreditDefaultSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(IndexCDSOptionTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)

