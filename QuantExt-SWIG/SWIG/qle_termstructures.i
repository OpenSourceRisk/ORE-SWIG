/*
 Copyright (C) 2018, 2020 Quaternion Risk Management Ltd
 All rights reserved.

 This file is part of ORE, a free-software/open-source library
 for transparent pricing and risk analysis - http://opensourcerisk.org

 ORE is free software: you can redistribute it and/or modify it
 under the terms of the Modified BSD License.  You should have received a
 copy of the license along with this program.
 The license is also available online at <http://opensourcerisk.org>

 This program is distributed on the basis that it will form a useful
 contribution to risk analytics and model standardisation, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the license for more details.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include termstructures.i
%include volatilities.i
%include indexes.i
%include currencies.i

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
using QuantExt::SwapConventions;
using QuantExt::SwaptionVolatilityConverter;
using QuantExt::BlackVolatilityWithATM;
%}

%shared_ptr(PriceTermStructure)
class PriceTermStructure : public TermStructure {
  private:
    PriceTermStructure();
  public:
    QuantLib::Real price(QuantLib::Time t, bool extrapolate = false) const;
    QuantLib::Real price(const QuantLib::Date& d, bool extrapolate = false) const;
};

%template(PriceTermStructureHandle) Handle<PriceTermStructure>;
%template(RelinkablePriceTermStructureHandle) RelinkableHandle<PriceTermStructure>;

%define export_Interpolated_Price_Curve(Name, Interpolator)

%{
typedef InterpolatedPriceCurve<Interpolator> Name;
%}

%warnfilter(509) Name;

%shared_ptr(Name)
class Name : public PriceTermStructure {
  public:
    Name(const std::vector<QuantLib::Period>& tenors,
	 const std::vector<QuantLib::Real>& prices,
	 const QuantLib::DayCounter& dc,
	 const QuantLib::Currency& currency);
    Name(const std::vector<QuantLib::Period>& tenors,
	 const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
	 const QuantLib::DayCounter& dc,
	 const QuantLib::Currency& currency);
    Name(const QuantLib::Date& referenceDate,
	 const std::vector<QuantLib::Date>& dates,
	 const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
	 const QuantLib::DayCounter& dc,
	 const QuantLib::Currency& currency);
    Name(const QuantLib::Date& referenceDate,
	 const std::vector<QuantLib::Date>& dates,
	 const std::vector<QuantLib::Real>& prices,
	 const QuantLib::DayCounter& dc,
	 const QuantLib::Currency& currency);
    const std::vector<QuantLib::Time>& times() const;
    const std::vector<QuantLib::Real>& prices() const;
};

%enddef

export_Interpolated_Price_Curve(LinearInterpolatedPriceCurve, Linear);
export_Interpolated_Price_Curve(BackwardFlatInterpolatedPriceCurve, BackwardFlat);
export_Interpolated_Price_Curve(LogLinearInterpolatedPriceCurve, LogLinear);
export_Interpolated_Price_Curve(CubicInterpolatedPriceCurve, Cubic);
export_Interpolated_Price_Curve(SplineCubicInterpolatedPriceCurve, SplineCubic);
export_Interpolated_Price_Curve(MonotonicCubicInterpolatedPriceCurve, MonotonicCubic);


%shared_ptr(SwaptionVolatilityCube)
class SwaptionVolatilityCube : public SwaptionVolatilityDiscrete {
};

%{
using QLESwaptionVolCube2 = QuantExt::SwaptionVolCube2;
%}

%shared_ptr(QLESwaptionVolCube2)
class QLESwaptionVolCube2 : public SwaptionVolatilityCube {
  public:
    QLESwaptionVolCube2(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVolStructure,
                        const std::vector<QuantLib::Period>& optionTenors,
                        const std::vector<QuantLib::Period>& swapTenors,
                        const std::vector<QuantLib::Spread>& strikeSpreads,
                        const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& volSpreads,
                        const boost::shared_ptr<SwapIndex>& swapIndexBase,
                        const boost::shared_ptr<SwapIndex>& shortSwapIndexBase,
                        bool vegaWeightedSmileFit,
                        bool flatExtrapolation,
                        bool volsAreSpreads = true);
};


%shared_ptr(FxBlackVannaVolgaVolatilitySurface)
class FxBlackVannaVolgaVolatilitySurface : public BlackVolTermStructure {
  public:
    FxBlackVannaVolgaVolatilitySurface(const QuantLib::Date& refDate,
                                       const std::vector<QuantLib::Date>& dates,
                                       const std::vector<QuantLib::Volatility>& atmVols,
                                       const std::vector<QuantLib::Volatility>& rr25d,
                                       const std::vector<QuantLib::Volatility>& bf25d,
                                       const QuantLib::DayCounter& dc,
                                       const QuantLib::Calendar& cal,
                                       const QuantLib::Handle<QuantLib::Quote>& fx,
                                       const QuantLib::Handle<QuantLib::YieldTermStructure>& dom,
                                       const QuantLib::Handle<QuantLib::YieldTermStructure>& fore);
};



%shared_ptr(BlackVarianceSurfaceMoneynessSpot)
class BlackVarianceSurfaceMoneynessSpot : public BlackVolTermStructure {
  public:
    BlackVarianceSurfaceMoneynessSpot(const QuantLib::Calendar& cal,
                                      const QuantLib::Handle<QuantLib::Quote>& spot,
                                      const std::vector<QuantLib::Time>& times,
                                      const std::vector<QuantLib::Real>& moneyness,
                                      const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                      const QuantLib::DayCounter& dayCounter,
                                      bool stickyStrike);
};

%shared_ptr(BlackVarianceSurfaceMoneynessForward)
class BlackVarianceSurfaceMoneynessForward : public BlackVolTermStructure {
  public:
    BlackVarianceSurfaceMoneynessForward(const QuantLib::Calendar& cal,
                                         const QuantLib::Handle<QuantLib::Quote>& spot,
                                         const std::vector<QuantLib::Time>& times,
                                         const std::vector<QuantLib::Real>& moneyness,
                                         const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                         const QuantLib::DayCounter& dayCounter,
                                         const QuantLib::Handle<QuantLib::YieldTermStructure>& forTS,
                                         const QuantLib::Handle<QuantLib::YieldTermStructure>& domTS,
                                         bool stickyStrike = false);
};


%shared_ptr(SwaptionVolCubeWithATM)
class SwaptionVolCubeWithATM : public SwaptionVolatilityStructure {
  public:
    SwaptionVolCubeWithATM(const boost::shared_ptr<SwaptionVolatilityCube>& cube);
};

%shared_ptr(SwaptionVolatilityConstantSpread)
class SwaptionVolatilityConstantSpread : public SwaptionVolatilityStructure {
  public:
    SwaptionVolatilityConstantSpread(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atm,
                                     const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube);
    const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVol();
    const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube();
};

%shared_ptr(SwapConventions)
class SwapConventions {
  public:
    SwapConventions(QuantLib::Natural settlementDays, const QuantLib::Period& fixedTenor,
                    const QuantLib::Calendar& fixedCalendar, QuantLib::BusinessDayConvention fixedConvention,
                    const QuantLib::DayCounter& fixedDayCounter,
                    const boost::shared_ptr<IborIndex> floatIndex);
    QuantLib::Natural settlementDays() const;
    const QuantLib::Period& fixedTenor() const;
    const QuantLib::Calendar& fixedCalendar() const;
    QuantLib::BusinessDayConvention fixedConvention() const;
    const QuantLib::DayCounter& fixedDayCounter() const;
    const boost::shared_ptr<IborIndex> floatIndex() const;
};

%shared_ptr(SwaptionVolatilityConverter)
class SwaptionVolatilityConverter {
  public:
    SwaptionVolatilityConverter(const QuantLib::Date& asof,
                                const boost::shared_ptr<QuantLib::SwaptionVolatilityStructure>& svsIn,
                                const QuantLib::Handle<QuantLib::YieldTermStructure>& discount,
                                const QuantLib::Handle<QuantLib::YieldTermStructure>& shortDiscount,
                                const boost::shared_ptr<SwapConventions>& conventions,
                                const boost::shared_ptr<SwapConventions>& shortConventions,
                                const QuantLib::Period& conventionsTenor,
                                const QuantLib::Period& shortConventionsTenor,
                                const QuantLib::VolatilityType targetType,
                                const QuantLib::Matrix& targetShifts = QuantLib::Matrix());
    SwaptionVolatilityConverter(const QuantLib::Date& asof,
                                const boost::shared_ptr<QuantLib::SwaptionVolatilityStructure>& svsIn,
                                const boost::shared_ptr<QuantLib::SwapIndex>& swapIndex,
                                const boost::shared_ptr<QuantLib::SwapIndex>& shortSwapIndex,
                                const QuantLib::VolatilityType targetType,
                                const QuantLib::Matrix& targetShifts = QuantLib::Matrix());
    boost::shared_ptr<QuantLib::SwaptionVolatilityStructure> convert() const;
    QuantLib::Real& accuracy();
    QuantLib::Natural& maxEvaluations();
};

%shared_ptr(BlackVolatilityWithATM)
class BlackVolatilityWithATM : public BlackVolTermStructure {
  public:
    BlackVolatilityWithATM(const boost::shared_ptr<QuantLib::BlackVolTermStructure>& surface,
                           const QuantLib::Handle<QuantLib::Quote>& spot,
                           const QuantLib::Handle<QuantLib::YieldTermStructure>& yield1,
                           const QuantLib::Handle<QuantLib::YieldTermStructure>& yield2);
    QuantLib::DayCounter dayCounter() const;
    QuantLib::Date maxDate() const;
    QuantLib::Time maxTime() const;
    const QuantLib::Date& referenceDate() const;
    QuantLib::Calendar calendar() const;
    QuantLib::Natural settlementDays() const;
    QuantLib::Rate minStrike() const;
    QuantLib::Rate maxStrike() const;
};

#endif
