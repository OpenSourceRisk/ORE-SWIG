/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_i
#define qle_i

%{
#ifdef BOOST_MSVC
#include <qle/auto_link.hpp>
#endif
#include <qle/quantext.hpp>
%}

//%include qle_commodityforward.i
%include qle_termstructures.i
%include qle_instruments.i
%include qle_ratehelpers.i
%include qle_currencies.i
%include qle_fxforward.i
%include qle_ccyswap.i

#endif
