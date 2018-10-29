
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

#ifdef BOOST_MSVC 
#define BOOST_LIB_NAME boost_regex
#include <boost/config/auto_link.hpp>
#define BOOST_LIB_NAME boost_serialization
#include <boost/config/auto_link.hpp>
#define BOOST_LIB_NAME boost_date_time
#include <boost/config/auto_link.hpp>
#define BOOST_LIB_NAME boost_filesystem
#include <boost/config/auto_link.hpp>
#define BOOST_LIB_NAME boost_system
#include <boost/config/auto_link.hpp>
#endif

#include <ql/errors.hpp>

#include <orepapp/orea/app/oreplusapp.hpp>
#include <orepapp/auto_link.hpp>


using oreplus::analytics::OREPlusApp;
typedef boost::shared_ptr<oreplus::analytics::OREPlusApp> OREPlusAppPtr;

using ore::analytics::OREApp;
typedef boost::shared_ptr<ore::analytics::OREApp> OREAppPtr;

using ore::analytics::Parameters;
typedef boost::shared_ptr<ore::analytics::Parameters> ParametersPtr;

using ore::data::MarketImpl;
typedef boost::shared_ptr<ore::data::MarketImpl> MarketImplPtr;

%}

%rename(ORE) OREPlusAppPtr;
class OREPlusAppPtr : public OREAppPtr {
public:
  %extend {
    OREPlusAppPtr(const ParametersPtr& p, std::ostream& out = std::cout) {
      boost::shared_ptr<ore::analytics::Parameters> param = boost::dynamic_pointer_cast<ore::analytics::Parameters>(p);
      return new OREPlusAppPtr(new oreplus::analytics::OREPlusApp(param, out));
    }
    //boost::shared_ptr<ore::data::MarketImpl> getMarket() const {
    MarketImplPtr getMarket() const {
      return boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->getMarket();
    }
    boost::shared_ptr<ore::analytics::ScenarioSimMarket> getSimulationMarket() const {
      return boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->getSimulationMarket();
    }
    boost::shared_ptr<ore::analytics::DateGrid> getDateGrid() const {
      return boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->getDateGrid();
    }
    void buildMarket(const std::string& todaysMarketXML = "", const std::string& curveConfigXML = "",
                     const std::string& conventionsXML = "",
                     const std::vector<string>& marketData = std::vector<string>(),
                     const std::vector<string>& fixingData = std::vector<string>()) {
      boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->buildMarket(todaysMarketXML, curveConfigXML, conventionsXML, marketData, fixingData);     
    }
    void buildSimulationMarket(const std::string& simulationXML = "") {
      boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->buildSimulationMarket(simulationXML);     
    }
    boost::shared_ptr<ore::data::EngineFactory> buildEngineFactoryFromXMLString(const boost::shared_ptr<Market>& market,
										const std::string& pricingEngineXML) {
      return boost::dynamic_pointer_cast<oreplus::analytics::OREPlusApp>(*self)->buildEngineFactoryFromXMLString(market, pricingEngineXML);
    }
  }
};
