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
using QuantExt::CrossCcyBasisSwap;
typedef boost::shared_ptr<Instrument> CrossCcyBasisSwapPtr;
%}

%ignore CrossCcyBasisSwap;
class CrossCcyBasisSwap {
  public:
    enum Type { Receiver = -1, Payer = 1 };
};

%rename(CrossCcySwap) CrossCcyBasisSwapPtr;
class CrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
	    static const CrossCcyBasisSwap::Type Receiver = CrossCcyBasisSwap::Receiver;
        static const CrossCcyBasisSwap::Type Payer = CrossCcyBasisSwap::Payer;
		CrossCcyBasisSwapPtr(Type type, 
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
							const boost::shared_ptr<QuantLib::IborIndex>& floatIndex,
							QuantLib::Spread floatSpread,
							QuantLib::BusinessDayConvention floatPaymentBdc,
							QuantLib::Natural floatPaymentLag,
							const QuantLib::Calendar& floatPaymentCalendar) {
            return new CrossCcyBasisSwapPtr(
                new CrossCcyBasisSwap(type,
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
									  floatIndex,
									  floatSpread,
									  floatPaymentBdc,
									  floatPaymentLag,
									  floatPaymentCalendar));
				}
	    }
};

#endif
