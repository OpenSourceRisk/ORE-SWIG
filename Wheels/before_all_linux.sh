#!/bin/bash

set -e

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "pwd"
pwd
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

CURRENT_DIR=$(pwd)

#echo "XYZ BEGIN unpack eigen"
#curl -O -L https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz
#tar zxvf eigen-3.4.0.tar.gz
#cd eigen-3.4.0
#mkdir build
#cd build
#cmake ..
#cd ../..
#echo "XYZ END unpack eigen"

#echo "XYZ BEGIN unpack zlib"
#curl -O -L https://www.zlib.net/zlib-1.3.1.tar.gz
#tar xzvf zlib-1.3.1.tar.gz
#cd zlib-1.3.1
#./configure
#make
#cd ..
#echo "XYZ END unpack zlib"

echo "XYZ BEGIN unpack boost"
# Setup Boost
curl -O -L https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz
tar xfz boost_1_80_0.tar.gz
cd boost_1_80_0
export Eigen3_DIR=$CURRENT_DIR/eigen-3.4.0
./bootstrap.sh --with-libraries=date_time,filesystem,iostreams,log,regex,serialization,system,thread,timer
./b2 install -sZLIB_SOURCE=$CURRENT_DIR/zlib-1.3.1
cd ..
echo "XYZ END unpack boost"