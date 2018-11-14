"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class FxForwardTest(unittest.TestCase):
    def setUp(self):
        """ Set-up FxForward and engine. """
        self.todays_date = Date(4, October, 2018);
        Settings.instance().evaluationDate = self.todays_date
        self.nominal1 = 1000
        self.nominal2 = 1000
        self.currency1 = GBPCurrency()
        self.currency2 = EURCurrency()
        self.maturity_date = Date(4, October, 2022)
        self.pay_currency1 = True
        self.day_counter = Actual365Fixed()
        self.fxForward = FxForward(self.nominal1, self.currency1,
                                   self.nominal2, self.currency2,
                                   self.maturity_date, self.pay_currency1)
        self.spot_fx = QuoteHandle(SimpleQuote(1.1))
        self.gbp_flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter)
        self.eur_flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter)
        self.gbp_term_structure_handle = RelinkableYieldTermStructureHandle(self.gbp_flat_forward)
        self.eur_term_structure_handle = RelinkableYieldTermStructureHandle(self.eur_flat_forward)
        self.engine = DiscountingFxForwardEngine(self.currency1, self.gbp_term_structure_handle,
                                            self.currency2, self.eur_term_structure_handle,
                                            self.spot_fx)
        self.fxForward.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test FxForward simple inspectors. """
        self.assertEqual(self.fxForward.currency1Nominal(), self.nominal1)
        self.assertEqual(self.fxForward.currency2Nominal(), self.nominal2)
        self.assertEqual(self.fxForward.maturityDate(), self.maturity_date)
        self.assertEqual(self.fxForward.payCurrency1(), self.pay_currency1)
        self.assertEqual(self.fxForward.currency1(), self.currency1)
        self.assertEqual(self.fxForward.currency2(), self.currency2)

    def testFairForwardRate(self):
        """ Test fairForwardRate(). """
        self.nominal2 = self.fxForward.fairForwardRate().exchange(Money(self.currency1, self.nominal1)).value()
        self.fxForward = FxForward(self.nominal1, self.currency1,
                                   self.nominal2, self.currency2,
                                   self.maturity_date, self.pay_currency1)
        self.fxForward.setPricingEngine(self.engine)
        self.assertEqual(round(self.fxForward.NPV(), 4), 0)
        

if __name__ == '__main__':
    unittest.main()

