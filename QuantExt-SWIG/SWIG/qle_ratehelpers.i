/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_ratehelpers_i
#define qle_ratehelpers_i

%include ratehelpers.i
%include qle_instruments.i
%include qle_tenorbasisswap.i

%{
using QuantExt::CrossCcyBasisSwapHelper;
using QuantExt::TenorBasisSwapHelper;

typedef boost::shared_ptr<RateHelper> CrossCcyBasisSwapHelperPtr;
typedef boost::shared_ptr<RateHelper> TenorBasisSwapHelperPtr;
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
                               const Handle<YieldTermStructure>& spreadDiscountCurve, 
                               bool eom = false,
                               bool flatIsDomestic = true) {
        boost::shared_ptr<IborIndex> flatIbor = boost::dynamic_pointer_cast<IborIndex>(flatIndex);
        boost::shared_ptr<IborIndex> spreadIbor = boost::dynamic_pointer_cast<IborIndex>(spreadIndex);
        return new CrossCcyBasisSwapHelperPtr(
            new CrossCcyBasisSwapHelper(spreadQuote, 
                                        spotFX, 
                                        settlementDays, 
                                        settlementCalendar, 
                                        swapTenor, 
                                        rollConvention, 
                                        flatIbor, 
                                        spreadIbor, 
                                        flatDiscountCurve, 
                                        spreadDiscountCurve, 
                                        eom, 
                                        flatIsDomestic));
    }
    CrossCcyBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<CrossCcyBasisSwapHelper>(*self)->swap();
    }
  }
};

%rename(TenorBasisSwapHelper) TenorBasisSwapHelperPtr;
class TenorBasisSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    TenorBasisSwapHelperPtr(QuantLib::Handle<QuantLib::Quote> spread,
                            const QuantLib::Period& swapTenor,
                            const IborIndexPtr longIndex,
                            const IborIndexPtr shortIndex,
                            const QuantLib::Period& shortPayTenor = QuantLib::Period(),
                            const QuantLib::Handle<QuantLib::YieldTermStructure>& discountingCurve 
                                = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                            bool spreadOnShort = true, 
                            bool includeSpread = false,
                            SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
        boost::shared_ptr<IborIndex> longIbor = boost::dynamic_pointer_cast<IborIndex>(longIndex);
        boost::shared_ptr<IborIndex> shortIbor = boost::dynamic_pointer_cast<IborIndex>(shortIndex);
        return new TenorBasisSwapHelperPtr(
            new TenorBasisSwapHelper(spread,
                                     swapTenor,
                                     longIbor,
                                     shortIbor,
                                     shortPayTenor,
                                     discountingCurve,
                                     spreadOnShort,
                                     includeSpread,
                                     type));
    }
    TenorBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<TenorBasisSwapHelper>(*self)->swap();
    }
  }
};

#endif
