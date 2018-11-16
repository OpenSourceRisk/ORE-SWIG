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


def test():
    import QuantExt
    print('testing QuantExt ' + QuantExt.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """
    suite.addTest(unittest.makeSuite(FxForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(DepositTest, 'test'))
    suite.addTest(unittest.makeSuite(EquityForwardTest, 'test'))D
    suite.addTest(unittest.makeSuite(TenorBasisSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(SubPeriodsSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(CommodityForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(PaymentTest, 'test'))r

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)

        
if __name__ == '__main__':
    test()
