cmake_minimum_required(VERSION 3.8)

project(OREPlus-Python)

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
get_library_name("QuantLib" QL_LIB_NAME)
get_library_name("QuantExt" QLE_LIB_NAME)
get_library_name("OREData" ORED_LIB_NAME)
get_library_name("OREAnalytics" OREA_LIB_NAME)
get_library_name("QuantExtPlus" QLEP_LIB_NAME)
get_library_name("OREDataPlus" OREDP_LIB_NAME)
get_library_name("OREAnalyticsPlus" OREAP_LIB_NAME)
get_library_name("OREPlusBase" OREPBASE_LIB_NAME)
get_library_name("OREPlusSensitivity" OREPSENSITIVITY_LIB_NAME)
get_library_name("OREPlusFormulaBasedCoupon" OREPFBC_LIB_NAME)
get_library_name("OREPlusCredit" OREPCREDIT_LIB_NAME)
get_library_name("OREPlusScriptedTrade" OREPSCRIPTEDTRADE_LIB_NAME)
get_library_name("OREPlusAMC" OREPAMC_LIB_NAME)
configure_msvc_runtime()

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
include_directories(${ORE}/QuantExtPlus)
include_directories(${ORE}/OREDataPlus)
include_directories(${ORE}/OREAnalyticsPlus)
include_directories(${ORE}/OREPlus/Base)
include_directories(${ORE}/OREPlus/FormulaBasedCoupon)
include_directories(${ORE}/OREPlus/Sensitivity)
include_directories(${ORE}/OREPlus/ScriptedTrade)
include_directories(${ORE}/OREPlus/Credit)
include_directories(${ORE}/OREPlus/AMC)
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_PATH})

# Add to the list of link directories
link_directories(${ORE}/build/QuantLib/ql)
link_directories(${ORE}/build/QuantExt/qle)
link_directories(${ORE}/build/OREData/ored)
link_directories(${ORE}/build/OREAnalytics/orea)
link_directories(${ORE}/build/QuantExtPlus/qlep)
link_directories(${ORE}/build/OREDataPlus/oredp)
link_directories(${ORE}/build/OREAnalyticsPlus/oreap)
link_directories(${ORE}/build/OREPlus/Base/orepbase)
link_directories(${ORE}/build/OREPlus/FormulaBasedCoupon/orepfbc)
link_directories(${ORE}/build/OREPlus/Sensitivity/orepsensi)
link_directories(${ORE}/build/OREPlus/ScriptedTrade/orepscriptedtrade)
link_directories(${ORE}/build/OREPlus/Credit/orepcredit)
link_directories(${ORE}/build/OREPlus/AMC/orepamc)

# Tell SWIG to compile in C++ mode
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i PROPERTIES SWIG_FLAGS "-includeall")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i PROPERTIES SWIG_FLAGS "-modern")
#set_source_files_properties(${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i PROPERTIES SWIG_FLAGS "-py3")

# Tell SWIG to build a Python module, to be called "OREPlus"
swig_add_library(OREPlus TYPE MODULE LANGUAGE python SOURCES ${PROJECT_SOURCE_DIR}/../SWIG/oreplus.i)

# Add all libraries to link with
swig_link_libraries(OREPlus ${PYTHON_LIBRARIES})
swig_link_libraries(OREPlus ${Boost_LIBRARIES})
swig_link_libraries(OREPlus ${QL_LIB_NAME})
swig_link_libraries(OREPlus ${QLE_LIB_NAME})
swig_link_libraries(OREPlus ${ORED_LIB_NAME})
swig_link_libraries(OREPlus ${OREA_LIB_NAME})
swig_link_libraries(OREPlus ${QLEP_LIB_NAME})
swig_link_libraries(OREPlus ${OREDP_LIB_NAME})
swig_link_libraries(OREPlus ${OREAP_LIB_NAME})
swig_link_libraries(OREPlus ${OREPBASE_LIB_NAME})
swig_link_libraries(OREPlus ${OREPFBC_LIB_NAME})
swig_link_libraries(OREPlus ${OREPSENSI_LIB_NAME})
swig_link_libraries(OREPlus ${OREPSCRIPTEDTRADE_LIB_NAME})
swig_link_libraries(OREPlus ${OREPAMC_LIB_NAME})
swig_link_libraries(OREPlus ${OREPCREDIT_LIB_NAME})
