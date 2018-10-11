/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_i
#define qle_i

%{
//#include <qle/quantext.hpp>
#include <qle/instruments/commodityforward.hpp>
#include <qle/termstructures/pricetermstructure.hpp>
#include <qle/termstructures/pricecurve.hpp>
#include <qle/pricingengines/discountingcommodityforwardengine.hpp>
%}

%include qle_commodityforward.i

#endif
