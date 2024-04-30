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
using ore::analytics::AnalyticsManager;
using ore::analytics::InputParameters;
using ore::analytics::NPVCube;
using ore::analytics::AggregationScenarioData;
using ore::analytics::MarketDataLoader;
using ore::analytics::MarketDataInMemoryLoader;
using ore::analytics::MarketCalibrationReport;
using ore::data::Portfolio;
using ore::data::MarketImpl;
using ore::data::PlainInMemoryReport;
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

%shared_ptr(InputParameters)
class InputParameters {
public:

    // Getters, to be continued
    const QuantLib::Date& asof();
    const ext::shared_ptr<Portfolio>& portfolio();
    Size nThreads();
    
    // and Setters
    void setAsOfDate(const std::string& s); 
    void setResultsPath(const std::string& s);
    void setBaseCurrency(const std::string& s);
    void setContinueOnError(bool b);
    void setLazyMarketBuilding(bool b);
    void setBuildFailedTrades(bool b);
    void setObservationModel(const std::string& s);
    void setImplyTodaysFixings(bool b);
    void setMarketConfig(const std::string& config, const std::string& context);
    void setRefDataManager(const std::string& xml);
    void setConventions(const std::string& xml);
    void setIborFallbackConfig(const std::string& xml);
    void setCurveConfigs(const std::string& xml);
    void setPricingEngine(const std::string& xml);
    void setTodaysMarketParams(const std::string& xml);
    void setPortfolio(const std::string& xml); 
    void setThreads(int i);
    void setEntireMarket(bool b);
    void setAllFixings(bool b);
    void setEomInflationFixings(bool b);
    void setUseMarketDataFixings(bool b);
    void setIborFallbackOverride(bool b);
    void setReportNaString(const std::string& s);
    void setCsvQuoteChar(const char& c);
    void setCsvSeparator(const char& c);
    void setCsvCommentCharacter(const char& c);
    void setDryRun(bool b);
    void setMporDays(Size s);
    void setMporCalendar(const std::string& s); 
    void setMporForward(bool b);
    // Setters for npv analytics
    void setOutputAdditionalResults(bool b);
    // Setters for cashflows
    void setIncludePastCashflows(bool b);
    // Setters for curves/markets
    void setOutputCurves(bool b);
    void setOutputTodaysMarketCalibration(bool b);
    void setCurvesMarketConfig(const std::string& s);
    void setCurvesGrid(const std::string& s);
    // Setters for sensi analytics
    void setXbsParConversion(bool b);
    void setParSensi(bool b);
    void setAlignPillars(bool b);
    void setOutputJacobi(bool b);
    void setUseSensiSpreadedTermStructures(bool b);
    void setSensiThreshold(Real r);
    void setSensiSimMarketParams(const std::string& xml);
    void setSensiScenarioData(const std::string& xml);
    void setSensiPricingEngine(const std::string& xml);
    // Setters for stress testing
    void setStressThreshold(Real r);
    void setStressSimMarketParams(const std::string& xml); 
    void setStressScenarioData(const std::string& xml); 
    void setStressPricingEngine(const std::string& xml); 
    // Setters for VaR
    void setSalvageCovariance(bool b);
    void setVarQuantiles(const std::string& s); // parse to vector<Real>
    void setVarBreakDown(bool b);
    void setPortfolioFilter(const std::string& s);
    void setVarMethod(const std::string& s);
    void setMcVarSamples(Size s);
    void setMcVarSeed(long l);
    void setCovarianceData(ore::data::CSVReader& reader);
    void setCovarianceDataFromBuffer(const std::string& xml);
    void setSensitivityStreamFromBuffer(const std::string& buffer);
    // Setters for exposure simulation
    void setSimmVersion(const std::string& s);
    void setCrifFromBuffer(const std::string& csvBuffer,
                           char eol = '\n', char delim = ',', char quoteChar = '\0', char escapeChar = '\\');
    void setSimmCalculationCurrencyCall(const std::string& s);
    void setSimmCalculationCurrencyPost(const std::string& s);
    void setSimmResultCurrency(const std::string& s);
    void setSimmReportingCurrency(const std::string& s);
    void setAmc(bool b);
    void setAmcTradeTypes(const std::string& s); // todo: parse to set<string>
    void setExposureBaseCurrency(const std::string& s);
    void setExposureObservationModel(const std::string& s);
    void setNettingSetId(const std::string& s);
    void setScenarioGenType(const std::string& s);
    void setStoreFlows(bool b);
    void setStoreSurvivalProbabilities(bool b);
    void setWriteCube(bool b);
    void setWriteScenarios(bool b);
    void setExposureSimMarketParams(const std::string& xml);
    void setScenarioGeneratorData(const std::string& xml);
    void setCrossAssetModelData(const std::string& xml);
    void setSimulationPricingEngine(const std::string& xml);
    void setAmcPricingEngine(const std::string& xml);
    void setNettingSetManager(const std::string& xml);
    // TODO: load from XML
    // void setCounterpartyManager(const std::string& xml);
    // TODO: load from XML
    // void setCollateralBalances(const std::string& xml); // todo: load from XML
    // Setters for xva
    void setXvaBaseCurrency(const std::string& s) { xvaBaseCurrency_ = s; }
    void setLoadCube(bool b) { loadCube_ = b; }
    // TODO: API for setting NPV and market cubes
    // boost::shared_ptr<NPVCube> cube();
    // boost::shared_ptr<NPVCube> nettingSetCube();
    // boost::shared_ptr<NPVCube> cptyCube();
    // boost::shared_ptr<AggregationScenarioData> mktCube();
    void setFlipViewXVA(bool b);
    void setFullInitialCollateralisation(bool b);
    void setExposureProfiles(bool b);
    void setExposureProfilesByTrade(bool b);
    void setPfeQuantile(Real r);
    void setCollateralCalculationType(const std::string& s);
    void setExposureAllocationMethod(const std::string& s);
    void setMarginalAllocationLimit(Real r);
    void setExerciseNextBreak(bool b);
    void setCvaAnalytic(bool b);
    void setDvaAnalytic(bool b);
    void setFvaAnalytic(bool b);
    void setColvaAnalytic(bool b);
    void setCollateralFloorAnalytic(bool b);
    void setDimAnalytic(bool b);
    void setMvaAnalytic(bool b);
    void setKvaAnalytic(bool b);
    void setDynamicCredit(bool b);
    void setCvaSensi(bool b);
    void setCvaSensiGrid(const std::string& s); // todo: parse to vector<Period>
    void setCvaSensiShiftSize(Real r);
    void setDvaName(const std::string& s);
    void setRawCubeOutput(bool b);
    void setNetCubeOutput(bool b);
    // FIXME: remove this from the base class?
    void setRawCubeOutputFile(const std::string& s);
    void setNetCubeOutputFile(const std::string& s);
    // funding value adjustment details
    void setFvaBorrowingCurve(const std::string& s);
    void setFvaLendingCurve(const std::string& s);
    void setFlipViewBorrowingCurvePostfix(const std::string& s);
    void setFlipViewLendingCurvePostfix(const std::string& s);
    // dynamic initial margin details
    void setDeterministicInitialMargin(const std::string& nettingSet, TimeSeries<Real> timeSeries);
    void setDimQuantile(Real r);
    void setDimHorizonCalendarDays(Size s);
    void setDimRegressionOrder(Size s);
    void setDimRegressors(const std::string& s); 
    void setDimOutputGridPoints(const std::string& s); 
    void setDimOutputNettingSet(const std::string& s);
    void setDimLocalRegressionEvaluations(Size s);
    void setDimLocalRegressionBandwidth(Real r);
    // capital value adjustment details
    void setKvaCapitalDiscountRate(Real r);
    void setKvaAlpha(Real r);
    void setKvaRegAdjustment(Real r);
    void setKvaCapitalHurdle(Real r);
    void setKvaOurPdFloor(Real r);
    void setKvaTheirPdFloor(Real r);
    void setKvaOurCvaRiskWeight(Real r);
    void setKvaTheirCvaRiskWeight(Real r);
    // Setters for Credit Simulation
    void setCreditMigrationAnalytic(bool b);
    void setCreditMigrationDistributionGrid(const std::vector<Real>& grid);
    void setCreditMigrationTimeSteps(const std::vector<Size>& ts);
    void setCreditSimulationParametersFromFile(const std::string& fileName);
    void setCreditSimulationParametersFromBuffer(const std::string& xml);
    void setCreditMigrationOutputFiles(const std::string& s);
    // Setters for cashflow npv and dynamic backtesting
    void setCashflowHorizon(const std::string& s); 
    void setPortfolioFilterDate(const std::string& s);
    // Set list of analytics that shall be run
    void setAnalytics(const std::string& s);
    void insertAnalytic(const std::string& s); 
    void setCubeFromFile(const std::string& file);
    void setNettingSetCubeFromFile(const std::string& file);
    void setCptyCubeFromFile(const std::string& file);
    void setMarketCubeFromFile(const std::string& file);
    void setNettingSetManagerFromFile(const std::string& fileName);
    void setCollateralBalancesFromFile(const std::string& fileName);
    void setCube(const ext::shared_ptr<NPVCube>& file);
    void setMarketCube(const ext::shared_ptr<AggregationScenarioData>& file);
};

