mkdir builddir
cmake -G "Visual Studio 15 2017" -A x64 -DSWIG_DIR=C:\dev\swigwin\Lib -DSWIG_EXECUTABLE=C:\dev\swigwin\swig.exe -DORE:PATHNAME=C:\dev\ORE\master -DBOOST_ROOT=C:\dev\boost -S OREAnalytics-SWIG/Java -B builddir
cmake --build builddir -v
pause
