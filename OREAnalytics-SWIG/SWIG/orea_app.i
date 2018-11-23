
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef orea_app_i
#define orea_app_i

%{
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

#endif
