
1. Introduction
================

This document provides a HOWTO for building and using a python wheel for OREAnalytics.
Instructions are also provided for intermediate projects (QuantLib, QuantLibExt, etc.).  If you are not interested in those sections of the document then you can skip them.

1.1 Other documentation

This document is fairly terse.  Refer to the resources below for more extensive information on the build and on the SWIG wrappers.

ore/userguide.pdf
oreswig/README
oreswig/README.md
oreswig/OREAnalytics-SWIG/README

1.2 Prerequisites

- boost and swig: You need to either install the binaries,
  or install the source code and build yourself

- ore and oreswig: You need to install the source code.
  Instructions for building with cmake are provided below.

1.3 Environmnet variables

For purposes of this HOWTO, set the following environment variables to the paths where the above items live on your machine, e.g:

DEMO_SWIG_DIR=C:\erik\ORE\repos\swigwin-4.1.1
DEMO_BOOST_DIR=/home/erik/quaternion/boost_1_81_0
DEMO_ORE_DIR=/home/erik/quaternion/ore
DEMO_ORE_SWIG_DIR=/home/erik/quaternion/oreswig

2. Build ORE
============

2.1 Use cmake to generate the project files

cd $DEMO_ORE_DIR
mkdir build
cd $DEMO_ORE_DIR/build
cmake -DBoost_NO_WARN_NEW_VERSIONS=1 -DBoost_NO_SYSTEM_PATHS=1 -DBOOST_ROOT=$DEMO_BOOST_DIR ..
-> $DEMO_ORE_DIR/build/Makefile
BOOST_BIND_GLOBAL_PLACEHOLDERS

2.1.1 EITHER Build using make

cd $DEMO_ORE_DIR/build
make
-> $DEMO_ORE_DIR\build\OREAnalytics\orea\Release\OREAnalytics-x64-mt.lib

2.1.2 OR Build using cmake

cd $DEMO_ORE_DIR\build
cmake --build .
-> $DEMO_ORE_DIR\build\OREAnalytics\orea\Release\OREAnalytics-x64-mt.lib

3. Build QuantLib
=================

WIP

4. Build QuantExt
=================

4.1 Use cmake to generate the project files

cd $DEMO_ORE_SWIG_DIR
mkdir buildQuantExt-SWIG
cd $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG
cmake -DORE:PATHNAME=$DEMO_ORE_DIR -DBOOST_ROOT=$DEMO_BOOST_DIR -S$DEMO_ORE_SWIG_DIR/QuantExt-SWIG/Python
-> $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG/Makefile

4.1.1 EITHER Build the pyd file using make

cd $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG
make
-> $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG/_QuantExt.so

4.1.2 OR Build the pyd file using cmake

cd $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG
cmake --build .
-> $DEMO_ORE_SWIG_DIR/buildQuantExt-SWIG/_QuantExt.so

4.2 Build and use the wrapper

4.2.1 Build the wrapper

cd $DEMO_ORE_SWIG_DIR/QuantExt-SWIG/Python
#export BOOST_ROOT=$DEMO_BOOST_DIR
#export BOOST_LIB=$DEMO_BOOST_DIR/stage/lib
#export ORE_DIR=$DEMO_ORE_DIR
export ORE=$DEMO_ORE_DIR
python3 setup.py wrap
python3 setup.py build -> FAILS **************************************
-> $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\build\lib.win-amd64-cpython-310\QuantExt
python setup.py test (FAILS)

4.2.1 Use the wrapper

set PYTHONPATH=$DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\build\lib.win-amd64-cpython-310
python $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\Examples\commodityforward.py

4.3.1 Build the wheel

cd $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python
set BOOST_ROOT=$DEMO_BOOST_DIR
set BOOST_LIB=$DEMO_BOOST_DIR\lib\x64\lib
set ORE_DIR=$DEMO_ORE_DIR
set PATH=$PATH;$DEMO_SWIG_DIR
set PATH=C:\Users\eric.ehlers\AppData\Local\Programs\Python\Python310\Scripts;$PATH
#pip install build
python -m build --wheel
-> $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\dist\QuantExt_Python-1.8.7-cp310-cp310-win_amd64.whl

4.3.2 Use the wheel

python -m venv env1
.\env1\Scripts\activate.bat
pip install $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\dist\QuantExt_Python-1.8.7-cp310-cp310-win_amd64.whl
python $DEMO_ORE_SWIG_DIR\QuantExt-SWIG\Python\Examples\commodityforward.py

5. Build OREData-SWIG
=====================

WIP

6. Build OREPlus-SWIG
=====================

WIP

7. BUild OREAnalytics
=====================

7.1 Use cmake to generate the project files

cd $DEMO_ORE_SWIG_DIR
mkdir buildOREAnalytics-SWIG
cd $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG
cmake -DBOOST_ROOT=$DEMO_BOOST_DIR -DORE=$DEMO_ORE_DIR -S$DEMO_ORE_SWIG_DIR/OREAnalytics-SWIG/Python -Wno-dev
-> $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG/Makefile

7.1.1 EITHER Build the pyd file using make

cd $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG
make -> FAILS *******************************************
c++: fatal error: Killed signal terminated program cc1plus
-> $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG/_OREAnalytics.so

7.1.2 OR Build the pyd file using cmake

cd $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG
cmake --build .
-> $DEMO_ORE_SWIG_DIR/buildOREAnalytics-SWIG/_OREAnalytics.so

7.2 Build and use the wrapper

7.2.1 Build the wrapper

cd $DEMO_ORE_SWIG_DIR/OREAnalytics-SWIG/Python
#export BOOST_ROOT=$DEMO_BOOST_DIR
#export BOOST_LIB=$DEMO_BOOST_DIR/stage/lib
export ORE=$DEMO_ORE_DIR
python3 setup.py wrap
python3 setup.py build

7.2.1 Use the wrapper

set PYTHONPATH=$DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python\build\lib.win-amd64-cpython-310
python $DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python\Examples\commodityforward.py

7.3.1 Build the wheel

cd $DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python
set BOOST_ROOT=$DEMO_BOOST_DIR
set BOOST_LIB=$DEMO_BOOST_DIR\lib\x64\lib
set ORE_DIR=$DEMO_ORE_DIR
set PATH=$PATH;$DEMO_SWIG_DIR
set PATH=C:\Users\eric.ehlers\AppData\Local\Programs\Python\Python310\Scripts;$PATH
python -m build --wheel
-> $DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python\dist\OREAnalytics_Python-1.8.3.2-cp310-cp310-win_amd64.whl

7.3.2 Use the wheel

python -m venv env1
.\env1\Scripts\activate.bat
pip install $DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python\dist\OREAnalytics_Python-1.8.3.2-cp310-cp310-win_amd64.whl
python $DEMO_ORE_SWIG_DIR\OREAnalytics-SWIG\Python\Examples\commodityforward.py

TODO
====

- $DEMO_ORE_DIR\oreEverything.sln
  * QuantExtTestSuite not found

- "python setup.py test" fails

- many example py scripts do not work

