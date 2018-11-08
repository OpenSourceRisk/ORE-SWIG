
# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREAnalytics import *

print ("Loading parameters...")
params = Parameters()
params.fromFile("Input/ore.xml")
print ("setup/asofdate = " + params.get("setup","asofDate"))

print ("Building OREApp...")
ore = OREApp(params)

print ("Running ORE process...");
ore.run()

print("Done")
