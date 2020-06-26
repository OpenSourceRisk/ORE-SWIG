mkdir build
rem build Python Swig interfaces VS 2019
cmake -G "Visual Studio 16 2019" -A x64 -DSWIG_DIR=C:\dev\swigwin\Lib -DSWIG_EXECUTABLE=C:\dev\swigwin\swig.exe -DORE:PATHNAME=C:\dev\ORE\master -DBOOST_ROOT=C:\dev\boost -S OREAnalytics-SWIG/Python -B build
rem build Java Swig interfaces VS 2019
rem cmake -G "Visual Studio 16 2019" -A x64 -DSWIG_DIR=C:\dev\swigwin\Lib -DSWIG_EXECUTABLE=C:\dev\swigwin\swig.exe -DORE:PATHNAME=C:\dev\ORE\master -DBOOST_ROOT=C:\dev\boost -S OREAnalytics-SWIG/Java -B build
rem build Java Swig interfaces VS 2017
rem cmake -G "Visual Studio 15 2017" -A x64 -DSWIG_DIR=C:\dev\swigwin\Lib -DSWIG_EXECUTABLE=C:\dev\swigwin\swig.exe -DORE:PATHNAME=C:\dev\ORE\master -DBOOST_ROOT=C:\dev\boost -S OREAnalytics-SWIG/Java -B build
rem build executables
cmake --build build -v --config Release
pause
