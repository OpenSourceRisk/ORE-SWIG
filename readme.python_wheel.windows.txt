
1. Introduction
================

This document provides a HOWTO for building and using a python wheel for OREAnalytics.
Instructions are also provided for intermediate projects (QuantLib, QuantLibExt, etc.).  If you are not interested in those sections of the document then you can skip them.

1.1 Other documentation

This document is fairly terse.  Refer to the resources below for more extensive information on the build and on the SWIG wrappers.

ore\userguide.pdf
ore-swig\README
ore-swig\README.md
ore-swig\OREAnalytics-SWIG\README

1.2 Prerequisites

- boost and swig: You need to either install the binaries,
  or install the source code and build yourself

- ore and oreswig: You need to install the source code.
  Instructions for building with cmake are provided below.

1.3 Environmnet variables

For purposes of this HOWTO, set the following environment variables to the paths where the above items live on your machine, e.g:

SET DEMO_SWIG_DIR=C:\erik\ORE\repos\swigwin-4.1.1
SET DEMO_BOOST_DIR=C:\erik\ORE\repos\boost_1_72_0
SET DEMO_ORE_DIR=C:\erik\ORE\repos\oreplus\ore
SET DEMO_ORE_SWIG_DIR=C:\erik\ORE\repos\oreswig.gitlab

2. Build ORE
============

2.1 Use cmake to generate the project files

cd %DEMO_ORE_DIR%\build
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" -A x64 ..
-> %DEMO_ORE_DIR%\build\ORE.sln

2.1.1 EITHER Build using Visual Studio

%DEMO_ORE_DIR%\build\ORE.sln
-> %DEMO_ORE_DIR%\build\OREAnalytics\orea\Release\OREAnalytics-x64-mt.lib

2.1.2 OR Build using cmake

cd %DEMO_ORE_DIR%\build
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release
-> %DEMO_ORE_DIR%\build\OREAnalytics\orea\Release\OREAnalytics-x64-mt.lib

3. Build QuantLib
=================

WIP

4. Build QuantExt
=================

4.1 Use cmake to generate the project files

cd %DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" ^
-A x64 ^
-D SWIG_DIR=%DEMO_SWIG_DIR%\Lib ^
-D SWIG_EXECUTABLE=%DEMO_SWIG_DIR%\swig.exe ^
-D ORE:PATHNAME=%DEMO_ORE_DIR% ^
-D BOOST_ROOT=%DEMO_BOOST_DIR% ^
-S %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python
-> %DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG\QuantExt-Python.sln

4.1.1 EITHER Build the pyd file using Visual Studio

%DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG\QuantExt-Python.sln
-> %DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG\Release\_QuantExt.pyd

4.1.2 OR Build the pyd file using cmake

cd %DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release
-> %DEMO_ORE_SWIG_DIR%\buildQuantExt-SWIG\Release\_QuantExt.pyd

4.2 Build and use the wrapper

4.2.1 Build the wrapper

"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
cd %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python
set BOOST_ROOT=%DEMO_BOOST_DIR%
set BOOST_LIB=%DEMO_BOOST_DIR%\lib\x64\lib
set ORE_DIR=%DEMO_ORE_DIR%
set PATH=%PATH%;%DEMO_SWIG_DIR%
python setup.py wrap
python setup.py build
-> %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\build\lib.win-amd64-cpython-310\QuantExt
python setup.py test (FAILS)

4.2.1 Use the wrapper

set PYTHONPATH=%DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\build\lib.win-amd64-cpython-310
python %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\Examples\commodityforward.py

4.3.1 Build the wheel

cd %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python
set BOOST_ROOT=%DEMO_BOOST_DIR%
set BOOST_LIB=%DEMO_BOOST_DIR%\lib\x64\lib
set ORE_DIR=%DEMO_ORE_DIR%
set PATH=%PATH%;%DEMO_SWIG_DIR%
set PATH=C:\Users\eric.ehlers\AppData\Local\Programs\Python\Python310\Scripts;%PATH%
#pip install build
python -m build --wheel
-> %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\dist\QuantExt_Python-1.8.7-cp310-cp310-win_amd64.whl

4.3.2 Use the wheel

python -m venv env1
.\env1\Scripts\activate.bat
pip install %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\dist\QuantExt_Python-1.8.7-cp310-cp310-win_amd64.whl
python %DEMO_ORE_SWIG_DIR%\QuantExt-SWIG\Python\Examples\commodityforward.py

5. Build OREData-SWIG
=====================

WIP

6. Build OREPlus-SWIG
=====================

WIP

7. BUild OREAnalytics
=====================

7.1 Use cmake to generate the project files

cd %DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 17 2022" ^
-A x64 ^
-D SWIG_DIR=%DEMO_SWIG_DIR%\Lib ^
-D SWIG_EXECUTABLE=%DEMO_SWIG_DIR%\swig.exe ^
-D ORE:PATHNAME=%DEMO_ORE_DIR% ^
-D BOOST_ROOT=%DEMO_BOOST_DIR% ^
-S %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python
-> %DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG\OREAnalytics-Python.sln

7.1.1 EITHER Build the pyd file using Visual Studio

%DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG\OREAnalytics-Python.sln
-> %DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG\Release\_OREAnalytics.pyd

7.1.2 OR Build the pyd file using cmake

cd %DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release
-> %DEMO_ORE_SWIG_DIR%\buildOREAnalytics-SWIG\Release\_OREAnalytics.pyd

7.2 Build and use the wrapper

7.2.1 Build the wrapper

"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
cd %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python
set BOOST_ROOT=%DEMO_BOOST_DIR%
set BOOST_LIB=%DEMO_BOOST_DIR%\lib\x64\lib
set ORE_DIR=%DEMO_ORE_DIR%
set PATH=%PATH%;%DEMO_SWIG_DIR%
python setup.py wrap
python setup.py build

7.2.1 Use the wrapper

set PYTHONPATH=%DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python\build\lib.win-amd64-cpython-310
python %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python\Examples\commodityforward.py

7.3.1 Build the wheel

cd %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python
set BOOST_ROOT=%DEMO_BOOST_DIR%
set BOOST_LIB=%DEMO_BOOST_DIR%\lib\x64\lib
set ORE_DIR=%DEMO_ORE_DIR%
set PATH=%PATH%;%DEMO_SWIG_DIR%
set PATH=C:\Users\eric.ehlers\AppData\Local\Programs\Python\Python310\Scripts;%PATH%
python -m build --wheel
-> %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python\dist\OREAnalytics_Python-1.8.3.2-cp310-cp310-win_amd64.whl

7.3.2 Use the wheel

python -m venv env1
.\env1\Scripts\activate.bat
pip install %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python\dist\OREAnalytics_Python-1.8.3.2-cp310-cp310-win_amd64.whl
python %DEMO_ORE_SWIG_DIR%\OREAnalytics-SWIG\Python\Examples\commodityforward.py

TODO
====

- %DEMO_ORE_DIR%\oreEverything.sln
  * QuantExtTestSuite not found

- "python setup.py test" fails

- many example py scripts do not work

