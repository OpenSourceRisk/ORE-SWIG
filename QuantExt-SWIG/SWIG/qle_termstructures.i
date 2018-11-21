/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include common.i
%include types.i
%include interestrate.i
%include date.i
%include calendars.i
%include daycounters.i
%include currencies.i
%include observer.i
%include marketelements.i
%include interpolation.i

%{
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
using QuantExt::FxBlackVannaVolgaVolatilitySurface;
using QuantExt::BlackVarianceSurfaceMoneynessSpot;
using QuantExt::BlackVarianceSurfaceMoneynessForward;

typedef boost::shared_ptr<BlackVolTermStructure> FxBlackVannaVolgaVolatilitySurfacePtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessSpotPtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessForwardPtr;
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

%template(RelinkablePriceTermStructureHandle) RelinkableHandle<PriceTermStructure>;

%define export_Interpolated_Price_Curve(Name, Interpolator)

%{
typedef boost::shared_ptr<PriceTermStructure> Name##Ptr;
%}

%warnfilter(509) Name##Ptr;

%rename(Name) Name##Ptr;
class Name##Ptr : public boost::shared_ptr<PriceTermStructure> {
  public:
    %extend {
        Name##Ptr(const std::vector<QuantLib::Time>& times,
                  const std::vector<QuantLib::Real>& prices, 
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(times, 
                                                         prices, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Time>& times,
                  const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(times, 
                                                         quotes, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Date>& dates,
                  const std::vector<QuantLib::Real>& prices,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(dates, 
                                                         prices, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Date>& dates,
                  const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(dates, 
                                                         quotes, 
                                                         dc));
        }
        const std::vector<QuantLib::Time>& times() const {
            return boost::dynamic_pointer_cast<InterpolatedPriceCurve<Interpolator>>(*self)->times();
        }
        const std::vector<QuantLib::Real>& prices() const {
            return  boost::dynamic_pointer_cast<InterpolatedPriceCurve<Interpolator>>(*self)->prices();
        }
    }
};

%enddef

export_Interpolated_Price_Curve(LinearInterpolatedPriceCurve, Linear);
export_Interpolated_Price_Curve(BackwardFlatInterpolatedPriceCurve, BackwardFlat);
export_Interpolated_Price_Curve(LogLinearInterpolatedPriceCurve, LogLinear);
export_Interpolated_Price_Curve(CubicInterpolatedPriceCurve, Cubic);
export_Interpolated_Price_Curve(SplineCubicInterpolatedPriceCurve, SplineCubic);
export_Interpolated_Price_Curve(MonotonicCubicInterpolatedPriceCurve, MonotonicCubic);

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


%rename(BlackVarianceSurfaceMoneynessSpot) BlackVarianceSurfaceMoneynessSpotPtr;
class BlackVarianceSurfaceMoneynessSpotPtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        BlackVarianceSurfaceMoneynessSpotPtr(const QuantLib::Calendar& cal, 
                                             const QuantLib::Handle<QuantLib::Quote>& spot, 
                                             const std::vector<QuantLib::Time>& times,
                                             const std::vector<QuantLib::Real>& moneyness,
                                             const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                             const QuantLib::DayCounter& dayCounter, 
                                             bool stickyStrike) {
            return new BlackVarianceSurfaceMoneynessSpotPtr(
                new BlackVarianceSurfaceMoneynessSpot(cal,
                                                      spot,
                                                      times,
                                                      moneyness,
                                                      blackVolMatrix,
                                                      dayCounter,
                                                      stickyStrike));
        }
    }
};

%rename(BlackVarianceSurfaceMoneynessForward) BlackVarianceSurfaceMoneynessForwardPtr;
class BlackVarianceSurfaceMoneynessForwardPtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        BlackVarianceSurfaceMoneynessForwardPtr(const QuantLib::Calendar& cal, 
                                                const QuantLib::Handle<QuantLib::Quote>& spot, 
                                                const std::vector<QuantLib::Time>& times,
                                                const std::vector<QuantLib::Real>& moneyness,
                                                const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                                const QuantLib::DayCounter& dayCounter, 
                                                const QuantLib::Handle<QuantLib::YieldTermStructure>& forTS,
                                                const QuantLib::Handle<QuantLib::YieldTermStructure>& domTS, 
                                                bool stickyStrike = false) {
            return new BlackVarianceSurfaceMoneynessForwardPtr(
                new BlackVarianceSurfaceMoneynessForward(cal,
                                                      spot,
                                                      times,
                                                      moneyness,
                                                      blackVolMatrix,
                                                      dayCounter,
                                                      forTS,
                                                      domTS,
                                                      stickyStrike));
        }
    }
};

#endif
