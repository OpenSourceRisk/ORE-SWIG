"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""
import sys
import unittest

from instruments import FxForwardTest
from instruments import DepositTest
from instruments import TenorBasisSwapTest
from instruments import SubPeriodsSwapTest


def test():
    import QuantExt
    print('testing QuantExt ' + QuantExt.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """
    suite.addTest(unittest.makeSuite(FxForwardTest, 'test'))
    suite.addTest(unittest.makeSuite(DepositTest, 'test'))
    suite.addTest(unittest.makeSuite(TenorBasisSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(SubPeriodsSwapTest, 'test'))

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)

        
if __name__ == '__main__':
    test()
