#!/usr/bin/env python
# coding: utf-8

# 
# # Getting Started

# This dashboard demonstrates several ways of interacting with ORE in a Jupyter notebook 
# - Portfolio: Single Swap
# - Market: Minimal setup with flat curves
# - Analytics: Valuation, cashflows, sensitivities, exposure simulation and XVA
# 
# Prerequisites:
# - This notebook assumes a standard installation of Python 3
# - ORE Python module installed: run "pip install osre" to get the latest version

# ## Launch ORE

# Kick off a process in ORE, loading all inputs from Input/ore.xml and the files referenced therein. 
# This is equivalent to using the ORE command line application.

# In[1]:


import sys, time, math
import utilities
from OREAnalytics import *

print ("Load parameters")
params = Parameters()
params.fromFile("Input/ore.xml")

print ("Create OREApp")
ore = OREApp(params)


# This should have loaded the main inputs
# - portfolio
# - today's market configuration
# - conventions
# - curve configrations
# - pricing engine configuration

# In[2]:


portfolio = ore.getInputs().portfolio()
print("Portfolio size:", portfolio.size())
for id in portfolio.ids():
    trade = portfolio.get(id)
    print("Trade id", id, "type", trade.tradeType())
#print("\n")
#portfolioXML = portfolio.toXMLString()
#print(portfolioXML)


# Kick off the ORE process:

# In[3]:


print ("Run the ORE process");
ore.run()


# ## Query Results

# The results of the ORE run above have been written to the Output folder.
# Moreover all results are stored in memory and can be queried as follows.

# First, double-check which analytics we have requested, see Input/ore.xml:

# In[4]:


print ("Requested analytics:", ore.getAnalyticTypes())


# Now list all reports that have been generated:

# In[5]:


utilities.writeReportList(ore.getReportNames())


# ## Inspect the NPV report

# Pick the npv report, check its structure...

# In[6]:


report = ore.getReport("npv")
print ("Got NPV report")


# In[7]:


utilities.checkReportStructure(report)


# ... and write a subset of the NPV report columns (0, 1, 2, 4, 5):

# In[8]:


utilities.writeReport(report, [0, 1, 2, 4, 5])


# ## Inspect the cashflow report

# Pick the cashflow report, check its structure...

# In[9]:


report = ore.getReport("cashflow")
print ("Got cashflow report")
utilities.checkReportStructure(report)


# ... and write a subset of the cashflow report columns:

# In[10]:


utilities.writeReport(report, [2, 3, 4, 5, 6])


# ## Inspect the curves report

# See which curves have been written. Compare to the configuration in Input/todaysmarket.xml. 

# In[11]:


print ("Get curves report")
report = ore.getReport("curves")
utilities.checkReportStructure(report)


# Now pick the EUR, GBP and USD discount curves, convert dates into times and discounts into zero rates: 

# In[12]:


asof = ore.getInputs().asof()

date = report.dataAsDate(1)
eurDiscount = report.dataAsReal(2)
gbpDiscount = report.dataAsReal(3)
usdDiscount = report.dataAsReal(4)
time = [0] * report.rows()
eurZero = [0] * report.rows() 
gbpZero = [0] * report.rows() 
usdZero = [0] * report.rows() 

dc = Actual365Fixed()
#print ("#Index", "Date", "Discount")
for i in range(0, report.rows()):
    time[i] = dc.yearFraction(asof, date[i])
    eurZero[i] = -math.log(eurDiscount[i]) / time[i]
    gbpZero[i] = -math.log(gbpDiscount[i]) / time[i]
    usdZero[i] = -math.log(usdDiscount[i]) / time[i]
    #print("%d %s %.4f %.8f %.8f" % (i, date[i].ISO(), time[i], eurZero[i], gbpZero[i]))


# ... and plot the curves:

# In[13]:


import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

fig = plt.figure(figsize=(14, 5))
gs = GridSpec(nrows=1, ncols=2)
ax0 = fig.add_subplot(gs[0, 0])
ax1 = fig.add_subplot(gs[0, 1])

