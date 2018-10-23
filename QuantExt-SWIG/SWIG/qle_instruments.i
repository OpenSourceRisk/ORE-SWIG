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
typedef boost::shared_ptr<Instrument> CrossCcyBasisSwapPtr;

using QuantExt::CommodityForward;
typedef boost::shared_ptr<Instrument> CommodityForwardPtr;

using QuantExt::DiscountingCommodityForwardEngine;
typedef boost::shared_ptr<PricingEngine> DiscountingCommodityForwardEnginePtr;

%}

%rename(CrossCcyBasisSwap) CrossCcyBasisSwapPtr;
class CrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
 public:
  %extend {
    CrossCcyBasisSwapPtr(Real payNominal,
			 const Currency& payCurrency,
			 const Schedule& paySchedule,
			 const IborIndexPtr& payIndex,
			 Spread paySpread,
			 Real recNominal,
			 const Currency& recCurrency,
			 const Schedule& recSchedule,
			 const IborIndexPtr& recIndex,
			 Spread recSpread) {
      boost::shared_ptr<IborIndex> payIbor =
	boost::dynamic_pointer_cast<IborIndex>(payIndex);
      boost::shared_ptr<IborIndex> recIbor =
	boost::dynamic_pointer_cast<IborIndex>(recIndex);
      return new CrossCcyBasisSwapPtr(new CrossCcyBasisSwap(payNominal, payCurrency, paySchedule, payIbor, paySpread, recNominal, recCurrency, recSchedule, recIbor, recSpread));
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
        CommodityForwardPtr(const std::string& name, const QuantLib::Currency& currency,
                            QuantLib::Position::Type position, QuantLib::Real quantity,
                            const QuantLib::Date& maturityDate, QuantLib::Real strike) {
            return new CommodityForwardPtr(
                new CommodityForward(name, currency, position, quantity, maturityDate, strike));
        }

        const std::string& name() const { return boost::dynamic_pointer_cast<CommodityForward>(*self)->name(); }

        const QuantLib::Currency& currency() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->currency();
        }

        QuantLib::Position::Type position() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->position();
        }

        QuantLib::Real quantity() const { return boost::dynamic_pointer_cast<CommodityForward>(*self)->quantity(); }

        const QuantLib::Date& maturityDate() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->maturityDate();
        }

        QuantLib::Real strike() const { return boost::dynamic_pointer_cast<CommodityForward>(*self)->strike(); }
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
                new DiscountingCommodityForwardEngine(priceCurve, discountCurve, includeSettlementDateFlows, npvDate));
        }
    }
};


#endif
