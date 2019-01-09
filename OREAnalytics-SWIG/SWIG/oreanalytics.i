
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

// UNCOMMENT THE BELOW IF YOU WISH TO BUILD THE C++ CODE IN DEBUG MODE
//%begin %{
//#ifdef _MSC_VER
//#define SWIG_PYTHON_INTERPRETER_NO_DEBUG
//#endif
//%}

#if defined(SWIGRUBY)
%module OREAnalyticsc
#elif defined(SWIGCSHARP)
%module(directors="1") NOREAnalyticsc
#elif defined(SWIGJAVA)
%module(directors="1") OREAnalytics
#else
%module OREAnalytics
#endif

%include exception.i

%exception {
    try {
        $action
    } catch (std::out_of_range& e) {
        SWIG_exception(SWIG_IndexError,const_cast<char*>(e.what()));
    } catch (std::exception& e) {
        SWIG_exception(SWIG_RuntimeError,const_cast<char*>(e.what()));
    } catch (...) {
        SWIG_exception(SWIG_UnknownError,"unknown error");
    }
}

#if defined(SWIGPYTHON)
%{
#include <qle/version.hpp>
const int    __hexversion__ = OPEN_SOURCE_RISK_VERSION_NUM;
const char* __version__    = OPEN_SOURCE_RISK_VERSION;
%}

const int __hexversion__;
%immutable;
const char* __version__;
%mutable;
#endif

#if defined(JAVA_AUTOLOAD)
// Automatically load the shared library for JAVA binding
%pragma(java) jniclasscode=%{
  /// Load the JNI library
  static {
    System.loadLibrary("OREAnalyticsJNI");
  }
%}
#endif

//#if defined(SWIGPYTHON)
//%feature("autodoc");
//#endif

// include all quantlib .i's
%include ql_patched.i

// include all quantext .i's
%include qle.i

// include all OREData .i's
%include ored.i

// include all OREAnalytics and OREData .i's
%include orea.i
%include ored.i
