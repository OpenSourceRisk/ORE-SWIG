cmake \
-D PYTHON_LIBRARY=/opt/anaconda3/lib/libpython3.8.dylib \
-D PYTHON_INCLUDE_DIR=/opt/anaconda3/include/python3.8 \
-D BOOST_ROOT=$BOOST \
-D BOOST_INCLUDEDIR=$BOOST \
-D BOOST_LIBRARYDIR=$BOOST/stage/lib \
-D ORE=$ORE -G Ninja ..
