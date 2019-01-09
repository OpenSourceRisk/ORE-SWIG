/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_equityforward_i
#define qle_equityforward_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i

%include qle_termstructures.i

%{
using QuantExt::EquityForward;
using QuantExt::DiscountingEquityForwardEngine;

typedef boost::shared_ptr<Instrument> EquityForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingEquityForwardEnginePtr;
%}

%rename(EquityForward) EquityForwardPtr;
class EquityForwardPtr : public boost::shared_ptr<Instrument> {
public:
    %extend{
        EquityForwardPtr(const std::string& name,
                         const QuantLib::Currency& currency,
                         const QuantLib::Position::Type& longShort,
                         const QuantLib::Real& quantity,
                         const QuantLib::Date& maturityDate,
                         const QuantLib::Real& strike) {
            return new EquityForwardPtr(
                new EquityForward(name,currency,longShort,quantity,maturityDate,strike));
        }
        
        bool isExpired() const {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->isExpired();
        }
        
        const std::string& name(){
            return boost::dynamic_pointer_cast<EquityForward>(*self)->name();
        }
        
        QuantLib::Currency currency() {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->currency();
        }
        
        QuantLib::Position::Type longShort() {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->longShort();
        }
        
        QuantLib::Real quantity() {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->quantity();
        }
                
        QuantLib::Date maturityDate() {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->maturityDate();
        }
        
        QuantLib::Real strike() {
            return boost::dynamic_pointer_cast<EquityForward>(*self)->strike();
        }
 
    }
};


%rename(DiscountingEquityForwardEngine) DiscountingEquityForwardEnginePtr;
class DiscountingEquityForwardEnginePtr : public boost::shared_ptr<PricingEngine> {
public:
    %extend{
        DiscountingEquityForwardEnginePtr(const QuantLib::Handle<QuantLib::YieldTermStructure>& equityInterestRateCurve,
                                          const QuantLib::Handle<QuantLib::YieldTermStructure>& dividendYieldCurve,
                                          const QuantLib::Handle<QuantLib::Quote>& equitySpot, 
                                          const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                          boost::optional<bool> includeSettlementDateFlows = boost::none,
                                          const QuantLib::Date& settlementDate = QuantLib::Date(), 
                                          const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DiscountingEquityForwardEnginePtr(
                new DiscountingEquityForwardEngine(equityInterestRateCurve,dividendYieldCurve,equitySpot,discountCurve,includeSettlementDateFlows,settlementDate,npvDate));
        }
        
        void calculate() {
            return boost::dynamic_pointer_cast<DiscountingEquityForwardEngine>(*self)->calculate();
        }
        
        const QuantLib::Handle<QuantLib::YieldTermStructure>& equityReferenceRateCurve(){
            return boost::dynamic_pointer_cast<DiscountingEquityForwardEngine>(*self)->equityReferenceRateCurve();
        }
        
        const QuantLib::Handle<QuantLib::YieldTermStructure>& divYieldCurve() {
            return boost::dynamic_pointer_cast<DiscountingEquityForwardEngine>(*self)->divYieldCurve();
        }
        
        const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve() {
            return boost::dynamic_pointer_cast<DiscountingEquityForwardEngine>(*self)->discountCurve();
        }
        
        const QuantLib::Handle<QuantLib::Quote>& equitySpot() {
            return boost::dynamic_pointer_cast<DiscountingEquityForwardEngine>(*self)->equitySpot();
        }

    }
};

#endif
