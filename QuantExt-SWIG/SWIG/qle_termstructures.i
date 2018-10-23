/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include termstructures.i

%{
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
typedef boost::shared_ptr<PriceTermStructure> PriceCurvePtr;
%}

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

#endif
