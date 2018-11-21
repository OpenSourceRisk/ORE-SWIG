
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class AverageOISRateHelpersTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of Average OIS Rate Helpers"""
        self.todays_date=Date(1,October,2018)
        Settings.instance().setEvaluationDate(self.todays_date)
        self.fixedRate = QuoteHandle(SimpleQuote(0.05))
        self.spotLagTenor = Period(1,Days)
        self.swapTenor = Period(10,Years)
        self.fixedTenor = Period(3,Months)
        self.fixedDayCounter=Actual360()
        self.fixedCalendar=UnitedStates()
        self.fixedConvention=Following
        self.fixedPaymentAdjustment=Following
        self.overnightIndex=Eonia()
        self.onTenor=Period(3,Months)
        self.onSpread=QuoteHandle(SimpleQuote(0.04))
        self.rateCutoff=1
        self.flat_forward=FlatForward(self.todays_date, 0.03, self.fixedDayCounter)
        self.termStructureOIS=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.averageOisRateHelper=AverageOISRateHelper(self.fixedRate,self.spotLagTenor,self.swapTenor,self.fixedTenor,self.fixedDayCounter,self.fixedCalendar,self.fixedConvention,self.fixedPaymentAdjustment,self.overnightIndex,self.onTenor,self.onSpread,self.rateCutoff,self.termStructureOIS)

        
    def testSimpleInspectors(self):
        """ Test Avegare OIS Rate helpers simple inspector. """
        self.assertEqual(self.fixedRate.value(),self.averageOisRateHelper.quote().value())


class CrossCcyBasisSwapHelperTest(unittest.TestCase):     
    def setUp(self):
        """ Test consistency of Cross Curency Basis Swap Helper"""
        self.todays_date=Date(1,October,2018)
        Settings.instance().setEvaluationDate(self.todays_date)   
        self.fixedDayCounter=Actual360()
        self.spreadQuote=QuoteHandle(SimpleQuote(0.05))
        self.spotFX=QuoteHandle(SimpleQuote(1.0))
        self.settlementDays=2
        self.settlementCalendar=UnitedStates()
        self.swapTenor=Period(3,Months)
        self.rollConvention=Following 
        self.forecast_curve = RelinkableYieldTermStructureHandle()
        self.forecast_curve.linkTo(FlatForward(self.todays_date, 0.03, self.fixedDayCounter,Compounded, Semiannual))
        self.forecast_curve2 = RelinkableYieldTermStructureHandle()
        self.flatIbor = Euribor6M(self.forecast_curve)
        self.spreadIbor = Euribor6M(self.forecast_curve2)
        self.flat_forward=FlatForward(self.todays_date, 0.03, self.fixedDayCounter)
        self.flatDiscountCurve=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.spreadDiscountCurve=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.eom=False
        self.flatIsDomestic=True
        self.ratehelper = CrossCcyBasisSwapHelper(self.spreadQuote, self.spotFX, self.settlementDays, self.settlementCalendar, self.swapTenor, self.rollConvention, self.flatIbor, self.spreadIbor, self.flatDiscountCurve, self.spreadDiscountCurve, self.eom, self.flatIsDomestic)

    def testSimpleInspectors(self):
        """ Test Cross Curency Basis Swap Helper simple inspector. """
        self.assertEqual(self.ratehelper.quote().value(),self.spreadQuote.value())
        

        
class TenorBasisSwapHelperTest(unittest.TestCase):     
    def setUp(self):
        """ Test consistency of Cross Curency Basis Swap Helper"""
        self.todays_date=Date(1,October,2018)
        Settings.instance().setEvaluationDate(self.todays_date)   
        self.spread=QuoteHandle(SimpleQuote(0.02))
        self.swapTenor=Period(3,Months)
        self.forecast_curve = RelinkableYieldTermStructureHandle()
        self.longIbor = Euribor6M(self.forecast_curve)
        self.forecast_curve2 = RelinkableYieldTermStructureHandle()
        self.forecast_curve2.linkTo(FlatForward(self.todays_date, 0.04, Actual360(),Compounded, Semiannual))
        self.shortIbor = Euribor6M(self.forecast_curve2)
        self.shortPayTenor=Period(6,Months)
        self.fixedDayCounter=Actual360()
        self.flat_forward=FlatForward(self.todays_date, 0.03, self.fixedDayCounter)
        self.discountingCurve=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.spreadOnShort = True
        self.includeSpread = False
        self.type = SubPeriodsCoupon.Compounding
        self.tenorbasisswaphelper=TenorBasisSwapHelper(self.spread,self.swapTenor,self.longIbor,self.shortIbor,self.shortPayTenor,self.discountingCurve,self.spreadOnShort,self.includeSpread,self.type)
        

    def testSimpleInspectors(self):
        """ Test Cross Curency Basis Swap Helper simple inspector. """
        self.assertEqual(self.spread.value(),self.tenorbasisswaphelper.quote().value())

        
        
if __name__ == '__main__':
    unittest.main()

