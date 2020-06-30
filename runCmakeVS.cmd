set VSVersion="Visual Studio 16 2019"
rem build with VS 2017
rem set VSVersion="Visual Studio 15 2017"
mkdir build
mkdir install
cmake -G %VSVersion% -A x64 -DSWIG_DIR=C:\dev\swigwin\Lib -DSWIG_EXECUTABLE=C:\dev\swigwin\swig.exe -DORE:PATHNAME=C:\dev\ORE\master -DBOOST_ROOT=C:\dev\boost -S . -B build
cmake --build build -v --config Release
rem copy all relevant python files to install
copy build\OREAnalytics-SWIG\Python\OREAnalytics.py install
copy build\OREData-SWIG\Python\OREData.py install
copy build\QuantExt-SWIG\Python\QuantExt.py install
copy build\QuantLib-SWIG\Python\QuantLib.py install
copy build\OREAnalytics-SWIG\Python\Release\*.* install
copy build\OREData-SWIG\Python\Release\*.* install
copy build\QuantExt-SWIG\Python\Release\*.* install
copy build\QuantLib-SWIG\Python\Release\*.* install

rem copy all relevant java files to install
copy build\OREAnalytics-SWIG\Java\OREAnalyticsJava.jar install
copy build\OREData-SWIG\Java\OREDataJava.jar install
copy build\QuantExt-SWIG\Java\QuantExtJava.jar install
copy build\QuantLib-SWIG\Java\QuantLibJava.jar install
copy build\OREAnalytics-SWIG\Java\Release\*.* install
copy build\OREData-SWIG\Java\Release\*.* install
copy build\QuantExt-SWIG\Java\Release\*.* install
copy build\QuantLib-SWIG\Java\Release\*.* install
pause
