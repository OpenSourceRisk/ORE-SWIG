/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include termstructures.i

%include common.i
%include date.i
%include daycounters.i
%include types.i
%include currencies.i
%include observer.i
%include marketelements.i
%include interpolation.i
%include indexes.i
%include optimizers.i
%include options.i
%include volatilities.i

%{
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
using QuantExt::FxBlackVannaVolgaVolatilitySurface;

typedef boost::shared_ptr<PriceTermStructure> PriceCurvePtr;
typedef boost::shared_ptr<BlackVolTermStructure> FxBlackVannaVolgaVolatilitySurfacePtr;
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
                new InterpolatedPriceCurve<Linear>(times, 
                                                   prices, 
                                                   dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Time>& times,
                      const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
                      const QuantLib::DayCounter& dc) {
            return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(times, 
                                                   quotes, 
                                                   dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Date>& dates,
                      const std::vector<QuantLib::Real>& prices,
                      const QuantLib::DayCounter& dc) {
            return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(dates, 
                                                   prices, 
                                                   dc));
        }
        PriceCurvePtr(const std::vector<QuantLib::Date>& dates,
                      const std::vector<QuantLib::Handle<QuantLib::Quote> >& quotes,
                      const QuantLib::DayCounter& dc) {
            return new PriceCurvePtr(
                new InterpolatedPriceCurve<Linear>(dates, 
                                                   quotes, 
                                                   dc));
        }
        const std::vector<QuantLib::Time>& times() const {
            return boost::dynamic_pointer_cast<InterpolatedPriceCurve<Linear> >(*self)->times();
        }
        const std::vector<QuantLib::Real>& prices() const {
            return  boost::dynamic_pointer_cast<InterpolatedPriceCurve<Linear> >(*self)->prices();
        }
    }
};

%rename(FxBlackVannaVolgaVolatilitySurface) FxBlackVannaVolgaVolatilitySurfacePtr;
class FxBlackVannaVolgaVolatilitySurfacePtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        FxBlackVannaVolgaVolatilitySurfacePtr(const QuantLib::Date& refDate, 
                                              const std::vector<QuantLib::Date>& dates,
                                              const std::vector<QuantLib::Volatility>& atmVols, 
                                              const std::vector<QuantLib::Volatility>& rr25d,
                                              const std::vector<QuantLib::Volatility>& bf25d, 
                                              const QuantLib::DayCounter& dc, 
                                              const QuantLib::Calendar& cal,
                                              const QuantLib::Handle<QuantLib::Quote>& fx, 
                                              const QuantLib::Handle<QuantLib::YieldTermStructure>& dom,
                                              const QuantLib::Handle<QuantLib::YieldTermStructure>& fore) {
            return new FxBlackVannaVolgaVolatilitySurfacePtr(
                new FxBlackVannaVolgaVolatilitySurface(refDate,
                                                       dates,
                                                       atmVols,
                                                       rr25d,
                                                       bf25d,
                                                       dc,
                                                       cal,
                                                       fx,
                                                       dom,
                                                       fore));
        }
    }
};

#endif
