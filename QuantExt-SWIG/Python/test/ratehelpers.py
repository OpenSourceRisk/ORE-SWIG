"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

from QuantExt import *
import unittest

class ImmFraRateHelperTest(unittest.TestCase):
    def setUp(self):
        """ Set-up ImmFraRateHelper """
        self.todays_date = Date(11, November, 2018)
        self.rate = QuoteHandle(SimpleQuote(0.02))
        self.day_counter = Actual365Fixed()
        self.size1 = 10
        self.size2 = 12
        self.flat_forward = FlatForward(self.todays_date, 0.005, self.day_counter)
        self.term_structure = RelinkableYieldTermStructureHandle(self.flat_forward)
        self.index = USDLibor(Period(3, Months), self.term_structure)
        self.helper = ImmFraRateHelper(self.rate,
                                       self.size1,
                                       self.size2,
                                       self.index)
        print(self.helper.impliedQuote())

if __name__ == '__main__':
    print('testing QuantExt ' + QuantExt.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(ImmFraRateHelperTest, 'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)