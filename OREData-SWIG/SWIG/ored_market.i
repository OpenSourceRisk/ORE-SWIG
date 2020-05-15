
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_market_i
#define ored_market_i

%include ored_conventions.i

%{
using ore::data::Market;
typedef boost::shared_ptr<ore::data::Market> MarketPtr;
using ore::data::MarketImpl;
typedef boost::shared_ptr<ore::data::MarketImpl> MarketImplPtr;
using ore::data::TodaysMarket;
typedef boost::shared_ptr<ore::data::MarketImpl> TodaysMarketPtr;

using ore::data::YieldCurveType;
using ore::data::TodaysMarketParameters;
using ore::data::Loader; 
using ore::data::CurveConfigurations;
%}

// Market class passed around as pointer, no construction
%rename(MarketImpl) MarketImplPtr;
class MarketImplPtr {
 public:
  %extend {
    MarketImplPtr() {
      return new MarketImplPtr(new ore::data::MarketImpl());
    }
    Date asofDate() const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->asofDate();
    }

    // Yield curves
    Handle<YieldTermStructure> yieldCurve(const YieldCurveType& type, const std::string& name,
                      const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->yieldCurve(type, name, configuration);
    }
    Handle<YieldTermStructure> yieldCurve(const std::string& name,
                                          const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->yieldCurve(name, configuration);
    }
    Handle<YieldTermStructure> discountCurve(const std::string& ccy,
                              const std::string& configuration = Market::defaultConfiguration) const { 
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->discountCurve(ccy, configuration);       
    }
    
    // Return IborIndexPtr rather than Handle (FIXME?)
    IborIndexPtr iborIndex(const std::string& indexName,
               const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->iborIndex(indexName, configuration).currentLink();
    }
    // Return SwapIndexPtr rather than Handle (FIXME?)
    SwapIndexPtr swapIndex(const std::string& indexName,
               const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->swapIndex(indexName, configuration).currentLink();  
    }

    // Swaptions
    Handle<QuantLib::SwaptionVolatilityStructure>
      swaptionVol(const std::string& ccy, const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->swaptionVol(ccy, configuration);
    }
    const std::string shortSwapIndexBase(const std::string& ccy,
                     const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->shortSwapIndexBase(ccy, configuration);
    }
    const std::string swapIndexBase(const std::string& ccy,
                    const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->swapIndexBase(ccy, configuration);
    }

    // FX
    Handle<Quote> fxSpot(const std::string& ccypair,
             const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->fxSpot(ccypair, configuration);
    }
    Handle<BlackVolTermStructure> fxVol(const std::string& ccypair,
                                        const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->fxVol(ccypair, configuration);
    }

    // Default Curves and Recovery Rates
    Handle<DefaultProbabilityTermStructure>
      defaultCurve(const std::string& name,
           const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->defaultCurve(name, configuration);
    }
    Handle<Quote> recoveryRate(const std::string& name,
                   const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->recoveryRate(name, configuration);
    }

    // CDS volatilities
    Handle<BlackVolTermStructure> cdsVol(const std::string& name,
                                         const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->cdsVol(name, configuration);
    }

    // Base correlation structures
    Handle<QuantLib::BaseCorrelationTermStructure<QuantLib::BilinearInterpolation>>
      baseCorrelation(const std::string& name,
              const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->baseCorrelation(name, configuration);
    }

    // CapFloor volatilities
    Handle<OptionletVolatilityStructure>
      capFloorVol(const std::string& ccy,
          const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->capFloorVol(ccy, configuration);
    }
   
    // YoY Inflation CapFloor volatilities
    Handle<QuantExt::YoYOptionletVolatilitySurface>
      yoyCapFloorVol(const std::string& ccy,
             const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->yoyCapFloorVol(ccy, configuration);
    }

    // Inflation Indexes (Pointer rather than Handle)
    ZeroInflationIndexPtr
      zeroInflationIndex(const std::string& indexName,
             const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->zeroInflationIndex(indexName, configuration).currentLink();      
    }
    YoYInflationIndexPtr
      yoyInflationIndex(const std::string& indexName,
            const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->yoyInflationIndex(indexName, configuration).currentLink();      
    }

    // Inflation Cap Floor Volatility Surfaces
    Handle<QuantLib::CPIVolatilitySurface>
      cpiInflationCapFloorVolatilitySurface(const std::string& indexName,
					    const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->cpiInflationCapFloorVolatilitySurface(indexName, configuration);
    }

    // Cpi Base Quotes
    Handle<QuantExt::InflationIndexObserver>
      baseCpis(const std::string& index,
           const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->baseCpis(index, configuration);
    }

    // Equity curves
    Handle<Quote>
      equitySpot(const std::string& eqName,
         const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->equitySpot(eqName, configuration);
    }
    Handle<QuantExt::EquityIndex>
      equityCurve(const std::string& eqName, const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->equityCurve(eqName, configuration);
    }
    Handle<YieldTermStructure>
      equityDividendCurve(const std::string& eqName,
              const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->equityDividendCurve(eqName, configuration);
    }

    // Equity volatilities
    Handle<BlackVolTermStructure>
      equityVol(const std::string& eqName,
        const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->equityVol(eqName, configuration);
    }

    // Equity forecasting curves
    Handle<YieldTermStructure>
      equityForecastCurve(const std::string& eqName,
              const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->equityForecastCurve(eqName, configuration);
    }

    // Bond Spreads
    Handle<Quote>
      securitySpread(const std::string& securityID,
             const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->securitySpread(securityID, configuration);      
    }

    // Commodity curves
    Handle<QuantExt::PriceTermStructure>
      commodityPriceCurve(const std::string& commodityName,
              const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->commodityPriceCurve(commodityName, configuration);
    }

    Handle<BlackVolTermStructure>
      commodityVolatility(const std::string& commodityName,
              const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->commodityVolatility(commodityName, configuration);
    }

    Handle<QuantExt::CorrelationTermStructure>
      correlationCurve(const std::string& index1, const std::string& index2,
		       const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->correlationCurve(index1, index2, configuration);
    }
    
  }
};

%rename(TodaysMarket) TodaysMarketPtr;
class TodaysMarketPtr : public MarketImplPtr {
 public:
  %extend {
    TodaysMarketPtr(const Date& asof,
            const TodaysMarketParameters& params,
            const Loader& loader,
            const CurveConfigurations& curveConfigs,
            const Conventions& conventions) {
      return new TodaysMarketPtr(new ore::data::TodaysMarket(asof, params, loader, curveConfigs, conventions));
    }
  }
};


#endif
