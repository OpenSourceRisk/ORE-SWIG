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

%include qle_cashflows.i
%include qle_indexes.i
%include qle_termstructures.i
%include qle_instruments.i
%include qle_ratehelpers.i
%include qle_currencies.i
%include qle_ccyswap.i
%include qle_crossccyfixfloatswap.i
%include qle_equityforward.i
%include qle_averageois.i
%include qle_tenorbasisswap.i
%include qle_oiccbasisswap.i
%include qle_creditdefaultswap.i
%include qle_averageoisratehelper.i
//%include qle_crossccyfixfloatswaphelper.i

#endif