ax0.plot(time, eurDiscount, label='EUR')
ax0.plot(time, gbpDiscount, label='GBP')
ax0.plot(time, usdDiscount, label='USD')
ax0.set(xlabel='Time/Years', ylabel='Discount Factor')
ax0.set_title('Discount Curves')
ax0.legend()
ax1.plot(time, eurZero, label='EUR')
ax1.plot(time, gbpZero, label='GBP')
ax1.plot(time, usdZero, label='USD')
ax1.set(xlabel='Time/Years', ylabel='Rate')
ax1.set_title('Zero Curves')
ax1.legend()

plt.show()


# EUR and GBP zero curves are flat, as expected.

# ## Sensitivity Analysis

# We could now modify the inputs via ore.xml and run again to generate a sensitivity report.
# 
# But we can also do it here. It requires two additional configurations:

# In[14]:


sensiXML = """
<SensitivityAnalysis>
  <DiscountCurves>
    <DiscountCurve ccy='EUR'>
      <ShiftType>Absolute</ShiftType>
      <ShiftSize>0.0001</ShiftSize>
      <ShiftTenors>2W,1M,3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y,25Y,30Y</ShiftTenors>
      <ParConversion>
        <Instruments>OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS</Instruments>
        <SingleCurve>true</SingleCurve>
        <Conventions>
            <Convention id='DEP'>EUR-EURIBOR-CONVENTIONS</Convention>
            <Convention id='IRS'>EUR-6M-SWAP-CONVENTIONS</Convention>
            <Convention id='OIS'>EUR-OIS-CONVENTIONS</Convention>
        </Conventions>
      </ParConversion>
    </DiscountCurve>
  </DiscountCurves>
  <IndexCurves>
    <IndexCurve index='EUR-EONIA'>
      <ShiftType>Absolute</ShiftType>
      <ShiftSize>0.0001</ShiftSize>
      <ShiftTenors>2W,1M,3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y,25Y,30Y</ShiftTenors>
      <ParConversion>
        <Instruments>OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS,OIS</Instruments>
        <SingleCurve>true</SingleCurve>
        <Conventions>
            <Convention id='DEP'>EUR-EURIBOR-CONVENTIONS</Convention>
            <Convention id='IRS'>EUR-6M-SWAP-CONVENTIONS</Convention>
            <Convention id='OIS'>EUR-OIS-CONVENTIONS</Convention>
        </Conventions>
      </ParConversion>
    </IndexCurve>
    <IndexCurve index='EUR-EURIBOR-6M'>
      <ShiftType>Absolute</ShiftType>
      <ShiftSize>0.0001</ShiftSize>
      <ShiftTenors>2W,1M,3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y,25Y,30Y</ShiftTenors>
      <ParConversion>
        <Instruments>DEP,DEP,DEP,DEP,DEP,IRS,IRS,IRS,IRS,IRS,IRS,IRS,IRS,IRS,IRS,IRS</Instruments>
        <SingleCurve>false</SingleCurve>
        <Conventions>
            <Convention id='DEP'>EUR-EURIBOR-CONVENTIONS</Convention>
            <Convention id='IRS'>EUR-6M-SWAP-CONVENTIONS</Convention>
            <Convention id='OIS'>EUR-OIS-CONVENTIONS</Convention>
        </Conventions>
      </ParConversion>
    </IndexCurve>
  </IndexCurves>
</SensitivityAnalysis>
"""


# In[15]:


simulationXML = """
<Simulation>
  <Market>
    <BaseCurrency>EUR</BaseCurrency>
    <Currencies>
      <Currency>EUR</Currency>
    </Currencies>
    <YieldCurves>
      <Configuration>
        <Tenors>2W,1M,3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y,25Y,30Y</Tenors>
        <Interpolation>LogLinear</Interpolation>
        <Extrapolation>Y</Extrapolation>
      </Configuration>
    </YieldCurves>
    <Indices>
      <Index>EUR-EONIA</Index>
      <Index>EUR-EURIBOR-6M</Index>
    </Indices>
  </Market>
</Simulation>
"""


# In[16]:


inputs = ore.getInputs()
inputs.setSensiScenarioData(sensiXML);
inputs.setSensiSimMarketParams(simulationXML)
inputs.insertAnalytic("SENSITIVITY")


