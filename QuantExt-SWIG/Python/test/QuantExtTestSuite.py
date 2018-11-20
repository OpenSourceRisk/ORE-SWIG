"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""
import sys
import unittest

from instruments import FxForwardTest
from instruments import DepositTest
from instruments import EquityForwardTest
from instruments import TenorBasisSwapTest
from instruments import SubPeriodsSwapTest
from instruments import CommodityForwardTest
from instruments import PaymentTest
from instruments import CrossCurrencyFixFloatSwapTest
from instruments import AverageOISTest
from ratehelpers import ImmFraRateHelperTest
from ratehelpers import AverageOISRateHelpersTest
from ratehelpers import CrossCcyBasisSwapHelperTest

def test():
    import QuantExt
    print('testing QuantExt ' + QuantExt.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """
    suite.addTest(unittest.makeSuite(FxForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(DepositTest, 'test'))
    suite.addTest(unittest.makeSuite(EquityForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(TenorBasisSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(SubPeriodsSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(CommodityForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(PaymentTest, 'test'))
    suite.addTest(unittest.makeSuite(CrossCurrencyFixFloatSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(AverageOISTest, 'test'))
    suite.addTest(unittest.makeSuite(ImmFraRateHelperTest, 'test'))
    suite.addTest(unittest.makeSuite(AverageOISRateHelpersTest, 'test'))
    suite.addTest(unittest.makeSuite(CrossCcyBasisSwapHelperTest, 'test'))

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)

        
if __name__ == '__main__':
    test()
