
# Copyright (C) 2019 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREAnalytics import *

fileLogger = FileLogger("log.txt")

mask = 7
Log.instance().registerLogger(fileLogger)

Log.instance().setMask(mask)
assert mask == Log.instance().mask()

Log.instance().switchOn()

ALOG("Alert Message")
CLOG("Critical Message")
ELOG("Error Message")
WLOG("Warning Message")
LOG("Notice Message")
DLOG("Debug Message")
TLOG("Data Message")
