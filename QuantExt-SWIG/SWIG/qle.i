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
#include <qle/instruments/commodityforward.hpp>
#include <qle/instruments/crossccybasisswap.hpp>
#include <qle/termstructures/pricetermstructure.hpp>
#include <qle/termstructures/pricecurve.hpp>
#include <qle/termstructures/crossccybasisswaphelper.hpp>
#include <qle/pricingengines/discountingcommodityforwardengine.hpp>
%}

//%include qle_commodityforward.i
%include qle_termstructures.i
%include qle_instruments.i
%include qle_ratehelpers.i

#endif
