
"""
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
"""

from OREData import *
import unittest

class LoaderTest(unittest.TestCase):

    def setUp(self):
        self.asofDate = Date(5, February, 2016)
        self.marketfile = "Input/market_20160205.txt"
        self.fixingfile = "Input/fixings_20160205.txt"
        marketdata = []
        fixingdata = []
        import csv
        with open(self.marketfile, 'r') as csvfile:
            csv_reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
            for row in csv_reader:
                if row is None or len(row) == 0 or row[0][0]== "#":
                    continue
                marketdata.append({
                    'Date': self.asofDate,
                    'Name': row[1],
                    'Value': float(row[-1])
                })
        with open(self.fixingfile, 'r') as csvfile:
            csv_reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
            for row in csv_reader:
                if row is None or len(row) == 0 or row[0][0]== "#":
                    continue
                fixingdata.append({
                    'Date': parseDate(row[0]),
                    'Name': row[1],
                    'Value': float(row[-1])
                })
        self.marketdata = marketdata
        self.fixingdata = fixingdata

    def testSimpleInspectors(self):
        """ Test Loader simple inspectors. """
        self.assertEqual(len(self.maketdata_loader), len(self.marketdata))
        self.assertEqual(len(self.fixingdata_loader), len(self.fixingdata))

        for i in range(len(self.maketdata_loader)):
            self.assertEqual(self.maketdata_loader[i].asofDate(), self.marketdata[i]['Date'])
            self.assertEqual(self.maketdata_loader[i].name(), self.marketdata[i]['Name'])
            self.assertAlmostEqual(self.maketdata_loader[i].quote().value(), self.marketdata[i]['Value'])

        for i in range(len(self.maketdata_loader)):
            self.assertTrue(self.loader.has(self.marketdata[i]['Name'], self.marketdata[i]['Date']))
            quote = self.loader.get(self.marketdata[i]['Name'], self.marketdata[i]['Date'])
            self.assertEqual(quote.asofDate(), self.marketdata[i]['Date'])
            self.assertEqual(quote.name(), self.marketdata[i]['Name'])
            self.assertAlmostEqual(quote.quote().value(), self.marketdata[i]['Value'])

        for i in range(len(self.maketdata_loader)):
            quote = self.loader.get(StringBoolPair(self.marketdata[i]['Name'], True), self.marketdata[i]['Date'])
            self.assertEqual(quote.asofDate(), self.marketdata[i]['Date'])
            self.assertEqual(quote.name(), self.marketdata[i]['Name'])
            self.assertAlmostEqual(quote.quote().value(), self.marketdata[i]['Value'])

        for i in range(len(self.maketdata_loader)):
            quote = self.loader.get(StringBoolPair(self.marketdata[i]['Name'], False), self.marketdata[i]['Date'])
            self.assertEqual(quote.asofDate(), self.marketdata[i]['Date'])
            self.assertEqual(quote.name(), self.marketdata[i]['Name'])
            self.assertAlmostEqual(quote.quote().value(), self.marketdata[i]['Value'])

        for i in range(len(self.fixingdata_loader)):
            self.assertEqual(self.fixingdata_loader[i].date, self.fixingdata[i]['Date'])
            self.assertEqual(self.fixingdata_loader[i].name, self.fixingdata[i]['Name'])
            self.assertAlmostEqual(self.fixingdata_loader[i].fixing, self.fixingdata[i]['Value'])


class CSVLoaderTest(LoaderTest):

    def setUp(self):
        """ Set-up CSV Loader """
        super(CSVLoaderTest, self).setUp()
        self.loader = CSVLoader(self.marketfile, self.fixingfile, True)
        self.maketdata_loader = self.loader.loadQuotes(self.asofDate)
        self.fixingdata_loader = self.loader.loadFixings()

    def testSimpleInspectors(self):
        """ Test CSV Loader simple inspectors. """
        super(CSVLoaderTest, self).testSimpleInspectors()

            
    def testConsistency(self):
        """ Test consistency of CSV Loader"""
        pass


class InMemoryLoaderTest(LoaderTest):

    def setUp(self):
        """ Set-up InMemory Loader """
        super(InMemoryLoaderTest, self).setUp()
        self.loader = InMemoryLoader()
        for data in self.marketdata:
            self.loader.add(data['Date'], data['Name'], data['Value'])
        for data in self.fixingdata:
            self.loader.addFixing(data['Date'], data['Name'], data['Value'])
        self.maketdata_loader = self.loader.loadQuotes(self.asofDate)
        self.fixingdata_loader = self.loader.loadFixings()

    def testSimpleInspectors(self):
        """ Test InMemory Loader simple inspectors. """
        super(InMemoryLoaderTest, self).testSimpleInspectors()
        
    def testConsistency(self):
        """ Test consistency of InMemory Loader"""
        pass


        
if __name__ == '__main__':
    print('testing OREData ' + OREData.__version__)
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(CSVLoaderTest,'test'))
    suite.addTest(unittest.makeSuite(InMemoryLoaderTest,'test'))
    unittest.TextTestRunner(verbosity=2).run(suite)
    unittest.main()

