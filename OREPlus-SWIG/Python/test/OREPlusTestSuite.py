
"""
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
"""
import sys
import unittest

from creditdefaultswap import IndexCreditDefaultSwapTest
from creditdefaultswap import IndexCDSOptionTest
from creditdefaultswap import IndexCreditDefaultSwapTestVectorOfCurves
from creditdefaultswap import IndexCDSOptionTestVectorOfCurves

def test():
    import OREPlus
    print('testing OREPlus ' + OREPlus.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """
    suite.addTest(unittest.makeSuite(IndexCreditDefaultSwapTest, 'test'))
    suite.addTest(unittest.makeSuite(IndexCDSOptionTest, 'test'))
    suite.addTest(unittest.makeSuite(IndexCreditDefaultSwapTestVectorOfCurves, 'test'))
    suite.addTest(unittest.makeSuite(IndexCDSOptionTestVectorOfCurves, 'test'))

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)


if __name__ == '__main__':
    test()
