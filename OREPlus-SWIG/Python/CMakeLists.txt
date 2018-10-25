cmake_minimum_required(VERSION 3.8)

project(OREPlus-Python)

include(${ORE}/cmake/commonSettings.cmake)

# The module depends on a number of libraries in the ORE project: determine their exact names
get_library_name("OREPlusApp" OREPAPP_LIB_NAME)
get_library_name("OREAnalytics" OREA_LIB_NAME)
get_library_name("OREData" ORED_LIB_NAME)
get_library_name("QuantExt" QLE_LIB_NAME)
get_library_name("QuantLib" QL_LIB_NAME)

# To build the module, we moreover need Boost, Swig, Python
find_package(Boost COMPONENTS serialization date_time regex filesystem system REQUIRED)
find_package(SWIG REQUIRED)
find_package(PythonLibs)

# What does this mean?
include(${SWIG_USE_FILE})

# Add to the list of include directories
include_directories(${PROJECT_SOURCE_DIR}/../SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantLib-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantExt-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../OREData-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../OREAnalytics-SWIG/SWIG)
include_directories(${ORE}/QuantLib)
include_directories(${ORE}/QuantExt)
include_directories(${ORE}/OREData)
include_directories(${ORE}/OREAnalytics)
include_directories(${ORE}/OREPlus/App)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_PATH})

# Add to the list of link directories
link_directories(${ORE}/build/QuantLib/ql)
link_directories(${ORE}/build/QuantExt/qle)
link_directories(${ORE}/build/OREData/ored)
link_directories(${ORE}/build/OREAnalytics/orea)
link_directories(${ORE}/build/OREPlus/App/orepapp)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i PROPERTIES CPLUSPLUS ON)

# Tell SWIG to build a Python module, to be called "OREPlus"
swig_add_library(OREPlus TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i)

# Add all libraries to link with
swig_link_libraries(OREPlus ${PYTHON_LIBRARIES})
swig_link_libraries(OREPlus ${Boost_LIBRARIES})
swig_link_libraries(OREPlus ${QL_LIB_NAME})
swig_link_libraries(OREPlus ${QLE_LIB_NAME})
swig_link_libraries(OREPlus ${ORED_LIB_NAME})
swig_link_libraries(OREPlus ${OREA_LIB_NAME})
swig_link_libraries(OREPlus ${OREPAPP_LIB_NAME})

#if (APPLE) 
#
   # Use rpath for the module library _OREPlus
#  set_target_properties(_OREPlus PROPERTIES MACOSX_RPATH TRUE)
#
   # append directories in the linker search path and outside the project to the INSTALL_RPATH
#  set_target_properties(_OREPlus PROPERTIES CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
#
   # this is where libtriv_stats.dylib is installed relative to where _simple_module.so is installed
#  set_target_properties(_OREPlus PROPERTIES INSTALL_RPATH "@loader_path/../../..")
#
#else()
#
#  #set_target_properties(_OREPlus PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
#  set_target_properties(_OREPlus PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
#
#endif()

# Installation involves copying _OREPlus.so and OREPlus.py, and adding __init__.py.
# The below simply copies the files to the PYTHONPATH, but does not
# integrate the additional module with the exisiting ones.  
# To run thr code it suffices to add the directory that contains _OREPlus.so and OREPlus.py to the PYTHONPATH.
#install(TARGETS _OREPlus DESTINATION "${PYTHON_INSTALL_PATH}")
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/OREPlus.py ${PROJECT_SOURCE_DIR}/OREPlus/__init__.py DESTINATION "${PYTHON_INSTALL_PATH}")
