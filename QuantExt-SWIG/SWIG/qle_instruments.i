/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_instruments_i
#define qle_instruments_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i

%include qle_termstructures.i

%{
using QuantExt::CrossCcyBasisSwap;
using QuantExt::CommodityForward;
using QuantExt::DiscountingCommodityForwardEngine;
using QuantExt::FxForward;
using QuantExt::DiscountingFxForwardEngine;

typedef boost::shared_ptr<Instrument> CrossCcyBasisSwapPtr;
typedef boost::shared_ptr<Instrument> CommodityForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingCommodityForwardEnginePtr;
typedef boost::shared_ptr<Instrument> FxForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingFxForwardEnginePtr;
%}


%rename(FxForward) FxForwardPtr;
class FxForwardPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
        FxForwardPtr(const QuantLib::Real& nominal1,
                     const QuantLib::Currency& currency1,
                     const QuantLib::Real& nominal2,
                     const QuantLib::Currency& currency2,
                     const QuantLib::Date& maturityDate,
                     const bool& payCurrency1) {
            return new FxForwardPtr(
                new FxForward(nominal1, 
                              currency1, 
                              nominal2, 
                              currency2,
                              maturityDate, 
                              payCurrency1));
        }

        const QuantLib::Real& currency1Nominal() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency1Nominal(); 
        }
        
        const QuantLib::Real& currency2Nominal() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency2Nominal(); 
        }
        
        const QuantLib::Currency& currency1() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency1(); 
        }
        
        const QuantLib::Currency& currency2() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency2(); 
        }
        
        const QuantLib::Date& maturityDate() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->maturityDate(); 
        }
        
        const bool& payCurrency1() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->payCurrency1(); 
        }
    }
};


%rename(DiscountingFxForwardEngine) DiscountingFxForwardEnginePtr;
class DiscountingFxForwardEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        DiscountingFxForwardEnginePtr(const QuantLib::Currency& ccy1,
                                      const QuantLib::Handle<QuantLib::YieldTermStructure>& currency1Discountcurve,
                                      const QuantLib::Currency& ccy2,
                                      const QuantLib::Handle<QuantLib::YieldTermStructure>& currency2Discountcurve,
                                      const QuantLib::Handle<QuantLib::Quote>& spotFX,
                                      boost::optional<bool> includeSettlementDateFlows = boost::none,
                                      const QuantLib::Date& settlementDate = QuantLib::Date(),
                                      const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DiscountingFxForwardEnginePtr(
                                  new DiscountingFxForwardEngine(ccy1,
                                                                 currency1Discountcurve,
                                                                 ccy2,
                                                                 currency2Discountcurve,
                                                                 spotFX,
                                                                 includeSettlementDateFlows,
                                                                 settlementDate,
                                                                 npvDate));
        }
    }
};


%rename(CrossCcyBasisSwap) CrossCcyBasisSwapPtr;
class CrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
 public:
  %extend {
    CrossCcyBasisSwapPtr(QuantLib::Real payNominal,
                         const QuantLib::Currency& payCurrency,
                         const QuantLib::Schedule& paySchedule,
                         const IborIndexPtr& payIndex,
                         QuantLib::Spread paySpread,
                         QuantLib::Real recNominal,
                         const QuantLib::Currency& recCurrency,
                         const QuantLib::Schedule& recSchedule,
                         const IborIndexPtr& recIndex,
                         QuantLib::Spread recSpread) {
            boost::shared_ptr<IborIndex> payIbor = boost::dynamic_pointer_cast<IborIndex>(payIndex);
            boost::shared_ptr<IborIndex> recIbor = boost::dynamic_pointer_cast<IborIndex>(recIndex);
            return new CrossCcyBasisSwapPtr(
                new CrossCcyBasisSwap(payNominal, 
                                      payCurrency, 
                                      paySchedule, 
                                      payIbor,
                                      paySpread, 
                                      recNominal, 
                                      recCurrency, 
                                      recSchedule, 
                                      recIbor, 
                                      recSpread));
    }

    Real payNominal() {
      return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->payNominal();
    }
  }
};

%rename(CommodityForward) CommodityForwardPtr;
class CommodityForwardPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
        CommodityForwardPtr(const std::string& name, 
                            const QuantLib::Currency& currency,
                            QuantLib::Position::Type position, 
                            QuantLib::Real quantity,
                            const QuantLib::Date& maturityDate, 
                            QuantLib::Real strike) {
            return new CommodityForwardPtr(
                new CommodityForward(name, 
                                     currency, 
                                     position, 
                                     quantity, 
                                     maturityDate, 
                                     strike));
        }

        const std::string& name() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->name(); 
        }

        const QuantLib::Currency& currency() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->currency();
        }

        QuantLib::Position::Type position() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->position();
        }

        QuantLib::Real quantity() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->quantity(); 
        }

        const QuantLib::Date& maturityDate() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->maturityDate();
        }

        QuantLib::Real strike() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->strike(); 
        }
    }
};

%rename(DiscountingCommodityForwardEngine) DiscountingCommodityForwardEnginePtr;
class DiscountingCommodityForwardEnginePtr : public boost::shared_ptr<PricingEngine> {
public:
    %extend {
        DiscountingCommodityForwardEnginePtr(const QuantLib::Handle<PriceTermStructure>& priceCurve,
                                             const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                             boost::optional<bool> includeSettlementDateFlows = boost::none,
                                             const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DiscountingCommodityForwardEnginePtr(
                new DiscountingCommodityForwardEngine(priceCurve, 
                                                      discountCurve, 
                                                      includeSettlementDateFlows, 
                                                      npvDate));
        }
    }
};


#endif