# Run again...

# In[17]:


print ("Run the ORE process again...");
ore.run()


# Check result reports again...

# In[18]:


utilities.writeReportList(ore.getReportNames())


# We have a sensitivity report now

# In[19]:


reportName = "sensitivity"
print ("Load report", reportName)
rawReport = ore.getReport(reportName)
utilities.checkReportStructure(rawReport)


# In[20]:


isPar = rawReport.dataAsString(1)
factor = rawReport.dataAsString(2)
shiftSize = rawReport.dataAsReal(3)
currency = rawReport.dataAsString(6)
npv = rawReport.dataAsReal(7)
delta = rawReport.dataAsReal(8) 
gamma = rawReport.dataAsReal(9)
print ("%-10s %-35s %10s %10s %10s %10s %10s" % ("IsPar", "Factor", "ShiftSize", "Currency", "NPV", "Delta", "Gamma"))
rawDelta = {}
for i in range(0, rawReport.rows()):
    print("%-10s %-35s %10.6f %10s %10.2f %10.2f %10.2f" % (isPar[i], factor[i], shiftSize[i], currency[i], npv[i], delta[i], gamma[i]))
    if ("IndexCurve" in factor[i]):
        rawDelta[factor[i]] = delta[i]


# We want par sensitivities as well:

# In[21]:


inputs.setParSensi(True)


# In[22]:


print ("Run the ORE process yet again...");
ore.run()


# In[23]:


print ("Result reports:", ore.getReportNames())


# We have a par sensitivity report now

# In[24]:


parReportName = "par_sensitivity"
print ("Load report", parReportName)
parReport = ore.getReport(parReportName)
    
isPar = parReport.dataAsString(1)
factor = parReport.dataAsString(2)
shiftSize = parReport.dataAsReal(3)
currency = parReport.dataAsString(6)
npv = parReport.dataAsReal(7)
delta = parReport.dataAsReal(8) 

print("\n")
print ("%-10s %-35s %10s %10s %10s %10s" % ("IsPar", "Factor", "ShiftSize", "Currency", "NPV", "ParDelta"))
parDelta = {}
for i in range(0, parReport.rows()):
    print("%-10s %-35s %10.6f %10s %10.2f %10.2f" % (isPar[i], factor[i], shiftSize[i], currency[i], npv[i], delta[i]))
    if ("IndexCurve" in factor[i]):
        parDelta[factor[i]] = delta[i]


# Compare raw and par index curve sensitivities:

# In[25]:


print("%-35s %10s %10s" % ("Factor", "RawDelta", "ParDelta"))
for key in parDelta:
    if (key not in rawDelta):
        rawDelta[key] = 0
    print("%-35s %10.2f %10.2f" % (key, rawDelta[key], parDelta[key]))


# ## Exposure Simulation

# To run an exposure simulation, we need to add further configurations:
# - simulation market configuration
# - scenario generator configuration
# - cross asset model configuration
# - netting set manager

# In[26]:


mcSimMarketXML ="""
<Simulation>
<Market>
  <BaseCurrency>EUR</BaseCurrency>
    <Currencies>
      <Currency>EUR</Currency>
    </Currencies>
  <YieldCurves>
    <Configuration>
      <Tenors>3M,6M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,12Y,15Y,20Y,25Y,30Y</Tenors>
      <Interpolation>LogLinear</Interpolation>
      <Extrapolation>Y</Extrapolation>
    </Configuration>
  </YieldCurves>
  <Indices>
    <Index>EUR-EURIBOR-6M</Index>
    <Index>EUR-EONIA</Index>
  </Indices>
  <SwapIndices>
    <SwapIndex>
      <Name>EUR-CMS-1Y</Name>
      <DiscountingIndex>EUR-EONIA</DiscountingIndex>
    </SwapIndex>
    <SwapIndex>
      <Name>EUR-CMS-30Y</Name>
      <DiscountingIndex>EUR-EONIA</DiscountingIndex>
    </SwapIndex>
  </SwapIndices>
  <DefaultCurves>
    <Names/>
    <Tenors>6M,1Y,2Y</Tenors>
  </DefaultCurves>
  <AggregationScenarioDataCurrencies>
    <Currency>EUR</Currency>
  </AggregationScenarioDataCurrencies>
  <AggregationScenarioDataIndices>
    <Index>EUR-EONIA</Index>
  </AggregationScenarioDataIndices>
</Market>
</Simulation>
"""


