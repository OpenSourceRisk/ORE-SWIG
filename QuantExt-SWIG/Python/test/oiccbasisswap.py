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


class OiCCBasisSwapTest(unittest.TestCase):
    def setUp(self):
        print('Set Up of the Instrument Arguments')

        # Today:
        self.today_date = qle.Date(11, 9, 2018)

        # Notional:
        self.nominal1 = 10000000
        self.nominal2 = 12000000

        # Currencies:
        self.currency1 = qle.USDCurrency()
        self.currency2 = qle.EURCurrency()

        # Creation of a OIS Schedule:
        self.settlement_date = qle.Date(13, 9, 2018)
        self.maturityDate = qle.Date(13, 9, 2028)
        self.tenorLegOIS = qle.Period(1, qle.Years)
        self.calendar = qle.UnitedStates()
        self.busDayConvention = qle.Following
        self.generationDate = qle.DateGeneration.Forward
        self.endOfMonth = False
        self.scheduleOIS = qle.Schedule(self.settlement_date,
                                        self.maturityDate,
                                        self.tenorLegOIS,
                                        self.calendar,
                                        self.busDayConvention,
                                        self.busDayConvention,
                                        self.generationDate,
                                        self.endOfMonth)

        # OIS Index:
        self.termStructureOIS = qle.RelinkableYieldTermStructureHandle()
        self.indexOIS = qle.FedFunds(self.termStructureOIS)

        # OIS Term Structure:
        self.rateOIS = 0.01
        self.floatSpread = 0.001
        self.flatForwardOIS = qle.FlatForward(self.today_date, self.rateOIS, self.indexOIS.dayCounter())
        self.termStructureOIS.linkTo(self.flatForwardOIS)

        # FX Quote:
        self.fxQuote = qle.QuoteHandle(qle.SimpleQuote(1/0.8))

    def testInstrumentCreation(self):
        print('Creation the Instrument Object')
        self.instrument = qle.OvernightIndexedCrossCcyBasisSwap(self.nominal1,
                                                                self.currency1,
                                                                self.scheduleOIS,
                                                                self.indexOIS,
                                                                self.floatSpread,
                                                                self.nominal2,
                                                                self.currency2,
                                                                self.scheduleOIS,
                                                                self.indexOIS,
                                                                self.floatSpread)

        print("Creation of  Instrument Engine")
        self.engine = qle.OvernightIndexedCrossCcyBasisSwapEngine(self.termStructureOIS,
                                                                  self.currency1,
                                                                  self.termStructureOIS,
                                                                  self.currency2,
                                                                  self.fxQuote)

        print("Pricing of the Instrument with the Engine")
        self.instrument.setPricingEngine(self.engine)
        # self.instrument.NPV()


if __name__ == '__main__':
    print('Testing QuantExt ' + qle.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(OiCCBasisSwapTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)
