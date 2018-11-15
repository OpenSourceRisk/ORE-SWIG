/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_crossccyfixfloatswap.i
#define qle_crossccyfixfloatswap.i

%include instruments.i
%include scheduler.i
%include indexes.i

%{
using QuantExt::CrossCcyFixFloatSwap;
typedef boost::shared_ptr<Instrument> CrossCcyFixFloatSwapPtr;
%}

%ignore CrossCcyFixFloatSwap;
class CrossCcyFixFloatSwap {
  public:
    enum Type { Receiver = -1, Payer = 1 };
};

%rename(CrossCcyFixFloatSwap) CrossCcyFixFloatSwapPtr;
class CrossCcyFixFloatSwapPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
	    static const CrossCcyFixFloatSwap::Type Receiver = CrossCcyFixFloatSwap::Receiver;
        static const CrossCcyFixFloatSwap::Type Payer = CrossCcyFixFloatSwap::Payer;
		CrossCcyFixFloatSwapPtr(CrossCcyFixFloatSwap::Type type, 
							QuantLib::Real fixedNominal,
							const QuantLib::Currency& fixedCurrency,
							const QuantLib::Schedule& fixedSchedule,
							QuantLib::Rate fixedRate,
							const QuantLib::DayCounter& fixedDayCount,
							QuantLib::BusinessDayConvention fixedPaymentBdc,
							QuantLib::Natural fixedPaymentLag,
							const QuantLib::Calendar& fixedPaymentCalendar,
							QuantLib::Real floatNominal,
							const QuantLib::Currency& floatCurrency,
							const QuantLib::Schedule& floatSchedule,
							const IborIndexPtr& floatIndex,
							QuantLib::Spread floatSpread,
							QuantLib::BusinessDayConvention floatPaymentBdc,
							QuantLib::Natural floatPaymentLag,
							const QuantLib::Calendar& floatPaymentCalendar) {
			boost::shared_ptr<IborIndex> flIndex = boost::dynamic_pointer_cast<IborIndex>(floatIndex);			
            return new CrossCcyFixFloatSwapPtr(
                new CrossCcyFixFloatSwap(type,
									  fixedNominal,
									  fixedCurrency,
									  fixedSchedule,
									  fixedRate,
									  fixedDayCount,
									  fixedPaymentBdc,
									  fixedPaymentLag,
									  fixedPaymentCalendar,
									  floatNominal,
									  floatCurrency,
									  floatSchedule,
									  flIndex,
									  floatSpread,
									  floatPaymentBdc,
									  floatPaymentLag,
									  floatPaymentCalendar));
				}
	    }
};

#endif
