"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class SwapConventionsTest(unittest.TestCase):
    def setUp(self):
        """ Set-up SwapConventions"""
        self.todays_date = Date(1, October, 2018)
        self.settlement_days = 2
        self.tenor = Period(10, Years)
        self.calendar = TARGET()
        self.bdc = Following
        self.day_counter = Actual360()
        self.flat_forward = FlatForward(self.todays_date, 0.03, self.day_counter);
        self.discount_term_structure = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.index = Euribor3M(self.discount_term_structure)
        self.swap_convs = SwapConventions(self.settlement_days, self.tenor, self.calendar, self.bdc, 
                                          self.day_counter, self.index)
        
    def testSimpleInspectors(self):
        """ Test SwapConventions simple inspectors. """
        self.assertEqual(self.swap_convs.settlementDays(), self.settlement_days)
        self.assertEqual(self.swap_convs.fixedTenor(), self.tenor)
        self.assertEqual(self.swap_convs.fixedCalendar(), self.calendar)
        self.assertEqual(self.swap_convs.fixedConvention(), self.bdc)
        self.assertEqual(self.swap_convs.fixedDayCounter(), self.day_counter)
        self.assertEqual(self.swap_convs.floatIndex().name(), self.index.name())

class BlackVolatilityWithATMTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of Black Volatility with ATM"""
        self.todays_date=Date(1,October,2018)
        self.dc = Actual360()
        self.date1=Date(1,October,2018)
        self.date2=Date(10,October,2018)
        self.spot=QuoteHandle(SimpleQuote(0.05))
        self.flat_forward=FlatForward(self.todays_date, 0.03, self.dc)
        self.flat_forward2=FlatForward(self.todays_date, 0.04, self.dc)
        self.yield1=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.yield2=RelinkableYieldTermStructureHandle(self.flat_forward2)
        self.surface=BlackConstantVol(self.todays_date, UnitedStates(), 0.05, Actual360())
        self.blackvolatilitywithatm=BlackVolatilityWithATM(self.surface,self.spot,self.yield1,self.yield2)

        
    def testSimpleInspectors(self):
        """ Test Black Volatility with ATM simple inspector. """
        self.assertEqual(self.blackvolatilitywithatm.referenceDate(),self.date1)


class BlackVarianceSurfaceMoneynessSpotTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of Black Variance Surface Moneyness Spot"""
        self.cal=UnitedStates()
        self.spot=QuoteHandle(SimpleQuote(1.0))
        self.times=(1,2,3)
        self.moneyness=(1.0,1.1,1.2)
        self.blackVolMatrix =((QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.3))),(QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.3)),QuoteHandle(SimpleQuote(0.4))),(QuoteHandle(SimpleQuote(0.3)),QuoteHandle(SimpleQuote(0.4)),QuoteHandle(SimpleQuote(0.5))))
        self.dayCounter=Actual360()
        self.stickyStrike=False
        self.blackvariancesurfacemoneynessspot=BlackVarianceSurfaceMoneynessSpot(self.cal,self.spot,self.times,self.moneyness,self.blackVolMatrix,self.dayCounter,self.stickyStrike)

        
    def testSimpleInspectors(self):
        """ Test Black Variance Surface Moneyness Spot simple inspector. """
        self.assertEqual(self.blackvariancesurfacemoneynessspot.dayCounter(),self.dayCounter)


class BlackVarianceSurfaceMoneynessForwardTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of Black Variance Surface Moneyness Forward"""
        self.todays_date=Date(1,October,2018)
        self.dc=Actual360()
        self.flat_forward=FlatForward(self.todays_date, 0.03, self.dc)
        self.flat_forward2=FlatForward(self.todays_date, 0.04, self.dc)
        self.forTS=RelinkableYieldTermStructureHandle(self.flat_forward)
        self.domTS=RelinkableYieldTermStructureHandle(self.flat_forward2)
        self.cal=UnitedStates()
        self.spot=QuoteHandle(SimpleQuote(1.0))
        self.times=(1,2,3)
        self.moneyness=(1.0,1.1,1.2)
        self.blackVolMatrix =((QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.3))),(QuoteHandle(SimpleQuote(0.2)),QuoteHandle(SimpleQuote(0.3)),QuoteHandle(SimpleQuote(0.4))),(QuoteHandle(SimpleQuote(0.3)),QuoteHandle(SimpleQuote(0.4)),QuoteHandle(SimpleQuote(0.5))))
        self.dayCounter=Actual360()
        self.stickyStrike=False                
        self.blackvariancesurfacemoneynessforward=BlackVarianceSurfaceMoneynessForward(self.cal,self.spot,self.times,self.moneyness,self.blackVolMatrix,self.dc,self.forTS,self.domTS,self.stickyStrike)

        
    def testSimpleInspectors(self):
        """ Test Black Variance Surface Moneyness Forward simple inspector. """
        self.assertEqual(self.blackvariancesurfacemoneynessforward.dayCounter(),self.dayCounter)


class SwaptionVolCubeWithATMTest(unittest.TestCase):
    def setUp(self):
        """ Test consistency of Swaption Vol Cube With ATM"""
        self.today=Date(1,October,2018)
        self.termStructure = RelinkableYieldTermStructureHandle()
        self.dayCounter=Actual360()
        self.termStructure.linkTo(FlatForward(self.today,QuoteHandle(SimpleQuote(0.05)), self.dayCounter))
        self.atmVolStructure=SwaptionVolatilityStructureHandle(ConstantSwaptionVolatility(self.today, UnitedStates(),Following,0.2, self.dayCounter))
        self.optionTenors=(Period(3,Months),Period(6,Months))
        self.swapTenors=(Period(9,Months),Period(12,Months))
        self.strikeSpreads=(0.05,0.10)
        self.volSpreads=((QuoteHandle(SimpleQuote(0.10)),QuoteHandle(SimpleQuote(0.15))),(QuoteHandle(SimpleQuote(0.20)),QuoteHandle(SimpleQuote(0.25))),(QuoteHandle(SimpleQuote(0.25)),QuoteHandle(SimpleQuote(0.30))),(QuoteHandle(SimpleQuote(0.30)),QuoteHandle(SimpleQuote(0.35))))
        self.swapIndexBase=EuriborSwapIsdaFixA(Period(10,Years),self.termStructure)
        self.shortSwapIndexBase=EuriborSwapIsdaFixA(Period(2,Years),self.termStructure)
        self.vegaWeightedSmileFit=False
        self.swaptionVolatilityCube=SwaptionVolCube2(self.atmVolStructure,self.optionTenors,self.swapTenors,self.strikeSpreads,self.volSpreads,self.swapIndexBase,self.shortSwapIndexBase,self.vegaWeightedSmileFit)
        self.cube=SwaptionVolCubeWithATM(self.swaptionVolatilityCube)
        
    def testSimpleInspectors(self):
        """ Test Swaption Vol Cube With ATM simple inspector. """
        self.assertEqual(self.cube.dayCounter(),self.dayCounter)
        

if __name__ == '__main__':
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(BlackVolatilityWithATM,'test'))
    suite.addTest(unittest.makeSuite(BlackVarianceSurfaceMoneynessSpotTest,'test'))
    suite.addTest(unittest.makeSuite(BlackVarianceSurfaceMoneynessForwardTest,'test'))
    suite.addTest(unittest.makeSuite(SwapConventions,'test'))
    suite.addTest(unittest.makeSuite(SwaptionVolCubeWithATMTest,'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)
    unittest.main()
