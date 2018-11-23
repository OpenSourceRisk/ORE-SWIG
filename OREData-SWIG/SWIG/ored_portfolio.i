
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_portfolio_i
#define ored_portfolio_i

%include cashflows.i

%{
using ore::data::Portfolio;
typedef boost::shared_ptr<ore::data::Portfolio> PortfolioPtr;


using ore::data::EngineFactory;
//typedef boost::shared_ptr<ore::data::EngineFactory> EngineFactoryPtr;

using ore::data::Trade;
//typedef boost::shared_ptr<ore::data::Trade> TradePtr;

using ore::data::TradeFactory;
//typedef boost::shared_ptr<ore::data::TradeFactory> TradeFactoryPtr;

using ore::data::InstrumentWrapper;
typedef boost::shared_ptr<ore::data::InstrumentWrapper> InstrumentWrapperPtr;

using ore::data::Envelope;


using QuantLib::CashFlow;

using namespace std;
%}

%template(TradeVector) std::vector<boost::shared_ptr<Trade>>;
%template(LegVector) std::vector<std::vector<boost::shared_ptr<CashFlow> > >;
typedef std::vector<std::vector<boost::shared_ptr<QuantLib::CashFlow> > > LegVector;
%template(StringStringMap) std::map<std::string, std::string>;


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
    boost::shared_ptr<QuantLib::Instrument> qlInstrument() const {
        return boost::dynamic_pointer_cast<ore::data::InstrumentWrapper>(*self)->qlInstrument();
    }
  }
};

// Trade pointer required as a return type only
%ignore Trade;
class Trade {
public:
    const std::string& id();
    const std::string& tradeType();
    const InstrumentWrapperPtr& instrument();
    std::vector<std::vector<boost::shared_ptr<QuantLib::CashFlow>>> legs();
    const Envelope& envelope() const;
    const QuantLib::Date& maturity();
    Real notional();
};
%template(Trade) boost::shared_ptr<Trade>;


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
    void build(const boost::shared_ptr<ore::data::EngineFactory>& factory) {
      boost::dynamic_pointer_cast<ore::data::Portfolio>(*self)->build(factory);                  
    }
  }
};

#endif