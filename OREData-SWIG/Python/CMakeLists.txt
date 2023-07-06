cmake_minimum_required(VERSION 3.8)

project(OREData-Python)

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
         set (CMAKE_${flag}_FLAGS_${cfg} "${CMAKE_${flag}_FLAGS_${cfg}} /bigobj") 
         message(STATUS CMAKE_${flag}_FLAGS_${cfg} "=" "${CMAKE_${flag}_FLAGS_${cfg}}")
      endforeach ()
   endforeach ()
endif()

# The module depends on a number of libraries in the ORE project: determine their exact names
get_library_name("OREData" ORED_LIB_NAME)
get_library_name("QuantExt" QLE_LIB_NAME)
set_ql_library_name()

# To build the module, we moreover need Boost, Swig, Python
find_package(Boost COMPONENTS serialization date_time regex filesystem system timer thread REQUIRED)
find_package(SWIG REQUIRED)
find_package(PythonLibs)

# Load the UseSWIG module from the cmake installation
include(${SWIG_USE_FILE})

# Add to the list of include directories
include_directories(${PROJECT_SOURCE_DIR}/../SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantLib-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantExt-SWIG/SWIG)
include_directories(${ORE_BUILD}/QuantLib)
include_directories(${ORE}/QuantLib)
include_directories(${ORE}/QuantExt)
include_directories(${ORE}/OREData)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_PATH})

# Add to the list of link directories
link_directories(${Python_LIBRARY_DIRS})
add_link_directory_if_exists(${ORE_BUILD}/QuantLib/ql)
add_link_directory_if_exists(${ORE_BUILD}/QuantExt/qle)
add_link_directory_if_exists(${ORE_BUILD}/OREData/ored)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-includeall")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-modern")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-py3")

# Tell SWIG to build a Python module, to be called "OREData"
swig_add_library(OREData TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/oredata.i)

# Add all libraries to link with
target_link_libraries(OREData ${Boost_LIBRARIES})
target_link_libraries(OREData ${QL_LIB_NAME})
target_link_libraries(OREData ${QLE_LIB_NAME})
target_link_libraries(OREData ${ORED_LIB_NAME})

# On windows, do not tell the build which python libs to use.  It automatically
# looks for python release libs, even in debug, and invoking the line below
# breaks the debug build.
if(NOT MSVC)
    target_link_libraries(OREData ${Python_LIBRARIES})
endif()

if (MSVC)
	get_target_property(target_options OREData COMPILE_OPTIONS)
	list(REMOVE_ITEM target_options "/we4189")
	set_property(TARGET OREData PROPERTY COMPILE_OPTIONS ${target_options})
endif()
