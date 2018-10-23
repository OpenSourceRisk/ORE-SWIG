/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_ratehelpers_i
#define qle_ratehelpers_i

%include ratehelpers.i
%include qle_instruments.i

%{
using QuantExt::CrossCcyBasisSwapHelper;
typedef boost::shared_ptr<RateHelper> CrossCcyBasisSwapHelperPtr;
%}

%rename(CrossCcyBasisSwapHelper) CrossCcyBasisSwapHelperPtr;
class CrossCcyBasisSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    CrossCcyBasisSwapHelperPtr(const Handle<Quote>& spreadQuote,
			       const Handle<Quote>& spotFX,
			       Natural settlementDays,
			       const Calendar& settlementCalendar,
			       const Period& swapTenor,
			       BusinessDayConvention rollConvention,
			       const IborIndexPtr& flatIndex,
			       const IborIndexPtr& spreadIndex,
			       const Handle<YieldTermStructure>& flatDiscountCurve,
			       const Handle<YieldTermStructure>& spreadDiscountCurve, bool eom = false,
			       bool flatIsDomestic = true) {
      boost::shared_ptr<IborIndex> flatIbor =
	boost::dynamic_pointer_cast<IborIndex>(flatIndex);
      boost::shared_ptr<IborIndex> spreadIbor =
	boost::dynamic_pointer_cast<IborIndex>(spreadIndex);
      return new CrossCcyBasisSwapHelperPtr(new CrossCcyBasisSwapHelper(spreadQuote, spotFX, settlementDays, settlementCalendar, swapTenor, rollConvention, flatIbor, spreadIbor, flatDiscountCurve, spreadDiscountCurve, eom, flatIsDomestic));
    }

    CrossCcyBasisSwapPtr swap() {
      return boost::dynamic_pointer_cast<CrossCcyBasisSwapHelper>(*self)->swap();
    }
  }
};

#endif
