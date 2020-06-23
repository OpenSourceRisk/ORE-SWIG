cmake_minimum_required(VERSION 3.8)

project(OREData-Python)

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
get_library_name("QuantLib" QL_LIB_NAME)
configure_msvc_runtime()

# To build the module, we moreover need Boost, Swig, Python
find_package(Boost COMPONENTS serialization date_time regex filesystem system timer REQUIRED)
find_package(SWIG REQUIRED)
find_package(PythonLibs)

# What does this mean?
include(${SWIG_USE_FILE})

# Add to the list of include directories
include_directories(${PROJECT_SOURCE_DIR}/../SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantLib-SWIG/SWIG)
include_directories(${PROJECT_SOURCE_DIR}/../../QuantExt-SWIG/SWIG)
include_directories(${ORE}/QuantLib)
include_directories(${ORE}/QuantExt)
include_directories(${ORE}/OREData)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_PATH})

# Add to the list of link directories
link_directories(${ORE}/build/QuantLib/ql)
link_directories(${ORE}/build/QuantExt/qle)
link_directories(${ORE}/build/OREData/ored)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-includeall")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-modern")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oredata.i PROPERTIES SWIG_FLAGS "-py3")

# Tell SWIG to build a Python module, to be called "OREData"
swig_add_library(OREData TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/oredata.i)

# Add all libraries to link with
swig_link_libraries(OREData ${PYTHON_LIBRARIES})
swig_link_libraries(OREData ${Boost_LIBRARIES})
swig_link_libraries(OREData ${QL_LIB_NAME})
swig_link_libraries(OREData ${QLE_LIB_NAME})
swig_link_libraries(OREData ${ORED_LIB_NAME})
