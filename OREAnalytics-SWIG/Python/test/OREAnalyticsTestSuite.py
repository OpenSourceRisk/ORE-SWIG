"""
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
"""
import sys
import unittest

def test():
    import OREAnalytics
    print('testing OREAnalytics ' + OREAnalytics.__version__)

    suite = unittest.TestSuite()

    """ Add test suites below """

    result = unittest.TextTestRunner(verbosity=2).run(suite)

    if not result.wasSuccessful:
        sys.exit(1)


if __name__ == '__main__':
    test()
