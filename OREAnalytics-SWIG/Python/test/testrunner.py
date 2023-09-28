import os
import sys
import ORE
import nose

sys.modules["QuantLib"] = ORE

if __name__=="__main__":
    folder = sys.argv[1]
    argv = [__file__, "-w ", folder, '--with-xunit']
    nose.run(argv=argv)