# In[27]:


scenarioGeneratorXML ="""
<Simulation>
  <Parameters>
    <Discretization>Exact</Discretization>
    <Grid>81,3M</Grid>
    <Calendar>EUR</Calendar>
    <Sequence>SobolBrownianBridge</Sequence>
    <Scenario>Simple</Scenario>
    <Seed>42</Seed>
    <Samples>1000</Samples>
  </Parameters>
</Simulation>
"""


# In[28]:


crossAssetModelXML = """
<Simulation>
<CrossAssetModel>
  <DomesticCcy>EUR</DomesticCcy>
  <Currencies>
    <Currency>EUR</Currency>
  </Currencies>
  <BootstrapTolerance>0.0001</BootstrapTolerance>
  <InterestRateModels>
    <LGM ccy='default'>
      <CalibrationType>Bootstrap</CalibrationType>
      <Volatility>
        <Calibrate>Y</Calibrate>
        <VolatilityType>Hagan</VolatilityType>
        <ParamType>Piecewise</ParamType>
        <TimeGrid>1.0,2.0,3.0,4.0,5.0,7.0,10.0</TimeGrid>
        <InitialValue>0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01</InitialValue>
      </Volatility>
      <Reversion>
        <Calibrate>N</Calibrate>
        <ReversionType>HullWhite</ReversionType>
        <ParamType>Constant</ParamType>
        <TimeGrid/>
        <InitialValue>0.03</InitialValue>
      </Reversion>
      <CalibrationSwaptions>
        <Expiries> 1Y,  2Y,  4Y,  6Y,  8Y, 10Y, 12Y, 14Y, 16Y, 18Y, 19Y</Expiries>
        <Terms>   19Y, 18Y, 16Y, 14Y, 12Y, 10Y,  8Y,  6Y,  4Y,  2Y,  1Y</Terms>
        <Strikes/>
      </CalibrationSwaptions>
      <ParameterTransformation>
        <ShiftHorizon>0.0</ShiftHorizon>
        <Scaling>1.0</Scaling>
      </ParameterTransformation>
   </LGM>
  </InterestRateModels>
  <ForeignExchangeModels>
    <CrossCcyLGM foreignCcy='default'>
      <DomesticCcy>EUR</DomesticCcy>
      <CalibrationType>Bootstrap</CalibrationType>
      <Sigma>
        <Calibrate>Y</Calibrate>
        <ParamType>Piecewise</ParamType>
        <TimeGrid>1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 10.0</TimeGrid>
        <InitialValue>0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1</InitialValue>
      </Sigma>
      <CalibrationOptions>
        <Expiries>1Y, 2Y, 3Y, 4Y, 5Y, 10Y</Expiries>
        <Strikes/>
      </CalibrationOptions>
    </CrossCcyLGM>
  </ForeignExchangeModels>
  <InstantaneousCorrelations>
    <Correlation factor1='IR:EUR' factor2='IR:GBP'>0.3</Correlation>
    <Correlation factor1='IR:EUR' factor2='FX:GBPEUR'>0</Correlation>
    <Correlation factor1='IR:GBP' factor2='FX:GBPEUR'>0</Correlation>
  </InstantaneousCorrelations>
</CrossAssetModel>
</Simulation>
"""


# In[29]:


