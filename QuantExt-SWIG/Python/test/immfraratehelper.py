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


class ImmFraRateHelperTest(unittest.TestCase):
    def setUp(self):
        print('Set Up of the Instrument Arguments')

        # Rates/Spreads
        self.rate = qle.QuoteHandle(qle.SimpleQuote(0.02))

        # Size
        self.size1 = 10
        self.size2 = 12

        self.index = qle.IborIndex('Mock Libor',
                                   qle.Period(3, qle.Months),
                                   1,
                                   qle.USDCurrency(),
                                   qle.NullCalendar(),
                                   qle.Unadjusted,
                                   False,
                                   qle.Thirty360())


    def testInstrumentCreation(self):
        print('Creation the Helper Object')
        self.bond_helper = qle.ImmFraRateHelper(self.rate,
                                                self.size1,
                                                self.size2,
                                                self.index)

if __name__ == '__main__':
    print('testing QuantExt ' + qle.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(ImmFraRateHelperTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)
