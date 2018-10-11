
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

#include <orea/app/oreapp.hpp>
  
using ore::analytics::Parameters;
typedef boost::shared_ptr<ore::analytics::Parameters> ParametersPtr;

using ore::analytics::OREApp;
typedef boost::shared_ptr<ore::analytics::OREApp> OREAppPtr;

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

%}

%template(TradeVector) std::vector<boost::shared_ptr<ore::data::Trade>>;
%template(StringStringMap) std::map<std::string, std::string>;

// ORE Analytics

%rename(Parameters) ParametersPtr;
class ParametersPtr {
public:
  %extend {
    ParametersPtr() {
      return new ParametersPtr(new ore::analytics::Parameters());
    }
    void clear() {
      boost::dynamic_pointer_cast<ore::analytics::Parameters>(*self)->clear();
    }
    void fromFile(const std::string& name) {
      boost::dynamic_pointer_cast<ore::analytics::Parameters>(*self)->fromFile(name);
    }
    bool hasGroup(const std::string& groupName) const {
      return boost::dynamic_pointer_cast<ore::analytics::Parameters>(*self)->hasGroup(groupName);
    }
    bool has(const std::string& groupName, const std::string& paramName) const {
      return boost::dynamic_pointer_cast<ore::analytics::Parameters>(*self)->has(groupName, paramName);
    }
    std::string get(const std::string& groupName, const std::string& paramName) const {
      return boost::dynamic_pointer_cast<ore::analytics::Parameters>(*self)->get(groupName, paramName);
    }
    //TODO: add this function to ORE, then add here
    //void add(const std::string& groupName, const std::string& paramName, const std::string& paramValue);
}
};

%rename(OREApp) OREAppPtr;
class OREAppPtr {
public:
  %extend {
    OREAppPtr(const ParametersPtr& p, std::ostream& out = std::cout) {
      boost::shared_ptr<ore::analytics::Parameters> param = boost::dynamic_pointer_cast<ore::analytics::Parameters>(p);
      return new OREAppPtr(new OREApp(param, out));
    }
    void run() {
      boost::dynamic_pointer_cast<ore::analytics::OREApp>(*self)->run();
    }
  }
};

// Market base class passed around as pointer, no construction
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
    // Note the difference to ORE in return type (FIXME?)
    IborIndexPtr iborIndex(const std::string& indexName,
					   const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->iborIndex(indexName, configuration).currentLink();       
    }
    // Note the difference to ORE in return type (FIXME?)
    SwapIndexPtr swapIndex(const std::string& indexName,
                                const std::string& configuration = Market::defaultConfiguration) const {
      return boost::dynamic_pointer_cast<ore::data::MarketImpl>(*self)->swapIndex(indexName, configuration).currentLink();             
    }
    // TODO: Extend interface
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
// TODOs

// clang-format off
/* %nodefaultctor DateGrid; */
/* // clang-format on */
/* class DateGrid { */
/* public: */
/*     const std::vector<QuantLib::Date>& dates() const; */
/* }; */

/* // clang-format off */
/* %nodefaultctor FixingManager; */
/* // clang-format on */
/* class FixingManager { */
/* public: */
/*     void initialise(const boost::shared_ptr<ore::data::Portfolio>& portfolio); */
/*     //void updateInitialisation(const boost::shared_ptr<ore::data::Trade>& trade); */
/*     void reset(); */
/*     void update(QuantLib::Date date); */
/* }; */

/* // clang-format off */
/* %nodefaultctor ScenarioSimMarket; */
/* // clang-format on */
/* class ScenarioSimMarket : public ore::data::Market { */
/* public: */
/*     void update(const QuantLib::Date& d); */
/*     const boost::shared_ptr<ore::analytics::FixingManager>& fixingManager() const; */
/* }; */

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
