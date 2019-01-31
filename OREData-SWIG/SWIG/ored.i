
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_i
#define ored_i

%{
#include <boost/shared_ptr.hpp>
#include <boost/assert.hpp>
#include <boost/current_function.hpp>

#include <exception>
#include <sstream>
#include <string>
#include <map>
#include <vector>

#include <ql/errors.hpp>

#ifdef BOOST_MSVC
#include <ored/auto_link.hpp>
#endif

#include <ored/ored.hpp>

%}

%include ored_conventions.i
%include ored_parsers.i
%include ored_market.i
%include ored_portfolio.i
%include ored_log.i

#endif