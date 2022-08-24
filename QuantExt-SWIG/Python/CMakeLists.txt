cmake_minimum_required(VERSION 3.8)

project(QuantExt-Python)

include(${PROJECT_SOURCE_DIR}/../../cmake/commonSettings.cmake)

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
get_library_name("QuantExt" QLE_LIB_NAME)
get_library_name("QuantLib" QL_LIB_NAME)
configure_msvc_runtime()

# To build the module, we moreover need Boost, Swig, Python
find_package(Boost COMPONENTS serialization date_time regex filesystem system timer thread REQUIRED)
find_package(SWIG REQUIRED)
find_package(PythonLibs)

# What does this mean?
include(${SWIG_USE_FILE})

# Add to the list of include directories
include_directories(${PROJECT_SOURCE_DIR}/../SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantLib-SWIG/SWIG)
include_directories(${ORE}/QuantLib)
include_directories(${ORE}/QuantExt)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_PATH})

# Add to the list of link directories
add_link_directory_if_exists(${ORE}/QuantLib/build/ql)
add_link_directory_if_exists(${ORE}/build/QuantLib/ql)
add_link_directory_if_exists(${ORE}/build/QuantExt/qle)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/quantext.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/quantext.i PROPERTIES SWIG_FLAGS "-includeall")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/quantext.i PROPERTIES SWIG_FLAGS "-modern")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/quantext.i PROPERTIES SWIG_FLAGS "-py3")

# Tell SWIG to build a Python module, to be called "QuantExt"
swig_add_library(QuantExt TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/quantext.i)

# Add all libraries to link with
swig_link_libraries(QuantExt ${PYTHON_LIBRARIES})
swig_link_libraries(QuantExt ${Boost_LIBRARIES})
swig_link_libraries(QuantExt ${QL_LIB_NAME})
swig_link_libraries(QuantExt ${QLE_LIB_NAME})
