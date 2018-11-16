# coding=utf-8-unix
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.

 This file is part of ORE, a free-software/open-source library
 for transparent pricing and risk analysis - http://opensourcerisk.org

 ORE is free software: you can redistribute it and/or modify it
 under the terms of the Modified BSD License.  You should have received a
 copy of the license along with this program.
 The license is also available online at <http://opensourcerisk.org>

 This program is distributed on the basis that it will form a useful
 contribution to risk analytics and model standardisation, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the license for more details.

"""

import QuantExt as qle
import unittest


class CrossCurrencySwapHelperTest(unittest.TestCase):
    def setUp(self):
        print('Set Up of the Instrument Arguments')

        # Dates:
        self.todayDate = qle.Date(11, 9, 2018)
        self.maturityDate = qle.Date(2, 1, 2028)
        self.settlementDate = qle.Date(13, 9, 2018)

        # Rates/Spreads
        self.rate = qle.QuoteHandle(qle.SimpleQuote(0.02))
        self.spotFx = qle.QuoteHandle(qle.SimpleQuote(1.2))

        # Fixed Currency :
        self.currency = qle.EURCurrency()

        # Schedule
        self.tenor = qle.Period(1, qle.Years)
        self.frequency = qle.Semiannual
        self.calendar = qle.UnitedStates(qle.UnitedStates.GovernmentBond)
        self.busDayConvention = qle.Following
        self.dayCounter = qle.ActualActual(qle.ActualActual.Bond)
        self.settlementDays = 3
        self.sched = qle.Schedule(self.settlementDate,
                                  self.maturityDate,
                                  qle.Period(qle.Semiannual),
                                  self.calendar,
                                  qle.Unadjusted,
                                  qle.Unadjusted,
                                  qle.DateGeneration.Backward, False)

        # Floating Leg Index (from discounted term structure)
        self.flatForwardUSD = qle.FlatForward(self.todayDate, 0.005, self.dayCounter)
        self.discountTermStructureUSD = qle.RelinkableYieldTermStructureHandle()
        self.discountTermStructureUSD.linkTo(self.flatForwardUSD)
        self.indexUSD = qle.USDLibor(qle.Period(6, qle.Months), self.discountTermStructureUSD)

    def testInstrumentCreation(self):
        print('Creation the Helper Object')
        self.bond_helper = qle.CrossCcyFixFloatSwapHelper(self.rate,
                                                          self.spotFx,
                                                          self.settlementDays,
                                                          self.calendar,
                                                          self.busDayConvention,
                                                          self.tenor,
                                                          self.currency,
                                                          self.frequency,
                                                          self.busDayConvention,
                                                          self.dayCounter,
                                                          self.indexUSD,
                                                          self.discountTermStructureUSD)


if __name__ == '__main__':
    print('testing QuantExt ' + qle.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(CrossCurrencySwapHelperTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)
