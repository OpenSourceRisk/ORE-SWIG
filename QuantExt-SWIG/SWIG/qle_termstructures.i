/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include termstructures.i
%include volatilities.i

%{
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
using QuantExt::FxBlackVannaVolgaVolatilitySurface;
using QuantExt::BlackVarianceSurfaceMoneynessSpot;
using QuantExt::BlackVarianceSurfaceMoneynessForward;
//using QuantExt::SwaptionVolCube2;
using QuantExt::SwaptionVolCubeWithATM;
using QuantLib::SwaptionVolatilityCube;
using QuantExt::SwaptionVolatilityConstantSpread;

typedef boost::shared_ptr<BlackVolTermStructure> FxBlackVannaVolgaVolatilitySurfacePtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessSpotPtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessForwardPtr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> QLESwaptionVolCube2Ptr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> SwaptionVolCubeWithATMPtr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> SwaptionVolatilityConstantSpreadPtr;
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

%rename(QLESwaptionVolCube2) QLESwaptionVolCube2Ptr;
class QLESwaptionVolCube2Ptr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        QLESwaptionVolCube2Ptr(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVolStructure,
                               const std::vector<QuantLib::Period>& optionTenors, 
                               const std::vector<QuantLib::Period>& swapTenors,
                               const std::vector<QuantLib::Spread>& strikeSpreads,
                               const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& volSpreads,
                               const SwapIndexPtr& swapIndexBase,
                               const SwapIndexPtr& shortSwapIndexBase, 
                               bool vegaWeightedSmileFit,
                               bool flatExtrapolation, 
                               bool volsAreSpreads = true) {
            const boost::shared_ptr<SwapIndex> swi = boost::dynamic_pointer_cast<SwapIndex>(swapIndexBase);
            const boost::shared_ptr<SwapIndex> shortSwi = boost::dynamic_pointer_cast<SwapIndex>(shortSwapIndexBase);
            return new QLESwaptionVolCube2Ptr(
                new QuantExt::SwaptionVolCube2(atmVolStructure,
                                               optionTenors,
                                               swapTenors,
                                               strikeSpreads,
                                               volSpreads,
                                               swi,
                                               shortSwi,
                                               vegaWeightedSmileFit,
                                               flatExtrapolation,
                                               volsAreSpreads));
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


%rename(SwaptionVolCubeWithATM) SwaptionVolCubeWithATMPtr;
class SwaptionVolCubeWithATMPtr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        SwaptionVolCubeWithATMPtr(const boost::shared_ptr<SwaptionVolatilityStructure>& cube) {
            const boost::shared_ptr<QuantLib::SwaptionVolatilityCube> volCube
                = boost::dynamic_pointer_cast<QuantLib::SwaptionVolatilityCube>(cube);
            return new SwaptionVolCubeWithATMPtr(
                new SwaptionVolCubeWithATM(volCube));
        }
    }
};

%rename(SwaptionVolatilityConstantSpread) SwaptionVolatilityConstantSpreadPtr;
class SwaptionVolatilityConstantSpreadPtr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        SwaptionVolatilityConstantSpreadPtr(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atm,
                                            const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube) {
            return new SwaptionVolatilityConstantSpreadPtr(
                new SwaptionVolatilityConstantSpread(atm, cube));
        }
        const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVol() {
            return  boost::dynamic_pointer_cast<SwaptionVolatilityConstantSpread>(*self)->atmVol();
        }
        const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube() {
            return  boost::dynamic_pointer_cast<SwaptionVolatilityConstantSpread>(*self)->cube();
        }
    }
};

#endif
