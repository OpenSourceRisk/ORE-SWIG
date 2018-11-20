
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
        self.flat_forward = FlatForward(self.todays_date, 0.03, self.fixedDayCounter)
        self.termStructureOIS = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.averageOisRateHelper=AverageOISRateHelper(self.fixedRate,self.spotLagTenor,self.swapTenor,self.fixedTenor,self.fixedDayCounter,self.fixedCalendar,self.fixedConvention,self.fixedPaymentAdjustment,self.overnightIndex,self.onTenor,self.onSpread,self.rateCutoff,self.termStructureOIS)

        
    def testSimpleInspectors(self):
        """ Test Avegare OIS Rate helpers simple inspector. """
        self.assertEqual(self.fixedRate.value(),self.averageOisRateHelper.quote().value())

if __name__ == '__main__':
    unittest.main()

