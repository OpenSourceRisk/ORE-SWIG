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
#include <oredp/auto_link.hpp>
#include <orepsensi/auto_link.hpp>
#include <orepbase/auto_link.hpp>
#include <qlep/auto_link.hpp>
#endif

#include <oreap/app/oreappplus.hpp>
#include <oreap/oreap.hpp>
#include <oredp/oredp.hpp>
#include <orepsensi/orepsensi.hpp>
#include <orepbase/orepbase.hpp>
#include <qlep/quantextplus.hpp>

%}

%include oreap_app.i
%include orep_creditdefaultswap.i

#endif
