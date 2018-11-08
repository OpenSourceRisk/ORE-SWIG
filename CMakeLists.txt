
cmake_minimum_required(VERSION 3.8)

# Generate a Python wrapper that covers QuantLib and QuantExt
#add_subdirectory(QuantExt-SWIG/Python) 

# Generate a Python wrapper that covers QuantLib, QuantExt and OREData
#add_subdirectory(OREData-SWIG/Python) 

# Generate a Python wrapper that covers QuantLib, QuantExt, OREData and OREAnalytics
add_subdirectory(OREAnalytics-SWIG/Python) 

# Generate a Java wrapper that covers QuantLib, QuantExt, OREData and OREAnalytics
#add_subdirectory(OREAnalytics-SWIG/Java) 
