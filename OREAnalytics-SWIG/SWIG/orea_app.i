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

#ifndef orea_app_i
#define orea_app_i

%include ored_market.i
%include ored_reports.i
%include std_map.i
%include std_set.i

%{
using ore::analytics::Parameters;
using ore::analytics::OREApp;
using ore::analytics::Analytic;
using ore::data::PlainInMemoryReport;
using ore::analytics::NPVCube;
%}

namespace std {

    %template(StringSet) set<string>;
    %template(IntSet) set<int>;
    %template(UnsignedIntSet) set<unsigned int>;

}

// ORE Analytics

%shared_ptr(Parameters)
class Parameters {
  public:
    Parameters();
    void clear();
    void fromFile(const std::string& name);
    bool hasGroup(const std::string& groupName) const;
    bool has(const std::string& groupName, const std::string& paramName) const;
    std::string get(const std::string& groupName, const std::string& paramName) const;
    //TODO: add this function to ORE, then add here
    //void add(const std::string& groupName, const std::string& paramName, const std::string& paramValue);
};

%shared_ptr(OREApp)
class OREApp {
  public:

    OREApp(const ext::shared_ptr<Parameters>& p, std::ostream& out = std::cout);

    int run(bool useAnalytics = true);

    void buildMarket(const std::string& todaysMarketXML = "", const std::string& curveConfigXML = "",
                     const std::string& conventionsXML = "",
                     const std::vector<std::string>& marketData = std::vector<std::string>(),
                     const std::vector<std::string>& fixingData = std::vector<std::string>());

    ext::shared_ptr<MarketImpl> getMarket() const;

    ext::shared_ptr<ore::data::EngineFactory> buildEngineFactoryFromXMLString(
        const ext::shared_ptr<MarketImpl>& marketImpl,
        const std::string& pricingEngineXML,
        const bool generateAdditionalResults = false);

    std::set<std::string> getAnalyticTypes();
    std::set<std::string> getSupportedAnalyticTypes();
    const ext::shared_ptr<Analytic>& getAnalytic(std::string type); 

    std::set<std::string> getReportNames();
    ext::shared_ptr<PlainInMemoryReport> getReport(std::string reportName);

    std::set<std::string> getCubeNames();
    ext::shared_ptr<NPVCube> getCube(std::string cubeName);
};

%shared_ptr(Analytic)
class Analytic {
 public:
    
    const ext::shared_ptr<ore::data::Market>& market() const;
    const ext::shared_ptr<ore::data::Portfolio>& portfolio() const;
};
    
#endif