nettingSetManagerXML = """
<NettingSetDefinitions>
  <NettingSet>
    <NettingSetId>CPTY_A</NettingSetId>
    <Counterparty>CPTY_A</Counterparty>
    <ActiveCSAFlag>false</ActiveCSAFlag>
    <CSADetails>
      <Bilateral>Bilateral</Bilateral>
      <CSACurrency>EUR</CSACurrency>
      <Index>EUR-EONIA</Index>
      <ThresholdPay>0</ThresholdPay>
      <ThresholdReceive>0</ThresholdReceive>
      <MinimumTransferAmountPay>0</MinimumTransferAmountPay>
      <MinimumTransferAmountReceive>0</MinimumTransferAmountReceive>
      <IndependentAmount>
        <IndependentAmountHeld>0</IndependentAmountHeld>
        <IndependentAmountType>FIXED</IndependentAmountType>
      </IndependentAmount>
      <MarginingFrequency>
        <CallFrequency>1D</CallFrequency>
        <PostFrequency>1D</PostFrequency>
      </MarginingFrequency>
      <MarginPeriodOfRisk>2W</MarginPeriodOfRisk>
      <CollateralCompoundingSpreadReceive>0.00</CollateralCompoundingSpreadReceive>
      <CollateralCompoundingSpreadPay>0.00</CollateralCompoundingSpreadPay>
      <EligibleCollaterals>
        <Currencies>
          <Currency>EUR</Currency>
        </Currencies>
      </EligibleCollaterals>
    </CSADetails>
  </NettingSet>
</NettingSetDefinitions>
"""


# In[30]:


simulationPricingEngineXML = """
<PricingEngines>
<Product type='Swap'>
  <Model>DiscountedCashflows</Model>
  <ModelParameters/>
  <Engine>DiscountingSwapEngineOptimised</Engine>
  <EngineParameters/>
</Product>
</PricingEngines>
"""
amcPricingEngineXML = "<PricingEngines></PricingEngines>"


# In[31]:


inputs.setExposureBaseCurrency("EUR")
inputs.setExposureSimMarketParams(mcSimMarketXML)
inputs.setScenarioGeneratorData(scenarioGeneratorXML)
inputs.setCrossAssetModelData(crossAssetModelXML)
inputs.setSimulationPricingEngine(simulationPricingEngineXML)
inputs.setAmcPricingEngine(amcPricingEngineXML)
inputs.setNettingSetManager(nettingSetManagerXML)
inputs.setWriteCube(True)
inputs.setXvaBaseCurrency("EUR")
inputs.setExposureProfiles(True)
inputs.setExposureProfilesByTrade(True)
inputs.setCvaAnalytic(True)
inputs.setAmc(False)

inputs.insertAnalytic("EXPOSURE")
inputs.insertAnalytic("XVA")


# In[ ]:


print ("Run the ORE process yet again...");
ore.run()


# In[ ]:


errors = ore.getErrors()
print ("ORE process completed with", len(errors), "errors/warnings")
if len(errors) > 0:
    for e in errors:
        print(e)


# In[ ]:


utilities.writeReportList(ore.getReportNames())


# We should have several additional reports now:
# - xva
# - exposure_trade_Swap
# - exposure-nettingset_CPTY_A
# - cva_sensitivity_nettingset_CPTY_A
# - colva_nettingset_CPTY_A
# 
# Let us check the trade or nettingset exposure report:

# In[ ]:


reportName = "exposure_trade_Swap"
print ("Load report", reportName)
report = ore.getReport(reportName)
utilities.checkReportStructure(rawReport)


# In[ ]:


time = report.dataAsReal(2)
epe = report.dataAsReal(3);
ene = report.dataAsReal(4);
pfe = report.dataAsReal(7);
    
import matplotlib.pyplot as plt
fig = plt.figure(figsize=(10, 5))
gs = GridSpec(nrows=1, ncols=1)
ax = fig.add_subplot(gs[0, 0])

ax.plot(time, epe, label='Swap EPE')
ax.plot(time, ene, label='Swap ENE')
ax.plot(time, pfe, label='Swap PFE')
ax.set(xlabel='Time/Years')
ax.set(ylabel='Exposure')
ax.set_title('Exposure')
ax.legend()

plt.show()


# Finally, we can pick the trade or netting set CVA result from the xva report:

# In[ ]:


reportName = "xva"
print ("Load report", reportName)
report = ore.getReport(reportName)
utilities.checkReportStructure(rawReport)


# In[ ]:


print("XVA report:")
utilities.writeReport(report, [0, 1, 2])


# In[ ]:




