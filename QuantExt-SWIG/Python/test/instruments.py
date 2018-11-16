"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class CommodityForwardTest(unittest.TestCase):
    def setUp(self):
        """ Set-up CommodityForward and engine """
        self.todays_date = Date(4, October, 2018);
        Settings.instance().evaluationDate = self.todays_date
        self.name = "Natural Gas"
        self.calendar = TARGET()
        self.currency = GBPCurrency()
        self.strike = 100.0
        self.quantity = 1.0
        self.position = Position.Long
        self.maturity_date = Date(4, October, 2022)
        self.day_counter = Actual365Fixed()
        self.commodity_forward = CommodityForward(self.name, self.currency, 
                                                  self.position, self.quantity, 
                                                  self.maturity_date, self.strike)
        self.dates = [ Date(20,12,2018), Date(20, 3,2019), Date(19, 6,2019),
                       Date(18, 9,2019), Date(18,12,2019), Date(19, 3,2020),
                       Date(18, 6,2020), Date(17, 9,2020), Date(17,12,2020) ]
        self.quotes = [ QuoteHandle(SimpleQuote(100.0)), QuoteHandle(SimpleQuote(100.25)),
                        QuoteHandle(SimpleQuote(100.75)), QuoteHandle(SimpleQuote(101.0)),
                        QuoteHandle(SimpleQuote(101.25)), QuoteHandle(SimpleQuote(101.50)),
                        QuoteHandle(SimpleQuote(101.75)), QuoteHandle(SimpleQuote(102.0)),
                        QuoteHandle(SimpleQuote(102.25)) ]
        self.price_curve = PriceCurve(self.dates, self.quotes, self.day_counter)
        self.price_curve.enableExtrapolation();
        self.price_term_structure = RelinkablePriceTermStructureHandle(self.price_curve)
        self.flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter);
        self.discount_term_structure = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.engine = DiscountingCommodityForwardEngine(self.price_term_structure, self.discount_term_structure)
        self.commodity_forward.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test CommodityForward simple inspectors. """
        self.assertEqual(self.commodity_forward.name(), self.name)
        self.assertEqual(self.commodity_forward.currency(), self.currency)
        self.assertEqual(self.commodity_forward.position(), self.position)
        self.assertEqual(self.commodity_forward.quantity(), self.quantity)
        self.assertEqual(self.commodity_forward.maturityDate(), self.maturity_date)
        self.assertEqual(self.commodity_forward.strike(), self.strike)
        

    def testNPV(self):
        """ Test NPV() """
        self.assertIsNotNone(self.commodity_forward.NPV())
        

class SubPeriodsSwapTest(unittest.TestCase):
    def setUp(self):
        """ Set-up SubPeriodsSwap. """
        self.todays_date = Date(4, October, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.settlement_date = Date(6, October, 2018)
        self.is_payer = True
        self.fixed_rate = 0.02
        self.sub_periods_type = SubPeriodsCoupon.Compounding
        self.calendar = TARGET()
        self.swap_tenor = Period(10, Years)
        self.maturity_date = self.calendar.advance(self.settlement_date, self.swap_tenor)
        self.float_pay_tenor = Period(6, Months)
        self.fixed_tenor = Period(6, Months)
        self.day_counter = Actual365Fixed()
        self.nominal = 1000000.0
        self.bdc = ModifiedFollowing
        self.date_generation = DateGeneration.Forward
        self.ois_term_structure = RelinkableYieldTermStructureHandle()
        self.float_term_structure = RelinkableYieldTermStructureHandle()
        self.float_index = Euribor3M(self.float_term_structure)
        self.schedule = Schedule(self.settlement_date, self.maturity_date,
                                       self.float_pay_tenor, self.calendar,
                                       self.bdc, self.bdc, self.date_generation, False)
        self.sub_periods_swap = SubPeriodsSwap(self.settlement_date, self.nominal, self.swap_tenor,
                                               self.is_payer, self.fixed_tenor, self.fixed_rate,
                                               self.calendar, self.day_counter, self.bdc, 
                                               self.float_pay_tenor, self.float_index, 
                                               self.day_counter, self.date_generation, self.sub_periods_type)
        self.float_flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter)
        self.ois_flat_forward = FlatForward(self.todays_date, 0.01, self.day_counter)
        self.float_term_structure.linkTo(self.float_flat_forward)
        self.ois_term_structure.linkTo(self.ois_flat_forward)
        self.engine = DiscountingSwapEngine(self.ois_term_structure)
        self.sub_periods_swap.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test SubPeriodsSwap simple inspectors. """
        self.assertEqual(self.sub_periods_swap.nominal(), self.nominal)
        self.assertEqual(self.sub_periods_swap.isPayer(), self.is_payer)
        self.assertEqual(self.sub_periods_swap.fixedRate(), self.fixed_rate)
        self.assertEqual(self.sub_periods_swap.type(), self.sub_periods_type)
        self.assertEqual(self.sub_periods_swap.floatPayTenor(), self.float_pay_tenor)
    
    def testSchedules(self):
        """ Test SubPeriodsSwap schedules. """
        for i, d in enumerate(self.schedule):
            self.assertEqual(self.sub_periods_swap.fixedSchedule()[i], d)

    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        # lower tolerance, since fair rate is approximated using PV01 for this class
        tolerance = 1.0e-8
        fair_rate = self.sub_periods_swap.fairRate()
        sub_periods_swap = SubPeriodsSwap(self.settlement_date, self.nominal, self.swap_tenor,
                                          self.is_payer, self.fixed_tenor, fair_rate,
                                          self.calendar, self.day_counter, self.bdc, 
                                          self.float_pay_tenor, self.float_index, 
                                          self.day_counter, self.date_generation, self.sub_periods_type)
        sub_periods_swap.setPricingEngine(self.engine)
        self.assertFalse(abs(sub_periods_swap.NPV()) > tolerance)


