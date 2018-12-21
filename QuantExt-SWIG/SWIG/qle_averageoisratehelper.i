
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_averageoisratehelper_i
#define qle_averageoisratehelper_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i
%include qle_averageois.i

%{
using QuantExt::AverageOISRateHelper;
typedef boost::shared_ptr<RateHelper> AverageOISRateHelperPtr;
%}

%rename(AverageOISRateHelper) AverageOISRateHelperPtr;
class AverageOISRateHelperPtr : public boost::shared_ptr<RateHelper> {
public:
    %extend{
        AverageOISRateHelperPtr(const QuantLib::Handle<QuantLib::Quote>& fixedRate, 
                                const QuantLib::Period& spotLagTenor, 
                                const QuantLib::Period& swapTenor,
                                const QuantLib::Period& fixedTenor, 
                                const QuantLib::DayCounter& fixedDayCounter, 
                                const QuantLib::Calendar& fixedCalendar,
                                QuantLib::BusinessDayConvention fixedConvention, 
                                QuantLib::BusinessDayConvention fixedPaymentAdjustment,
                                OvernightIndexPtr& overnightIndex, 
                                const QuantLib::Period& onTenor,
                                const QuantLib::Handle<QuantLib::Quote>& onSpread, 
                                QuantLib::Natural rateCutoff,
                                const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve = QuantLib::Handle<QuantLib::YieldTermStructure>()) {
                                
            boost::shared_ptr<OvernightIndex> onIdx = boost::dynamic_pointer_cast<OvernightIndex>(overnightIndex);
            return new AverageOISRateHelperPtr(
                new AverageOISRateHelper(fixedRate,
                                         spotLagTenor,
                                         swapTenor,
                                         fixedTenor,
                                         fixedDayCounter,
                                         fixedCalendar,
                                         fixedConvention,
                                         fixedPaymentAdjustment,
                                         onIdx,
                                         onTenor,
                                         onSpread,
                                         rateCutoff,
                                         discountCurve
                                         ));
        }
        
        QuantLib::Real onSpread() const {
            return boost::dynamic_pointer_cast<AverageOISRateHelper>(*self)->onSpread();
        }
        
        AverageOISPtr averageOIS() const {
            return boost::dynamic_pointer_cast<AverageOISRateHelper>(*self)->averageOIS();
        }
        
    }
    
};

#endif


