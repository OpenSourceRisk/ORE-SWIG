
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

%{
#include <boost/shared_ptr.hpp>
#include <boost/assert.hpp>
#include <boost/current_function.hpp>

#include <exception>
#include <sstream>
#include <string>
#include <map>
#include <vector>

#include <ql/errors.hpp>

#include <ored/portfolio/portfolio.hpp>
#include <ored/marketdata/marketimpl.hpp>
#include <ored/marketdata/todaysmarket.hpp>
  
using ore::data::Portfolio;
typedef boost::shared_ptr<ore::data::Portfolio> PortfolioPtr;

using ore::data::Market;
typedef boost::shared_ptr<ore::data::Market> MarketPtr;

using ore::data::MarketImpl;
typedef boost::shared_ptr<ore::data::MarketImpl> MarketImplPtr;

using ore::data::TodaysMarket;
typedef boost::shared_ptr<ore::data::MarketImpl> TodaysMarketPtr;

using ore::data::EngineFactory;
//typedef boost::shared_ptr<ore::data::EngineFactory> EngineFactoryPtr;

using ore::data::Trade;
//typedef boost::shared_ptr<ore::data::Trade> TradePtr;

using ore::data::TradeFactory;
//typedef boost::shared_ptr<ore::data::TradeFactory> TradeFactoryPtr;

using ore::data::InstrumentWrapper;
typedef boost::shared_ptr<ore::data::InstrumentWrapper> InstrumentWrapperPtr;

using ore::data::Envelope;

using ore::data::YieldCurveType;
using ore::data::TodaysMarketParameters;
using ore::data::Loader; 
using ore::data::CurveConfigurations; 

%}

%template(TradeVector) std::vector<boost::shared_ptr<ore::data::Trade>>;
%template(StringStringMap) std::map<std::string, std::string>;

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
    Handle<BaseCorrelationTermStructure<BilinearInterpolation>>
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

    // CPI Inflation Cap Floor Price Surfaces
    Handle<CPICapFloorTermPriceSurface>
      cpiInflationCapFloorPriceSurface(const std::string& indexName,
				       const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->cpiInflationCapFloorPriceSurface(indexName, configuration);
    }

    // YoY Inflation Cap Floor Price Surfaces
    Handle<YoYCapFloorTermPriceSurface>
      yoyInflationCapFloorPriceSurface(const std::string& indexName,
				       const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->yoyInflationCapFloorPriceSurface(indexName, configuration);
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
    Handle<Quote>
      commoditySpot(const std::string& commodityName, 
		    const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->commoditySpot(commodityName, configuration);      
    }

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

// EngineFactory just needed as a return type, no construction, no member functions.
%ignore EngineFactory;
class EngineFactory {
public:
};

%template(EngineFactory) boost::shared_ptr<ore::data::EngineFactory>;

// TradeFactory just needed as a return type, no construction, no member functions.
%ignore TradeFactory;
class TradeFactory {
public:
};

%template(TradeFactory) boost::shared_ptr<ore::data::TradeFactory>;

// Envelope is not wrapped into a pointer, because we pass it around in ORE as reference
class Envelope {
public:
    const std::string& counterparty() const;
    const std::string& nettingSetId() const;
    const std::map<std::string, std::string>& additionalFields() const;
};

// InstrumentWrapper pointer required as a return type only
%rename(InstrumentWrapper) InstrumentWrapperPtr;
class InstrumentWrapperPtr {
public:
  %extend {
    Real NPV() const {
      return boost::dynamic_pointer_cast<ore::data::InstrumentWrapper>(*self)->NPV();
    }
  }
};

// Trade pointer required as a return type only
%ignore Trade;
class Trade {
public:
    const std::string& id();
    const std::string& tradeType();
    const boost::shared_ptr<InstrumentWrapper>& instrument();
    std::vector<std::vector<boost::shared_ptr<QuantLib::CashFlow>>> legs();
    const Envelope& envelope() const;
    const QuantLib::Date& maturity();
    Real notional();
};

%template(Trade) boost::shared_ptr<ore::data::Trade>;

// Portfolio
%rename(Portfolio) PortfolioPtr;
class PortfolioPtr {
public:
  %extend {
    PortfolioPtr() {
      return new PortfolioPtr(new ore::data::Portfolio());
    }
    std::size_t size() const {
      return boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->size();
    }
    std::vector<std::string> ids() const {
      return boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->ids();
    }
    const std::vector<boost::shared_ptr<Trade>>& trades() const {
      return boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->trades();      
    }
    bool remove(const std::string& tradeID) {
      return boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->remove(tradeID);            
    }
    void load(const std::string& fileName,
              const boost::shared_ptr<TradeFactory>& tf = boost::make_shared<TradeFactory>()) {
      boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->load(fileName, tf);            
    }
    void loadFromXMLString(const std::string& xmlString,
                           const boost::shared_ptr<ore::data::TradeFactory>& tf = boost::make_shared<TradeFactory>()) {
      boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->loadFromXMLString(xmlString, tf);                  
    }
    //void build(const boost::shared_ptr<ore::data::EngineFactory>& factory, std::string tradeID = "");
    void build(const boost::shared_ptr<ore::data::EngineFactory>& factory) {
      boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->build(factory);                  
    }
  }
};

///////////////////////////////////////////////////////////////////////////////////////////////

/* class CSVFileReader { */
/* public: */
/*     CSVFileReader(const std::string& fileName, const bool firstLineContainsHeaders, */
/*                   const std::string& delimiters = ",;\t", const char eolMarker = '\n'); */
/*     const std::vector<std::string>& fields() const; */
/*     bool hasField(const std::string& field) const; */
/*     Size numberOfColumns() const; */
/*     bool next(); */
/*     Size currentLine() const; */
/*     std::string get(const std::string& field) const; */
/*     std::string get(const Size column) const; */
/*     void close(); */
/* }; */
