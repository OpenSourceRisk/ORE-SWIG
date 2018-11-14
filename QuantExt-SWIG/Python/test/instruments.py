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

    def testConsistency(self):
        """ Test consistence of fair price and NPV() """
        tolerance = 1.0e-10
        fair_nominal2 = self.fxForward.fairForwardRate().exchange(Money(self.currency1, self.nominal1)).value()
        fxForward = FxForward(self.nominal1, self.currency1,
                                   fair_nominal2, self.currency2,
                                   self.maturity_date, self.pay_currency1)
        fxForward.setPricingEngine(self.engine)
        self.assertFalse(abs(fxForward.NPV()) > tolerance)

        
class DepositTest(unittest.TestCase):
    def setUp(self):
        """ Set-up Deposit and engine. """
        self.todays_date= Date(6, October, 2018)
        self.trade_date = Date(6, October, 2018)
        Settings.instance().evaluationDate = self.trade_date
        self.nominal = 1000
        self.calendar = TARGET()
        self.bdc = ModifiedFollowing
        self.end_of_month = False
        self.day_counter = Actual365Fixed()
        self.rate = 0.02
        self.period = Period(3, Years)
        self.fixing_days = 2
        self.fixing_date = self.calendar.adjust(self.trade_date)
        self.start_date = self.calendar.advance(self.fixing_date, self.fixing_days, Days, self.bdc)
        self.maturity_date = self.calendar.advance(self.start_date, self.period, self.bdc)
        self.deposit = Deposit(self.nominal, self.rate, self.period,
                               self.fixing_days, self.calendar, self.bdc, 
                               self.end_of_month, self.day_counter, 
                               self.trade_date)
        self.flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter)
        self.term_structure_handle = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.engine = DepositEngine(self.term_structure_handle, False, self.trade_date, self.trade_date)
        self.deposit.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test FxForward simple inspectors. """
        self.assertEqual(self.deposit.fixingDate(), self.fixing_date)
        self.assertEqual(self.deposit.startDate(), self.start_date)
        self.assertEqual(self.deposit.maturityDate(), self.maturity_date)

    def testConsistency(self):
        """ Test consistence of fair price and NPV() """
        tolerance = 1.0e-10
        fair_rate = self.deposit.fairRate()
        deposit = Deposit(self.nominal, fair_rate, self.period,
                          self.fixing_days, self.calendar, self.bdc, 
                          self.end_of_month, self.day_counter, 
                          self.trade_date)
        deposit.setPricingEngine(self.engine)
        self.assertFalse(abs(deposit.NPV()) > tolerance)
        

if __name__ == '__main__':
    unittest.main()