%shared_ptr(OREApp)
class OREApp {
  public:

    OREApp(const ext::shared_ptr<Parameters>& params, bool console = false);

    OREApp(const ext::shared_ptr<InputParameters>& inputs, const std::string& logFile, Size logLevel = 31,
           bool console = false);
    
    void run();

    void run(const std::vector<std::string>& marketData,
             const std::vector<std::string>& fixingData);

    ext::shared_ptr<InputParameters> getInputs();

    std::set<std::string> getAnalyticTypes();
    std::set<std::string> getSupportedAnalyticTypes();
    const ext::shared_ptr<Analytic>& getAnalytic(std::string type); 

    std::set<std::string> getReportNames();
    ext::shared_ptr<PlainInMemoryReport> getReport(std::string reportName);

    std::set<std::string> getCubeNames();
    ext::shared_ptr<NPVCube> getCube(std::string cubeName);

    std::set<std::string> getMarketCubeNames();
    ext::shared_ptr<AggregationScenarioData> getMarketCube(std::string cubeName);

    std::vector<std::string> getErrors();

    Real getRunTime();

    std::string version();
};

%shared_ptr(Analytic)
class Analytic {
 public:
    ext::shared_ptr<MarketImpl> getMarket() const;
    const ext::shared_ptr<Portfolio>& portfolio() const;
};

%shared_ptr(AnalyticsManager)
class AnalyticsManager {
public:
    AnalyticsManager(const ext::shared_ptr<InputParameters>& inputs,
                     const ext::shared_ptr<MarketDataLoader>& marketDataLoader);
    void runAnalytics(const ext::shared_ptr<MarketCalibrationReport>& marketCalibrationReport = nullptr);
};

%shared_ptr(MarketDataInMemoryLoader)
class MarketDataInMemoryLoader : public MarketDataLoader {
public: 
    MarketDataInMemoryLoader(const ext::shared_ptr<InputParameters>& inputs,
                             const std::vector<std::string>& marketData,
                             const std::vector<std::string>& fixingData);
};

#endif
