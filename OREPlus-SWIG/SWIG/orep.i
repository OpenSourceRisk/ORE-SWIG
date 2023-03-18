/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef orep_i
#define orep_i

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
#include <oreap/auto_link.hpp>
#endif

#include <oreap/app/oreappplus.hpp>
#include <oreap/app/initplusbuilders.hpp>
#include <oreap/oreap.hpp>

%}

%init %{
    oreplus::analytics::initPlusBuilders();
%}

%include oreap_app.i

#endif
