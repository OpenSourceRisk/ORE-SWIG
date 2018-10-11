
/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl
 Copyright (C) 2003, 2004, 2005, 2006, 2007, 2008 StatPro Italia srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <http://quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

// Undefine symbols that are also used in quantlib

#if defined(SWIGPYTHON)
%{
#ifdef barrier
#undef barrier
#endif
%}
#endif

#if defined(SWIGRUBY)
%{
#ifdef accept
#undef accept
#endif
#ifdef close
#undef close
#endif
#ifdef times
#undef times
#endif
#ifdef Sleep
#undef Sleep
#endif
#ifdef bind
#undef bind
#endif
#ifdef ALLOC
#undef ALLOC
#endif
%}
#endif

#if defined(SWIGPERL)
%{
#ifdef accept
#undef accept
#endif
#ifdef Null
#undef Null
#endif
#ifdef Nullch
#undef Nullch
#define Nullch ((char*) NULL)
#endif
#ifdef Stat
#undef Stat
#endif
#ifdef seed
#undef seed
#endif
#ifdef setbuf
#undef setbuf
#endif
#ifdef times
#undef times
#endif
%}
#endif

%{
#include <ql/quantlib.hpp>

#if QL_HEX_VERSION < 0x011200f0
    #error using an old version of QuantLib, please update
#endif

#ifdef BOOST_MSVC
#ifdef QL_ENABLE_THREAD_SAFE_OBSERVER_PATTERN
#define BOOST_LIB_NAME boost_thread
#include <boost/config/auto_link.hpp>
#undef BOOST_LIB_NAME
#define BOOST_LIB_NAME boost_system
#include <boost/config/auto_link.hpp>
#undef BOOST_LIB_NAME
#endif
#endif

#if defined (SWIGJAVA) || defined (SWIGCSHARP) 
  #ifndef QL_ENABLE_THREAD_SAFE_OBSERVER_PATTERN
    #ifdef BOOST_MSVC
      #pragma message(\
          "Quantlib has not been compiled with the thread-safe "           \
          "observer pattern being enabled. This can lead to spurious "     \
          "crashes or pure virtual function call within the JVM or .NET "  \
          "ecosystem due to the async garbage collector. Please consider " \
          "enabling QL_ENABLE_THREAD_SAFE_OBSERVER_PATTERN "               \
          "in ql/userconfig.hpp.")
    #else
      #warning \
          Quantlib has not been compiled with the thread-safe           \
          observer pattern being enabled. This can lead to spurious     \
          crashes or pure virtual function call within the JVM or .NET  \
          ecosystem due to the async garbage collector. Please consider \
          passing --enable-thread-safe-observer-pattern when using the  \
          GNU autoconf configure script.
    #endif
  #endif
#endif


// add here SWIG version check

#if defined(_MSC_VER)         // Microsoft Visual C++ 6.0
// disable Swig-dependent warnings

// 'identifier1' has C-linkage specified,
// but returns UDT 'identifier2' which is incompatible with C
#pragma warning(disable: 4190)

// 'int' : forcing value to bool 'true' or 'false' (performance warning)
#pragma warning(disable: 4800)

// debug info too long etc etc
#pragma warning(disable: 4786)
#endif
%}

#ifdef SWIGPYTHON
%{
#if PY_VERSION_HEX < 0x02010000
    #error Python version 2.1.0 or later is required
#endif
%}
#endif

#ifdef SWIGJAVA
%include "enumtypesafe.swg"
#endif

// common name mappings
#if defined(SWIGPERL)
%rename("to_string")     __str__;
#elif defined(SWIGJAVA)
%rename(add)           operator+;
%rename(add)           __add__;
%rename(subtract)      operator-;
%rename(subtract)      __sub__;
%rename(multiply)      operator*;
%rename(multiply)      __mul__;
%rename(divide)        operator/;
%rename(divide)        __div__;
%rename(getValue)      operator();
%rename(equals)        __eq__;
%rename(unEquals)      __ne__;
%rename(toString)      __str__;
#elif defined(SWIGCSHARP)
%rename(Add)           operator+;
%rename(Add)           __add__;
%rename(Subtract)      operator-;
%rename(Subtract)      __sub__;
%rename(Multiply)      operator*;
%rename(Multiply)      __mul__;
%rename(Divide)        operator/;
%rename(Divide)        __div__;
#endif

// minimal set of quantlib includes for faster build and testing of subsequent modules
// ql.i is the reference, bulk of the quantlib includes removed
%include null.i
%include termstructures.i
%include indexes.i