class TenorBasisSwapTest(unittest.TestCase):
    def setUp(self):
        """ Set-up TenorBasisSwap and engine. """
        self.todays_date = Date(4, October, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.settlement_date = Date(6, October, 2018)
        self.calendar = TARGET()
        self.day_counter = Actual365Fixed()
        self.nominal = 1000000.0
        self.maturity_date = self.calendar.advance(self.settlement_date, 5, Years)
        self.pay_long_index = False
        self.short_index_pay_tenor = Period(6, Months)
        self.long_index_pay_tenor = Period(6, Months)
        self.short_index_leg_spread = 0.0
        self.long_index_leg_spread = 0.01
        self.bdc = ModifiedFollowing
        self.date_generation = DateGeneration.Forward
        self.end_of_month = False
        self.include_spread = False
        self.sub_periods_type = SubPeriodsCoupon.Compounding
        self.ois_term_structure = RelinkableYieldTermStructureHandle()
        self.short_index_term_structure = RelinkableYieldTermStructureHandle()
        self.long_index_term_structure = RelinkableYieldTermStructureHandle()
        self.short_index = Euribor3M(self.short_index_term_structure)
        self.long_index = Euribor6M(self.long_index_term_structure)
        self.short_index_schedule = Schedule(self.settlement_date, self.maturity_date,
                                            self.short_index_pay_tenor, self.calendar,
                                            self.bdc, self.bdc, self.date_generation,
                                            self.end_of_month)
        self.long_index_schedule = Schedule(self.settlement_date, self.maturity_date,
                                            self.long_index_pay_tenor, self.calendar,
                                            self.bdc, self.bdc, self.date_generation,
                                            self.end_of_month)
        self.tenor_basis_swap = TenorBasisSwap(self.nominal, self.pay_long_index, self.long_index_schedule,
                                               self.long_index, self.long_index_leg_spread,
                                               self.short_index_schedule, self.short_index, 
                                               self.short_index_leg_spread, self.include_spread, 
                                               self.sub_periods_type)
        self.short_index_flat_forward = FlatForward(self.todays_date, 0.02, self.short_index.dayCounter())
        self.long_index_flat_forward = FlatForward(self.todays_date, 0.03, self.long_index.dayCounter())
        self.ois_flat_forward = FlatForward(self.todays_date, 0.01, self.day_counter)
        self.short_index_term_structure.linkTo(self.short_index_flat_forward)
        self.long_index_term_structure.linkTo(self.long_index_flat_forward)
        self.ois_term_structure.linkTo(self.ois_flat_forward)
        self.engine = DiscountingSwapEngine(self.ois_term_structure)
        self.tenor_basis_swap.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test TenorBasisSwap simple inspectors. """
        self.assertEqual(self.tenor_basis_swap.nominal(), self.nominal)
        self.assertEqual(self.tenor_basis_swap.payLongIndex(), self.pay_long_index)
        self.assertEqual(self.tenor_basis_swap.longSpread(), self.long_index_leg_spread)
        self.assertEqual(self.tenor_basis_swap.shortSpread(), self.short_index_leg_spread)
        self.assertEqual(self.tenor_basis_swap.type(), self.sub_periods_type)
        self.assertEqual(self.tenor_basis_swap.shortPayTenor(), self.short_index_pay_tenor)
        self.assertEqual(self.tenor_basis_swap.includeSpread(), self.include_spread)
    
    def testSchedules(self):
        """ Test TenorBasisSwap schedules. """
        for i, d in enumerate(self.long_index_schedule):
            self.assertEqual(self.tenor_basis_swap.longSchedule()[i], d)
        for i, d in enumerate(self.short_index_schedule):
            self.assertEqual(self.tenor_basis_swap.shortSchedule()[i], d)

    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-10
        fair_short_leg_spread = self.tenor_basis_swap.fairShortLegSpread()
        tenor_basis_swap = TenorBasisSwap(self.nominal, self.pay_long_index, self.long_index_schedule,
                                          self.long_index, self.long_index_leg_spread,
                                          self.short_index_schedule, self.short_index, 
                                          fair_short_leg_spread, self.include_spread, 
                                          self.sub_periods_type)
        tenor_basis_swap.setPricingEngine(self.engine)
        self.assertFalse(abs(tenor_basis_swap.NPV()) > tolerance)
        

class FxForwardTest(unittest.TestCase):
    def setUp(self):
        """ Set-up FxForward and engine. """
        self.todays_date = Date(4, October, 2018)
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
        """ Test consistency of fair price and NPV() """
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
        self.flat_forward = FlatForward(self.trade_date, 0.03, self.day_counter)
        self.term_structure_handle = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.engine = DepositEngine(self.term_structure_handle, False, self.trade_date, self.trade_date)
        self.deposit.setPricingEngine(self.engine)
  
    def testSimpleInspectors(self):
        """ Test Deposit simple inspectors. """
        self.assertEqual(self.deposit.fixingDate(), self.fixing_date)
        self.assertEqual(self.deposit.startDate(), self.start_date)
        self.assertEqual(self.deposit.maturityDate(), self.maturity_date)

    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-10
        fair_rate = self.deposit.fairRate()
        deposit = Deposit(self.nominal, fair_rate, self.period,
                          self.fixing_days, self.calendar, self.bdc, 
                          self.end_of_month, self.day_counter, 
                          self.trade_date)
        deposit.setPricingEngine(self.engine)
        self.assertFalse(abs(deposit.NPV()) > tolerance)
        

class EquityForwardTest(unittest.TestCase):
    def setUp(self):
        """ Set-up EquityForward and engine. """
        self.todays_date = Date(1, November, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.name = "UNILEVER"
        self.currency = GBPCurrency()
        self.position = Position.Long
        self.quantity = 100
        self.maturityDate = Date(1,November,2019)
        self.strike = 60
        self.equityForward=EquityForward(self.name, self.currency, self.position,
                                         self.quantity, self.maturityDate, self.strike)
        self.tsDayCounter = Actual365Fixed()
        self.interest_rate = 0.03
        self.flatForward = FlatForward(self.todays_date, self.interest_rate, self.tsDayCounter)
        self.equityInterestRateCurve = RelinkableYieldTermStructureHandle()
        self.equityInterestRateCurve.linkTo(self.flatForward)
        self.dividendYieldCurve = RelinkableYieldTermStructureHandle()
        self.dividendYieldCurve.linkTo(self.flatForward)
        self.discountCurve = RelinkableYieldTermStructureHandle()
        self.discountCurve.linkTo(self.flatForward)
        self.equitySpotPrice = 60.0
        self.equitySpot = QuoteHandle(SimpleQuote(self.equitySpotPrice))
        self.includeSettlementDateFlows=True
        self.settlementDate = self.maturityDate
        self.npvDate = self.todays_date
        self.engine = DiscountingEquityForwardEngine(self.equityInterestRateCurve, self.dividendYieldCurve,
                                                     self.equitySpot, self.discountCurve, self.includeSettlementDateFlows,
                                                     self.settlementDate, self.npvDate)
        self.equityForward.setPricingEngine(self.engine)
        
  
    def testSimpleInspectors(self):
        """ Test EquityForward simple inspectors. """
        self.assertEqual(self.strike, self.equityForward.strike())
        self.assertEqual(self.settlementDate, self.equityForward.maturityDate())
        self.assertEqual(self.quantity, self.equityForward.quantity())
        self.assertEqual(self.currency.name(), self.equityForward.currency().name())


    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance= 1.0e-10
        self.assertFalse(abs(self.equityForward.NPV()) > tolerance)
        

if __name__ == '__main__':
    unittest.main()

