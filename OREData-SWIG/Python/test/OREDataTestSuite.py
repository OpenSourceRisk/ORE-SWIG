"""
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
"""
import sys
import unittest

from loader import CSVLoaderTest
from loader import InMemoryLoaderTest
from marketdatum import CorrelationRateQuoteTest
from marketdatum import CorrelationPriceQuoteTest
from marketdatum import CorrelationQuoteThrowTest

def test():
    import OREData
    print('testing OREData ' + OREData.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """
    suite.addTest(unittest.makeSuite(CSVLoaderTest, 'test'))
    suite.addTest(unittest.makeSuite(InMemoryLoaderTest, 'test'))
    suite.addTest(unittest.makeSuite(CorrelationRateQuoteTest,'test'))
    suite.addTest(unittest.makeSuite(CorrelationPriceQuoteTest,'test'))
    suite.addTest(unittest.makeSuite(CorrelationQuoteThrowTest,'test'))

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)


if __name__ == '__main__':
    test()
