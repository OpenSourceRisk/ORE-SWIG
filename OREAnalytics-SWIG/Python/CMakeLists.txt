cmake_minimum_required(VERSION 3.15)

cmake_policy(SET CMP0091 NEW)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

project(OREAnalytics-Python)

option(ORE_USE_ZLIB "Use compression for boost::iostreams" OFF)

if(NOT DEFINED ${ORE_BUILD})
    SET(ORE_BUILD ${ORE}/build)
endif()

include(${ORE}/cmake/commonSettings.cmake)

# Append /bigobj to compiler flags on Windows for this target
if (MSVC)
   # FIXME: Add the other compiler flags from QuantLib-SWIG/Python/setup.py (/GR /FD /Zm250 /EHsc)?
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /bigobj")
   message(STATUS CMAKE_CXX_FLAGS "=" "${CMAKE_CXX_FLAGS}")

   foreach (cfg "DEBUG" "RELEASE" "MINSIZEREL" "RELWITHDEBINFO")
      foreach (flag "CXX" "C")
         set(CMAKE_${flag}_FLAGS_${cfg} "${CMAKE_${flag}_FLAGS_${cfg}} /bigobj")
         message(STATUS CMAKE_${flag}_FLAGS_${cfg} "=" "${CMAKE_${flag}_FLAGS_${cfg}}")
      endforeach ()
   endforeach ()
endif()

# The module depends on a number of libraries in the ORE project: determine their exact names
get_library_name("OREAnalytics" OREA_LIB_NAME)
get_library_name("OREData" ORED_LIB_NAME)
get_library_name("QuantExt" QLE_LIB_NAME)
set_ql_library_name()

# To build the module, we moreover need Boost, Swig, Python
set(BOOST_COMPONENT_LIST serialization date_time regex filesystem system timer thread log)
if(ORE_USE_ZLIB)
    list(APPEND BOOST_COMPONENT_LIST iostreams)
    if(MSVC)
        list(APPEND BOOST_COMPONENT_LIST zlib)
    endif()
endif()
find_package(Boost REQUIRED COMPONENTS ${BOOST_COMPONENT_LIST})
find_package(SWIG REQUIRED)
find_package(Python REQUIRED COMPONENTS Development)
if(ORE_USE_ZLIB)
    find_package(ZLIB REQUIRED)
endif()

# Load the UseSWIG module from the cmake installation
include(${SWIG_USE_FILE})

# Add to the list of include directories
include_directories(${PROJECT_SOURCE_DIR}/../SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantLib-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantExt-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../OREData-SWIG/SWIG)
include_directories(${ORE_BUILD}/QuantLib)
include_directories(${ORE}/QuantLib)
include_directories(${ORE}/QuantExt)
include_directories(${ORE}/OREData)
include_directories(${ORE}/OREAnalytics)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${Python_INCLUDE_DIRS})

# Add to the list of link directories
link_directories(${Python_LIBRARY_DIRS})
add_link_directory_if_exists(${ORE_BUILD}/QuantLib/ql)
add_link_directory_if_exists(${ORE_BUILD}/QuantExt/qle)
add_link_directory_if_exists(${ORE_BUILD}/OREData/ored)
add_link_directory_if_exists(${ORE_BUILD}/OREAnalytics/orea)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreanalytics.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreanalytics.i PROPERTIES SWIG_FLAGS "-includeall")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreanalytics.i PROPERTIES SWIG_FLAGS "-py3")

# Tell SWIG to build a Python module, to be called "ORE"
# NB: Variable CMAKE_DEBUG_POSTFIX holds the suffix of the lib name on disk.
# Function swig_add_library() (defined in module UseSWIG.cmake) misappropriates this variable in two ways:
# 1) It uses the variable as part of the name of a function in the autogenerated C source code.
#    We sometimes put a hyphen in the variable (e.g. "-gd") which causes the build to fail.
# 2) UseSwig uses the variable as part of the package name and a hyphen results in the
#    package not getting loaded at runtime.
# So unset the variable before calling swig_add_library().
# Then restore the variable after because it is required by the calls to target_link_libraries() below.
set(TEMP_CMAKE_DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
unset(CMAKE_DEBUG_POSTFIX)
swig_add_library(ORE TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/oreanalytics.i)

set(CMAKE_DEBUG_POSTFIX ${TEMP_CMAKE_DEBUG_POSTFIX})

# Add all libraries to link with
target_link_libraries(ORE ${Boost_LIBRARIES})
target_link_libraries(ORE ${QL_LIB_NAME})
target_link_libraries(ORE ${QLE_LIB_NAME})
target_link_libraries(ORE ${ORED_LIB_NAME})
target_link_libraries(ORE ${OREA_LIB_NAME})
if(ORE_USE_ZLIB)
    target_link_libraries(ORE ${ZLIB_LIBRARIES})
endif()
# On windows, do not tell the build which python libs to use.  It automatically
# looks for python release libs, even in debug, and invoking the line below
# breaks the debug build.
if(NOT MSVC)
    target_link_libraries(ORE ${Python_LIBRARIES})
endif()

if (MSVC)
	get_target_property(target_options ORE COMPILE_OPTIONS)
	list(REMOVE_ITEM target_options "/we4189")
	set_property(TARGET ORE PROPERTY COMPILE_OPTIONS ${target_options})
endif()