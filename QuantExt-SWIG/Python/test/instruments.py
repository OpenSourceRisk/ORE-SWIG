"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class AverageOISTest(unittest.TestCase):
    def setUp(self):
        """ Set-up AverageOIS and engine """
        self.todays_date = Date(4, October, 2018)
        Settings.instance().evaluationDate = self.todays_date
        self.settlement_date = Date(6, October, 2018)
        self.swap_tenor = Period(10, Years)
        self.pay_tenor = Period(6, Months)
        self.calendar = UnitedStates()
        self.maturity_date = self.calendar.advance(self.settlement_date, self.swap_tenor)
        self.type = AverageOIS.Payer
        self.bdc = ModifiedFollowing
        self.day_counter = Actual365Fixed()
        self.nominal = 10000000
        self.schedule = Schedule(self.settlement_date, self.maturity_date,
                                 self.pay_tenor, self.calendar,
                                 self.bdc, self.bdc, DateGeneration.Forward, False)
        self.fixed_rate = 0.03
        self.flat_forward = FlatForward(self.todays_date, 0.02, self.day_counter)
        self.term_structure = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.index = FedFunds(self.term_structure)
        self.rate_cut_off = 0
        self.on_spread = 0.0
        self.on_gearing = 1.0
        self.coupon_pricer = AverageONIndexedCouponPricer(AverageONIndexedCouponPricer.Takada)
        self.swap = AverageOIS(self.type, self.nominal, self.schedule, self.fixed_rate,
                               self.day_counter, self.bdc, self.calendar, self.schedule,
                               self.index, self.bdc, self.calendar, self.rate_cut_off, 
                               self.on_spread, self.on_gearing, self.day_counter, self.coupon_pricer)
        self.engine = DiscountingSwapEngine(self.term_structure)
        self.swap.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test AverageOIS simple inspectors. """
        self.assertEqual(self.swap.type(), self.type)
        self.assertEqual(self.swap.nominal(), self.nominal)
        self.assertEqual(self.swap.fixedRate(), self.fixed_rate)
        self.assertEqual(self.swap.fixedDayCounter(), self.day_counter)
        self.assertEqual(self.swap.rateCutoff(), self.rate_cut_off)
        self.assertEqual(self.swap.onSpread(), self.on_spread)
        self.assertEqual(self.swap.onGearing(), self.on_gearing)
        self.assertEqual(self.swap.onDayCounter(), self.day_counter)
        self.assertEqual(self.swap.overnightIndex().name(), self.index.name())
        self.assertEqual(self.swap.overnightIndex().businessDayConvention(), self.index.businessDayConvention())
            
    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-8
        fair_fixed_rate = self.swap.fairRate()
        swap = AverageOIS(self.type, self.nominal, self.schedule, fair_fixed_rate,
                          self.day_counter, self.bdc, self.calendar, self.schedule,
                          self.index, self.bdc, self.calendar, self.rate_cut_off, 
                          self.on_spread, self.on_gearing, self.day_counter, self.coupon_pricer)
        swap.setPricingEngine(self.engine)
        self.assertFalse(abs(swap.NPV()) > tolerance)
        fair_spread = self.swap.fairSpread()
        swap = AverageOIS(self.type, self.nominal, self.schedule, self.fixed_rate,
                          self.day_counter, self.bdc, self.calendar, self.schedule,
                          self.index, self.bdc, self.calendar, self.rate_cut_off, 
                          fair_spread, self.on_gearing, self.day_counter, self.coupon_pricer)
        swap.setPricingEngine(self.engine)
        self.assertFalse(abs(swap.NPV()) > tolerance)

class CrossCurrencyFixFloatSwapTest(unittest.TestCase):
    def setUp(self):
        """ Set-up CrossCurrencyFixFloatSwap and engine """
        self.todayDate = Date(11, November, 2018)
        self.nominal1 = 10000000
        self.nominal2 = 12000000
        self.currency1 = USDCurrency()
        self.currency2 = EURCurrency()
        self.settlementDate = Date(13, November, 2018)
        self.calendar = TARGET()
        self.tsDayCounter = Actual365Fixed()
        self.busDayConvention = Following
        self.forwardStart = self.calendar.advance(self.settlementDate, 1, Years)
        self.forwardEnd = self.calendar.advance(self.forwardStart, 5, Years)
        self.payLag = 1
        self.tenor = Period(6, Months)
        self.bdc = ModifiedFollowing
        self.schedule = Schedule(self.forwardStart, self.forwardEnd, self.tenor, self.calendar,
                                 self.bdc, self.bdc, DateGeneration.Forward, False)
        self.flatForwardUSD = FlatForward(self.todayDate, 0.005, self.tsDayCounter)
        self.discountTermStructureUSD = RelinkableYieldTermStructureHandle(self.flatForwardUSD)
        self.flatForwardEUR = FlatForward(self.todayDate, 0.03, self.tsDayCounter);
        self.discountTermStructureEUR = RelinkableYieldTermStructureHandle(self.flatForwardEUR)
        self.floatSpread = 0.0
        self.index = USDLibor(Period(3, Months), self.discountTermStructureUSD)
        self.couponRate = 0.03
        self.type = CrossCcyFixFloatSwap.Payer
        self.fxQuote = QuoteHandle(SimpleQuote(1/0.8))
        self.swap = CrossCcyFixFloatSwap(self.type, self.nominal2, self.currency2,
                                         self.schedule, self.couponRate, self.tsDayCounter,
                                         self.busDayConvention, self.payLag, self.calendar,
                                         self.nominal1, self.currency1, self.schedule,
                                         self.index, self.floatSpread, self.busDayConvention,
                                         self.payLag, self.calendar)
        self.engine = CrossCcySwapEngine(self.currency1, self.discountTermStructureEUR, self.currency2,
                                         self.discountTermStructureUSD, self.fxQuote, False,
                                         self.settlementDate, self.todayDate)
        self.swap.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test CrossCurrencyFixFloatSwap simple inspectors. """
        self.assertEqual(self.swap.type(), self.type)
        self.assertEqual(self.swap.fixedNominal(), self.nominal2)
        self.assertEqual(self.swap.fixedCurrency(), self.currency2)
        self.assertEqual(self.swap.fixedRate(), self.couponRate)
        self.assertEqual(self.swap.fixedDayCount(), self.tsDayCounter)
        self.assertEqual(self.swap.fixedPaymentBdc(), self.busDayConvention)
        self.assertEqual(self.swap.fixedPaymentLag(), self.payLag)
        self.assertEqual(self.swap.fixedPaymentCalendar(), self.calendar)
        self.assertEqual(self.swap.floatNominal(), self.nominal1)
        self.assertEqual(self.swap.floatCurrency(), self.currency1)
        self.assertEqual(self.swap.floatSpread(), self.floatSpread)
        self.assertEqual(self.swap.floatPaymentBdc(), self.busDayConvention)
        self.assertEqual(self.swap.floatPaymentLag(), self.payLag)
        self.assertEqual(self.swap.floatPaymentCalendar(), self.calendar)
        
    def testSchedules(self):
        """ Test CrossCurrencyFixFloatSwap schedules. """
        for i, d in enumerate(self.schedule):
            self.assertEqual(self.swap.fixedSchedule()[i], d)
            self.assertEqual(self.swap.floatSchedule()[i], d)
            
    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance = 1.0e-8
        fair_fixed_rate = self.swap.fairFixedRate()
        swap = CrossCcyFixFloatSwap(self.type, self.nominal2, self.currency2,
                                    self.schedule, fair_fixed_rate, self.tsDayCounter,
                                    self.busDayConvention, self.payLag, self.calendar,
                                    self.nominal1, self.currency1, self.schedule,
                                    self.index, self.floatSpread, self.busDayConvention,
                                    self.payLag, self.calendar)
        swap.setPricingEngine(self.engine)
        self.assertFalse(abs(swap.NPV()) > tolerance)
        fair_spread = self.swap.fairSpread()
        swap = CrossCcyFixFloatSwap(self.type, self.nominal2, self.currency2,
                                    self.schedule, self.couponRate, self.tsDayCounter,
                                    self.busDayConvention, self.payLag, self.calendar,
                                    self.nominal1, self.currency1, self.schedule,
                                    self.index, fair_spread, self.busDayConvention,
                                    self.payLag, self.calendar)
        swap.setPricingEngine(self.engine)
        self.assertFalse(abs(swap.NPV()) > tolerance)

        
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
        self.price_curve = LinearInterpolatedPriceCurve(self.dates, self.quotes, self.day_counter)
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
        self.maturityDate = Date(1, November, 2019)
        self.strike = 60
        self.equityForward = EquityForward(self.name, self.currency, self.position,
                                           self.quantity, self.maturityDate, self.strike)
        self.tsDayCounter = Actual365Fixed()
        self.interest_rate = 0.03
        self.flatForward = FlatForward(self.todays_date, self.interest_rate, self.tsDayCounter)
        self.equityInterestRateCurve = RelinkableYieldTermStructureHandle()
        self.equityInterestRateCurve.linkTo(self.flatForward)
        self.dividendYieldCurve = RelinkableYieldTermStructureHandle(self.flatForward)
        self.discountCurve = RelinkableYieldTermStructureHandle(self.flatForward)
        self.equitySpotPrice = 60.0
        self.equitySpot = QuoteHandle(SimpleQuote(self.equitySpotPrice))
        self.includeSettlementDateFlows = True
        self.engine = DiscountingEquityForwardEngine(self.equityInterestRateCurve, self.dividendYieldCurve,
                                                     self.equitySpot, self.discountCurve, self.includeSettlementDateFlows,
                                                     self.maturityDate, self.todays_date)
        self.equityForward.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test EquityForward simple inspectors. """
        self.assertEqual(self.strike, self.equityForward.strike())
        self.assertEqual(self.maturityDate, self.equityForward.maturityDate())
        self.assertEqual(self.quantity, self.equityForward.quantity())
        self.assertEqual(self.currency, self.equityForward.currency())

    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance= 1.0e-10
        self.assertFalse(abs(self.equityForward.NPV()) > tolerance)
        
        
class PaymentTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of fair price and NPV() """
        self.todays_date = Date(1, November, 2018)
        Settings.instance().evaluationDate=self.todays_date
        self.currency = GBPCurrency()
        self.settlementDate = Date(1, November, 2019)
        self.day_counter = Actual365Fixed()
        self.nominal = 100.0
        self.spotFX = QuoteHandle(SimpleQuote(1))
        self.rate = 0.0
        self.flat_forward = FlatForward(self.todays_date, self.rate, self.day_counter)
        self.discount_curve = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.payment = Payment(self.nominal, self.currency, self.settlementDate)
        self.includeSettlementDateFlows = True
        self.engine = PaymentDiscountingEngine(self.discount_curve, 
                                               self.spotFX, 
                                               self.includeSettlementDateFlows,
                                               self.settlementDate,
                                               self.todays_date)
        self.payment.setPricingEngine(self.engine)
        
    def testSimpleInspectors(self):
        """ Test Payment simple inspectors. """
        self.assertEqual(self.nominal, self.payment.cashFlow().amount())
        self.assertEqual(self.currency, self.payment.currency())

    def testConsistency(self):
        """ Test consistency of fair price and NPV() """
        tolerance= 1.0e-10
        self.assertFalse(abs(self.payment.NPV() - self.nominal) > tolerance)


if __name__ == '__main__':
    print('testing QuantExt ' + QuantExt.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(CrossCurrencyFixFloatSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(CommodityForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(SubPeriodsSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(TenorBasisSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(FxForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(DepositTest, 'test'))
    suite.addTest(unittest.makeSuite(EquityForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(PaymentTest, 'test'))
    suite.addTest(unittest.makeSuite(AverageOISTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)

