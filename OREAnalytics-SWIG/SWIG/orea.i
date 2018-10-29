
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
#include <orea/auto_link.hpp>

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

using ore::analytics::Parameters;
typedef boost::shared_ptr<ore::analytics::Parameters> ParametersPtr;

using ore::analytics::OREApp;
typedef boost::shared_ptr<ore::analytics::OREApp> OREAppPtr;

%}

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

///////////////////////////////////////////////////////////////////////////////////////////////

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
