/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_commodityforward_i
#define qle_commodityforward_i

%include instruments.i
%include currencies.i
%include fra.i
%include termstructures.i

%{
using QuantExt::CommodityForward;
using QuantExt::DiscountingCommodityForwardEngine;
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
typedef boost::shared_ptr<Instrument> CommodityForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingCommodityForwardEnginePtr;
typedef boost::shared_ptr<PriceTermStructure> PriceCurvePtr;
%}

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

%ignore PriceTermStructure;
class PriceTermStructure : public Extrapolator {
 public:
  QuantLib::Real price(QuantLib::Time t, bool extrapolate = false) const;
  QuantLib::Real price(const QuantLib::Date& d, bool extrapolate = false) const;
};

%template(PriceTermStructure) boost::shared_ptr<PriceTermStructure>;
IsObservable(boost::shared_ptr<PriceTermStructure>);

%template(PriceTermStructureHandle) Handle<PriceTermStructure>;
IsObservable(Handle<PriceTermStructure>);
%template(RelinkablePriceTermStructureHandle)
RelinkableHandle<PriceTermStructure>;

// This is an InterpolatedPriceCurve with Linear interpolation
// FIXME: See termstructures.i and generalize
%rename(PriceCurve) PriceCurvePtr;
class PriceCurvePtr : public boost::shared_ptr<PriceTermStructure> {
  public:
    %extend {
        PriceCurvePtr(const std::vector<QuantLib::Time>& times,
		      const std::vector<QuantLib::Real>& prices, 
		      const QuantLib::DayCounter& dc) {
	  return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(times, prices, dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Time>& times,
		      const std::vector<QuantLib::Handle<QuantLib::Quote> >& quotes,
		      const QuantLib::DayCounter& dc) {
	  return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(times, quotes, dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Date>& dates,
		      const std::vector<QuantLib::Real>& prices,
		      const QuantLib::DayCounter& dc) {
	  return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(dates, prices, dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Date>& dates,
		      const std::vector<QuantLib::Handle<QuantLib::Quote> >& quotes,
		      const QuantLib::DayCounter& dc) {
	  return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(dates, quotes, dc));
        }
	const std::vector<QuantLib::Time>& times() const {
	  return boost::dynamic_pointer_cast<InterpolatedPriceCurve<Linear> >(*self)->times();
	}
        const std::vector<QuantLib::Real>& prices() const {
	  return  boost::dynamic_pointer_cast<InterpolatedPriceCurve<Linear> >(*self)->prices();
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
                new DiscountingCommodityForwardEngine(priceCurve, discountCurve, includeSettlementDateFlows, npvDate));
        }
    }
};


#endif
