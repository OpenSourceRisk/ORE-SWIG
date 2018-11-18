/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_crossccyfixfloatswaphelper.i
#define qle_crossccyfixfloatswaphelper.i

%include ratehelpers_i
%include qle_instruments_i

%{
using QuantExt::CrossCcyFixFloatSwapHelper;
typedef boost::shared_ptr<RateHelper> CrossCcyFixFloatSwapHelperPtr;
%}

%rename(CrossCcyFixFloatSwapHelper) CrossCcyFixFloatSwapHelperPtr;
class CrossCcyFixFloatSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    CrossCcyFixFloatSwapHelperPtr(const QuantLib::Handle<QuantLib::Quote>& rate, 
								const QuantLib::Handle<QuantLib::Quote>& spotFx, 
								QuantLib::Natural settlementDays, 
								const QuantLib::Calendar& paymentCalendar, 
								QuantLib::BusinessDayConvention paymentConvention, 
								const QuantLib::Period& tenor, 
								const QuantLib::Currency& fixedCurrency,
								QuantLib::Frequency fixedFrequency, 
								QuantLib::BusinessDayConvention fixedConvention, 
								const QuantLib::DayCounter& fixedDayCount, 
								const IborIndexPtr& index, 
								const QuantLib::Handle<QuantLib::YieldTermStructure>& floatDiscount, 
								const QuantLib::Handle<QuantLib::Quote>& spread = QuantLib::Handle<QuantLib::Quote>(), 
								bool endOfMonth = false) {
				  boost::shared_ptr<IborIndex> indexSwap = boost::dynamic_pointer_cast<IborIndex>(index);
return new CrossCcyFixFloatSwapHelperPtr(new CrossCcyFixFloatSwapHelper(rate,
																		spotFx,
																		settlementDays,
																		paymentCalendar,
																		paymentConvention,
																		tenor,
																		fixedCurrency,
																		fixedFrequency,
																		fixedConvention,
																		fixedDayCount,
																		indexSwap,
																		floatDiscount,
																		spread));
    }

    CrossCcyFixFloatSwapPtr swap() {
      return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapHelper>(*self)->swap();
    }
  }
};

#endif
