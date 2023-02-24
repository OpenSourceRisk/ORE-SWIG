'''
 Copyright (C) 2018-2023 Quaternion Risk Management Ltd

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
'''

import sys, time
from OREAnalytics import *

###################################
# Build inputs step by step via API

print ("Assemble XML strings...")

portfolioXML =\
"<Portfolio>"\
"  <Trade id='Swap_20y'>"\
"    <TradeType>Swap</TradeType>"\
"    <Envelope>"\
"      <CounterParty>CPTY_A</CounterParty>"\
"      <NettingSetId>CPTY_A</NettingSetId>"\
"      <AdditionalFields/>"\
"    </Envelope>"\
"    <SwapData>"\
"      <LegData>"\
"        <LegType>Fixed</LegType>"\
"        <Payer>false</Payer>"\
"        <Currency>EUR</Currency>"\
"        <Notionals>"\
"          <Notional>10000000.0</Notional>"\
"        </Notionals>"\
"        <DayCounter>30/360</DayCounter>"\
"        <PaymentConvention>F</PaymentConvention>"\
"        <FixedLegData>"\
"          <Rates>"\
"            <Rate>0.02</Rate>"\
"          </Rates>"\
"        </FixedLegData>"\
"        <ScheduleData>"\
"          <Rules>"\
"            <StartDate>20160301</StartDate>"\
"            <EndDate>20360301</EndDate>"\
"            <Tenor>1Y</Tenor>"\
"            <Calendar>TARGET</Calendar>"\
"            <Convention>F</Convention>"\
"            <TermConvention>F</TermConvention>"\
"            <Rule>Forward</Rule>"\
"            <EndOfMonth/>"\
"            <FirstDate/>"\
"            <LastDate/>"\
"          </Rules>"\
"        </ScheduleData>"\
"      </LegData>"\
"      <LegData>"\
"        <LegType>Floating</LegType>"\
"        <Payer>true</Payer>"\
"        <Currency>EUR</Currency>"\
"        <Notionals>"\
"          <Notional>10000000.0</Notional>"\
"        </Notionals>"\
"        <DayCounter>A360</DayCounter>"\
"        <PaymentConvention>MF</PaymentConvention>"\
"        <FloatingLegData>"\
"          <Index>EUR-EURIBOR-6M</Index>"\
"          <Spreads>"\
"            <Spread>0.000000</Spread>"\
"          </Spreads>"\
"          <IsInArrears>false</IsInArrears>"\
"          <FixingDays>2</FixingDays>"\
"        </FloatingLegData>"\
"        <ScheduleData>"\
"          <Rules>"\
"            <StartDate>20160301</StartDate>"\
"            <EndDate>20360301</EndDate>"\
"            <Tenor>6M</Tenor>"\
"            <Calendar>TARGET</Calendar>"\
"            <Convention>MF</Convention>"\
"            <TermConvention>MF</TermConvention>"\
"            <Rule>Forward</Rule>"\
"            <EndOfMonth/>"\
"            <FirstDate/>"\
"            <LastDate/>"\
"          </Rules>"\
"        </ScheduleData>"\
"      </LegData>"\
"    </SwapData>"\
"  </Trade>"\
"</Portfolio>"

refDataXML = "<ReferenceData></ReferenceData>"

conventionsXML =\
"<Conventions>"\
"<Deposit>"\
"  <Id>USD-LIBOR-CONVENTIONS</Id>"\
"  <IndexBased>true</IndexBased>"\
"  <Index>USD-LIBOR</Index>"\
"</Deposit>"\
"<Deposit>"\
"  <Id>USD-FED-FUNDS-CONVENTIONS</Id>"\
"  <IndexBased>true</IndexBased>"\
"  <Index>USD-FedFunds</Index>"\
"</Deposit>"\
"  <Deposit>"\
"  <Id>EUR-EONIA-CONVENTIONS</Id>"\
"  <IndexBased>true</IndexBased>"\
"  <Index>EUR-EONIA</Index>"\
"</Deposit>"\
"<Deposit>"\
"  <Id>EUR-EURIBOR-CONVENTIONS</Id>"\
"  <IndexBased>true</IndexBased>"\
"  <Index>EUR-EURIBOR</Index>"\
"</Deposit>"\
"<FRA>"\
"  <Id>USD-3M-FRA-CONVENTIONS</Id>"\
"  <Index>USD-LIBOR-3M</Index>"\
"</FRA>"\
"<FRA>"\
"  <Id>EUR-6M-FRA-CONVENTIONS</Id>"\
"  <Index>EUR-EURIBOR-6M</Index>"\
"</FRA>"\
"<OIS>"\
"  <Id>USD-OIS-CONVENTIONS</Id>"\
"  <SpotLag>2</SpotLag>"\
"  <Index>USD-FedFunds</Index>"\
"  <FixedDayCounter>A360</FixedDayCounter>"\
"  <PaymentLag>2</PaymentLag>"\
"  <EOM>false</EOM>"\
"  <FixedFrequency>Annual</FixedFrequency>"\
"  <FixedConvention>Following</FixedConvention>"\
"  <FixedPaymentConvention>Following</FixedPaymentConvention>"\
"  <Rule>Backward</Rule>"\
"</OIS>"\
"<OIS>"\
"  <Id>EUR-OIS-CONVENTIONS</Id>"\
"  <SpotLag>2</SpotLag>"\
"  <Index>EUR-EONIA</Index>"\
"  <FixedDayCounter>A360</FixedDayCounter>"\
"  <PaymentLag>1</PaymentLag>"\
"  <EOM>false</EOM>"\
"  <FixedFrequency>Annual</FixedFrequency>"\
"  <FixedConvention>Following</FixedConvention>"\
"  <FixedPaymentConvention>Following</FixedPaymentConvention>"\
"  <Rule>Backward</Rule>"\
"</OIS>"\
"<Swap>"\
"  <Id>USD-3M-SWAP-CONVENTIONS</Id>"\
"  <FixedCalendar>US,UK</FixedCalendar>"\
"  <FixedFrequency>Semiannual</FixedFrequency>"\
"  <FixedConvention>MF</FixedConvention>"\
"  <FixedDayCounter>30/360</FixedDayCounter>"\
"  <Index>USD-LIBOR-3M</Index>"\
"</Swap>"\
"<Swap>"\
"  <Id>EUR-3M-SWAP-CONVENTIONS</Id>"\
"  <FixedCalendar>TARGET</FixedCalendar>"\
"  <FixedFrequency>Annual</FixedFrequency>"\
"  <FixedConvention>MF</FixedConvention>"\
"  <FixedDayCounter>30/360</FixedDayCounter>"\
"  <Index>EUR-EURIBOR-3M</Index>"\
"</Swap>"\
"<Swap>"\
"  <Id>EUR-6M-SWAP-CONVENTIONS</Id>"\
"  <FixedCalendar>TARGET</FixedCalendar>"\
"  <FixedFrequency>Annual</FixedFrequency>"\
"  <FixedConvention>MF</FixedConvention>"\
"  <FixedDayCounter>30/360</FixedDayCounter>"\
"  <Index>EUR-EURIBOR-6M</Index>"\
"</Swap>"\
"<SwapIndex>"\
"  <Id>EUR-CMS-1Y</Id>"\
"  <Conventions>EUR-3M-SWAP-CONVENTIONS</Conventions>"\
"</SwapIndex>"\
"<SwapIndex>"\
"  <Id>EUR-CMS-30Y</Id>"\
"  <Conventions>EUR-6M-SWAP-CONVENTIONS</Conventions>"\
"</SwapIndex>"\
"<SwapIndex>"\
"  <Id>USD-CMS-1Y</Id>"\
"  <Conventions>USD-3M-SWAP-CONVENTIONS</Conventions>"\
"</SwapIndex>"\
"<SwapIndex>"\
"  <Id>USD-CMS-30Y</Id>"\
"  <Conventions>USD-3M-SWAP-CONVENTIONS</Conventions>"\
"</SwapIndex>"\
"<CDS>"\
"  <Id>CDS-STANDARD-CONVENTIONS</Id>"\
"  <SettlementDays>1</SettlementDays>"\
"  <Calendar>WeekendsOnly</Calendar>"\
"  <Frequency>Quarterly</Frequency>"\
"  <PaymentConvention>Following</PaymentConvention>"\
"  <Rule>CDS2015</Rule>"\
"  <DayCounter>A360</DayCounter>"\
"  <SettlesAccrual>true</SettlesAccrual>"\
"  <PaysAtDefaultTime>true</PaysAtDefaultTime>"\
"</CDS>"\
"</Conventions>"

curveConfigXML =\
"<CurveConfiguration>"\
"  <FXVolatilities>"\
"    <FXVolatility>"\
"      <CurveId>EURUSD</CurveId>"\
"      <CurveDescription/>"\
"      <Dimension>ATM</Dimension>"\
"      <Expiries>1M,3M,6M,1Y,2Y,3Y,10Y</Expiries>"\
"      <FXSpotID>FX/EUR/USD</FXSpotID>"\
"      <FXForeignCurveID>Yield/USD/USD1D</FXForeignCurveID>"\
"      <FXDomesticCurveID>Yield/EUR/EUR1D</FXDomesticCurveID>"\
"    </FXVolatility>"\
"  </FXVolatilities>"\
"  <SwaptionVolatilities>"\
"    <SwaptionVolatility>"\
"      <CurveId>EUR_SW_N</CurveId>"\
"      <CurveDescription>EUR normal swaption volatilities</CurveDescription>"\
"      <Dimension>ATM</Dimension>"\
"      <VolatilityType>Normal</VolatilityType>"\
"      <Extrapolation>Flat</Extrapolation>"\
"      <DayCounter>Actual/365 (Fixed)</DayCounter>"\
"      <Calendar>TARGET</Calendar>"\
"      <BusinessDayConvention>Following</BusinessDayConvention>"\
"      <OptionTenors>1Y,5Y,10Y</OptionTenors>"\
"      <SwapTenors>1Y,5Y,10Y</SwapTenors>"\
"      <ShortSwapIndexBase>EUR-CMS-1Y</ShortSwapIndexBase>"\
"      <SwapIndexBase>EUR-CMS-30Y</SwapIndexBase>"\
"    </SwaptionVolatility>"\
"    <SwaptionVolatility>"\
"      <CurveId>USD_SW_N</CurveId>"\
"      <CurveDescription>USD normal swaption volatilities</CurveDescription>"\
"      <Dimension>ATM</Dimension>"\
"      <VolatilityType>Lognormal</VolatilityType>"\
"      <Extrapolation>Flat</Extrapolation>"\
"      <DayCounter>Actual/365 (Fixed)</DayCounter>"\
"      <Calendar>TARGET</Calendar>"\
"      <BusinessDayConvention>Following</BusinessDayConvention>"\
"      <OptionTenors>1Y,5Y,10Y</OptionTenors>"\
"      <SwapTenors>1Y,5Y,10Y</SwapTenors>"\
"      <ShortSwapIndexBase>USD-CMS-1Y</ShortSwapIndexBase>"\
"      <SwapIndexBase>USD-CMS-30Y</SwapIndexBase>"\
"    </SwaptionVolatility>"\
"  </SwaptionVolatilities>"\
"  <YieldCurves>"\
"    <YieldCurve>"\
"      <CurveId>USD3M</CurveId>"\
"      <CurveDescription/>"\
"      <Currency>USD</Currency>"\
"      <DiscountCurve>USD1D</DiscountCurve>"\
"      <Segments>"\
"        <Simple>"\
"          <Type>Deposit</Type>"\
"          <Quotes>"\
"            <Quote>MM/RATE/USD/2D/1W</Quote>"\
"            <Quote>MM/RATE/USD/2D/1M</Quote>"\
"            <Quote>MM/RATE/USD/2D/2M</Quote>"\
"            <Quote>MM/RATE/USD/2D/3M</Quote>"\
"          </Quotes>"\
"          <Conventions>USD-LIBOR-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>USD3M</ProjectionCurve>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>FRA</Type>"\
"          <Quotes>"\
"            <Quote>FRA/RATE/USD/3M/3M</Quote>"\
"            <Quote>FRA/RATE/USD/6M/3M</Quote>"\
"            <Quote>FRA/RATE/USD/9M/3M</Quote>"\
"            <Quote>FRA/RATE/USD/1Y/3M</Quote>"\
"          </Quotes>"\
"          <Conventions>USD-3M-FRA-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>USD3M</ProjectionCurve>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>Swap</Type>"\
"          <Quotes>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/2Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/3Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/4Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/5Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/6Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/7Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/8Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/9Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/10Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/12Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/15Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/20Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/25Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/3M/30Y</Quote>"\
"          </Quotes>"\
"          <Conventions>USD-3M-SWAP-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>USD3M</ProjectionCurve>"\
"        </Simple>"\
"      </Segments>"\
"    </YieldCurve>"\
"    <YieldCurve>"\
"      <CurveId>EUR6M</CurveId>"\
"      <CurveDescription/>"\
"      <Currency>EUR</Currency>"\
"      <DiscountCurve>EUR1D</DiscountCurve>"\
"      <Segments>"\
"        <Simple>"\
"          <Type>Deposit</Type>"\
"          <Quotes>"\
"            <Quote>MM/RATE/EUR/2D/6M</Quote>"\
"          </Quotes>"\
"          <Conventions>EUR-EURIBOR-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>EUR6M</ProjectionCurve>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>FRA</Type>"\
"          <Quotes>"\
"          </Quotes>"\
"          <Conventions>EUR-6M-FRA-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>EUR6M</ProjectionCurve>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>Swap</Type>"\
"          <Quotes>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/2Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/3Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/4Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/5Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/7Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/10Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/12Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/15Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/20Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/25Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/30Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/40Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/6M/50Y</Quote>"\
"          </Quotes>"\
"          <Conventions>EUR-6M-SWAP-CONVENTIONS</Conventions>"\
"          <ProjectionCurve>EUR6M</ProjectionCurve>"\
"        </Simple>"\
"      </Segments>"\
"    </YieldCurve>"\
"    <YieldCurve>"\
"      <CurveId>USD1D</CurveId>"\
"      <CurveDescription>USD discount curve bootstrapped from FED FUNDS swap rates</CurveDescription>"\
"      <Currency>USD</Currency>"\
"      <DiscountCurve>USD1D</DiscountCurve>"\
"      <Segments>"\
"        <Simple>"\
"          <Type>Deposit</Type>"\
"          <Quotes>"\
"            <Quote>MM/RATE/USD/0D/1D</Quote>"\
"          </Quotes>"\
"          <Conventions>USD-FED-FUNDS-CONVENTIONS</Conventions>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>OIS</Type>"\
"          <Quotes>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/1M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/3M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/6M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/9M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/1Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/1Y3M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/1Y6M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/1Y9M</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/2Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/3Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/4Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/5Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/7Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/10Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/12Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/15Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/20Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/25Y</Quote>"\
"            <Quote>IR_SWAP/RATE/USD/2D/1D/30Y</Quote>"\
"          </Quotes>"\
"          <Conventions>USD-OIS-CONVENTIONS</Conventions>"\
"        </Simple>"\
"      </Segments>"\
"      <InterpolationVariable>Discount</InterpolationVariable>"\
"      <InterpolationMethod>LogLinear</InterpolationMethod>"\
"      <YieldCurveDayCounter>A365</YieldCurveDayCounter>"\
"      <Tolerance>0.000000000001</Tolerance>"\
"    </YieldCurve>"\
"    <YieldCurve>"\
"      <CurveId>EUR1D</CurveId>"\
"      <CurveDescription>EUR discount curve bootstrapped from EONIA swap rates</CurveDescription>"\
"      <Currency>EUR</Currency>"\
"      <DiscountCurve>EUR1D</DiscountCurve>"\
"      <Segments>"\
"        <Simple>"\
"          <Type>Deposit</Type>"\
"          <Quotes>"\
"            <Quote>MM/RATE/EUR/0D/1D</Quote>"\
"          </Quotes>"\
"          <Conventions>EUR-EONIA-CONVENTIONS</Conventions>"\
"        </Simple>"\
"        <Simple>"\
"          <Type>OIS</Type>"\
"          <Quotes>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1W</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/2W</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/2M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/3M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/4M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/5M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/6M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/7M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/8M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/9M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/10M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/11M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1Y3M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1Y6M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/1Y9M</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/2Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/3Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/4Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/5Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/6Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/7Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/8Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/9Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/10Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/12Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/15Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/20Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/25Y</Quote>"\
"            <Quote>IR_SWAP/RATE/EUR/2D/1D/30Y</Quote>"\
"          </Quotes>"\
"          <Conventions>EUR-OIS-CONVENTIONS</Conventions>"\
"        </Simple>"\
"      </Segments>"\
"      <InterpolationVariable>Discount</InterpolationVariable>"\
"      <InterpolationMethod>LogLinear</InterpolationMethod>"\
"      <YieldCurveDayCounter>A365</YieldCurveDayCounter>"\
"      <Tolerance>0.000000000001</Tolerance>"\
"    </YieldCurve>"\
"  </YieldCurves>"\
"  <DefaultCurves>"\
"  <DefaultCurve>"\
"    <CurveId>CPTY_A_SR_USD</CurveId>"\
"    <CurveDescription>CPTY_A SR HR USD</CurveDescription>"\
"    <Currency>USD</Currency>"\
"    <Type>HazardRate</Type>"\
"    <DiscountCurve/>"\
"    <DayCounter>A365</DayCounter>"\
"    <RecoveryRate>RECOVERY_RATE/RATE/CPTY_A/SR/USD</RecoveryRate>"\
"    <Quotes>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/0Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/1Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/2Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/3Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/4Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/5Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/7Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/10Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/15Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/20Y</Quote>"\
"      <Quote>HAZARD_RATE/RATE/CPTY_A/SR/USD/30Y</Quote>"\
"    </Quotes>"\
"    <Conventions>CDS-STANDARD-CONVENTIONS</Conventions>"\
"  </DefaultCurve>"\
"  </DefaultCurves>"\
"</CurveConfiguration>"

pricingEngineXML =\
"<PricingEngines>"\
"<Product type='Swap'>"\
"  <Model>DiscountedCashflows</Model>"\
"  <ModelParameters/>"\
"  <Engine>DiscountingSwapEngineOptimised</Engine>"\
"  <EngineParameters/>"\
"</Product>"\
"</PricingEngines>"

todaysMarketXML = \
"<TodaysMarket>"\
"<YieldCurves id='default'>"\
"</YieldCurves>"\
"<DiscountingCurves id='default'>"\
"  <DiscountingCurve currency='EUR'>Yield/EUR/EUR6M</DiscountingCurve>"\
"  <DiscountingCurve currency='USD'>Yield/USD/USD3M</DiscountingCurve>"\
"</DiscountingCurves>"\
"<IndexForwardingCurves id='default'>"\
"  <Index name='EUR-EURIBOR-3M'>Yield/EUR/EUR6M</Index>"\
"  <Index name='EUR-EURIBOR-6M'>Yield/EUR/EUR6M</Index>"\
"  <Index name='EUR-EONIA'>Yield/EUR/EUR1D</Index>"\
"  <Index name='USD-FedFunds'>Yield/USD/USD1D</Index>"\
"  <Index name='USD-LIBOR-3M'>Yield/USD/USD3M</Index>"\
"</IndexForwardingCurves>"\
"<SwapIndexCurves id='default'>"\
"  <SwapIndex name='EUR-CMS-1Y'>"\
"    <Discounting>EUR-EONIA</Discounting>"\
"  </SwapIndex>"\
"  <SwapIndex name='EUR-CMS-30Y'>"\
"    <Discounting>EUR-EONIA</Discounting>"\
"  </SwapIndex>"\
"  <SwapIndex name='USD-CMS-1Y'>"\
"    <Discounting>USD-FedFunds</Discounting>"\
"  </SwapIndex>"\
"  <SwapIndex name='USD-CMS-30Y'>"\
"    <Discounting>USD-FedFunds</Discounting>"\
"  </SwapIndex>"\
"</SwapIndexCurves>"\
"<FxSpots id='default'>"\
"  <FxSpot pair='EURUSD'>FX/EUR/USD</FxSpot>"\
"</FxSpots>"\
"<FxVolatilities id='default'>"\
"  <FxVolatility pair='EURUSD'>FXVolatility/EUR/USD/EURUSD</FxVolatility>"\
"</FxVolatilities>"\
"<SwaptionVolatilities id='default'>"\
"  <SwaptionVolatility currency='EUR'>SwaptionVolatility/EUR/EUR_SW_N</SwaptionVolatility>"\
"  <SwaptionVolatility currency='USD'>SwaptionVolatility/USD/USD_SW_N</SwaptionVolatility>"\
"</SwaptionVolatilities>"\
"<DefaultCurves id='default'>"\
"  <DefaultCurve name='CPTY_A'>Default/USD/CPTY_A_SR_USD</DefaultCurve>"\
"</DefaultCurves>"\
"</TodaysMarket>"

simMarketXML =\
"<Simulation>"\
"<Market>"\
"  <BaseCurrency>EUR</BaseCurrency>"\
"    <Currencies>"\
"      <Currency>EUR</Currency>"\
"      <Currency>USD</Currency>"\
"    </Currencies>"\
"  <YieldCurves>"\
"    <Configuration>"\
"      <Tenors>3M,6M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,12Y,15Y,20Y</Tenors>"\
"      <Interpolation>LogLinear</Interpolation>"\
"      <Extrapolation>Y</Extrapolation>"\
"    </Configuration>"\
"  </YieldCurves>"\
"  <Indices>"\
"    <Index>EUR-EURIBOR-6M</Index>"\
"    <Index>EUR-EURIBOR-3M</Index>"\
"    <Index>EUR-EONIA</Index>"\
"    <Index>USD-LIBOR-3M</Index>"\
"  </Indices>"\
"  <SwapIndices>"\
"    <SwapIndex>"\
"      <Name>EUR-CMS-1Y</Name>"\
"      <DiscountingIndex>EUR-EONIA</DiscountingIndex>"\
"    </SwapIndex>"\
"    <SwapIndex>"\
"      <Name>EUR-CMS-30Y</Name>"\
"      <DiscountingIndex>EUR-EONIA</DiscountingIndex>"\
"    </SwapIndex>"\
"  </SwapIndices>"\
"  <DefaultCurves>"\
"    <Names/>"\
"    <Tenors>6M,1Y,2Y</Tenors>"\
"  </DefaultCurves>"\
"  <AggregationScenarioDataCurrencies>"\
"    <Currency>EUR</Currency>"\
"    <Currency>USD</Currency>"\
"  </AggregationScenarioDataCurrencies>"\
"  <AggregationScenarioDataIndices>"\
"    <Index>EUR-EURIBOR-3M</Index>"\
"    <Index>EUR-EONIA</Index>"\
"    <Index>USD-LIBOR-3M</Index>"\
"  </AggregationScenarioDataIndices>"\
"</Market>"\
"</Simulation>"

scenarioGeneratorXML =\
"<Simulation>"\
"  <Parameters>"\
"    <Discretization>Exact</Discretization>"\
"    <Grid>81,3M</Grid>"\
"    <Calendar>EUR</Calendar>"\
"    <Sequence>SobolBrownianBridge</Sequence>"\
"    <Scenario>Simple</Scenario>"\
"    <Seed>42</Seed>"\
"    <Samples>100</Samples>"\
"  </Parameters>"\
"</Simulation>"

crossAssetModelXML =\
"<Simulation>"\
"<CrossAssetModel>"\
"  <DomesticCcy>EUR</DomesticCcy>"\
"  <Currencies>"\
"    <Currency>EUR</Currency>"\
"    <Currency>USD</Currency>"\
"  </Currencies>"\
"  <BootstrapTolerance>0.0001</BootstrapTolerance>"\
"  <InterestRateModels>"\
"    <LGM ccy='default'>"\
"      <CalibrationType>Bootstrap</CalibrationType>"\
"      <Volatility>"\
"        <Calibrate>Y</Calibrate>"\
"        <VolatilityType>Hagan</VolatilityType>"\
"        <ParamType>Piecewise</ParamType>"\
"        <TimeGrid>1.0,2.0,3.0,4.0,5.0,7.0,10.0</TimeGrid>"\
"        <InitialValue>0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01</InitialValue>"\
"      </Volatility>"\
"      <Reversion>"\
"        <Calibrate>N</Calibrate>"\
"        <ReversionType>HullWhite</ReversionType>"\
"        <ParamType>Constant</ParamType>"\
"        <TimeGrid/>"\
"        <InitialValue>0.03</InitialValue>"\
"      </Reversion>"\
"      <CalibrationSwaptions>"\
"        <Expiries> 1Y,  2Y,  4Y,  6Y,  8Y, 10Y, 12Y, 14Y, 16Y, 18Y, 19Y</Expiries>"\
"        <Terms>   19Y, 18Y, 16Y, 14Y, 12Y, 10Y,  8Y,  6Y,  4Y,  2Y,  1Y</Terms>"\
"        <Strikes/>"\
"      </CalibrationSwaptions>"\
"      <ParameterTransformation>"\
"        <ShiftHorizon>0.0</ShiftHorizon>"\
"        <Scaling>1.0</Scaling>"\
"      </ParameterTransformation>"\
"   </LGM>"\
"  </InterestRateModels>"\
"  <ForeignExchangeModels>"\
"    <CrossCcyLGM foreignCcy='default'>"\
"      <DomesticCcy>EUR</DomesticCcy>"\
"      <CalibrationType>Bootstrap</CalibrationType>"\
"      <Sigma>"\
"        <Calibrate>Y</Calibrate>"\
"        <ParamType>Piecewise</ParamType>"\
"        <TimeGrid>1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 10.0</TimeGrid>"\
"        <InitialValue>0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1</InitialValue>"\
"      </Sigma>"\
"      <CalibrationOptions>"\
"        <Expiries>1Y, 2Y, 3Y, 4Y, 5Y, 10Y</Expiries>"\
"        <Strikes/>"\
"      </CalibrationOptions>"\
"    </CrossCcyLGM>"\
"  </ForeignExchangeModels>"\
"  <InstantaneousCorrelations>"\
"    <Correlation factor1='IR:EUR' factor2='IR:USD'>0.3</Correlation>"\
"    <Correlation factor1='IR:EUR' factor2='FX:USDEUR'>0</Correlation>"\
"    <Correlation factor1='IR:USD' factor2='FX:USDEUR'>0</Correlation>"\
"  </InstantaneousCorrelations>"\
"</CrossAssetModel>"\
"</Simulation>"

simulationPricingEngineXML = pricingEngineXML

amcPricingEngineXML = "<PricingEngines></PricingEngines>"

nettingSetManagerXML =\
"<NettingSetDefinitions>"\
"  <NettingSet>"\
"    <NettingSetId>CPTY_A</NettingSetId>"\
"    <Counterparty>CPTY_A</Counterparty>"\
"    <ActiveCSAFlag>false</ActiveCSAFlag>"\
"    <CSADetails>"\
"      <Bilateral>Bilateral</Bilateral>"\
"      <CSACurrency>EUR</CSACurrency>"\
"      <Index>EUR-EONIA</Index>"\
"      <ThresholdPay>0</ThresholdPay>"\
"      <ThresholdReceive>0</ThresholdReceive>"\
"      <MinimumTransferAmountPay>0</MinimumTransferAmountPay>"\
"      <MinimumTransferAmountReceive>0</MinimumTransferAmountReceive>"\
"      <IndependentAmount>"\
"        <IndependentAmountHeld>0</IndependentAmountHeld>"\
"        <IndependentAmountType>FIXED</IndependentAmountType>"\
"      </IndependentAmount>"\
"      <MarginingFrequency>"\
"        <CallFrequency>1D</CallFrequency>"\
"        <PostFrequency>1D</PostFrequency>"\
"      </MarginingFrequency>"\
"      <MarginPeriodOfRisk>2W</MarginPeriodOfRisk>"\
"      <CollateralCompoundingSpreadReceive>0.00</CollateralCompoundingSpreadReceive>"\
"      <CollateralCompoundingSpreadPay>0.00</CollateralCompoundingSpreadPay>"\
"      <EligibleCollaterals>"\
"        <Currencies>"\
"          <Currency>EUR</Currency>"\
"        </Currencies>"\
"      </EligibleCollaterals>"\
"    </CSADetails>"\
"  </NettingSet>"\
"</NettingSetDefinitions>"

marketData = [
"20160205 MM/RATE/EUR/0D/1D -0.001122",
"20160205 MM/RATE/EUR/2D/6M 0.000246",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1M -0.00181",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1W -0.00117",
"20160205 IR_SWAP/RATE/EUR/2D/1D/2M -0.002086",
"20160205 IR_SWAP/RATE/EUR/2D/1D/2W -0.001248",
"20160205 IR_SWAP/RATE/EUR/2D/1D/3D -0.001852",
"20160205 IR_SWAP/RATE/EUR/2D/1D/3M -0.002343",
"20160205 IR_SWAP/RATE/EUR/2D/1D/3W -0.001253",
"20160205 IR_SWAP/RATE/EUR/2D/1D/4M -0.002456",
"20160205 IR_SWAP/RATE/EUR/2D/1D/5M -0.002693",
"20160205 IR_SWAP/RATE/EUR/2D/1D/6M -0.002579",
"20160205 IR_SWAP/RATE/EUR/2D/1D/7M -0.002799",
"20160205 IR_SWAP/RATE/EUR/2D/1D/8M -0.002835",
"20160205 IR_SWAP/RATE/EUR/2D/1D/9M -0.00306",
"20160205 IR_SWAP/RATE/EUR/2D/1D/10M -0.003113",
"20160205 IR_SWAP/RATE/EUR/2D/1D/11M -0.003142",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1Y -0.003134",
"20160205 IR_SWAP/RATE/EUR/2D/1D/2Y -0.003465",
"20160205 IR_SWAP/RATE/EUR/2D/1D/3Y -0.003095",
"20160205 IR_SWAP/RATE/EUR/2D/1D/4Y -0.002482",
"20160205 IR_SWAP/RATE/EUR/2D/1D/5Y -0.001745",
"20160205 IR_SWAP/RATE/EUR/2D/1D/6Y -0.000663",
"20160205 IR_SWAP/RATE/EUR/2D/1D/7Y 0.000506",
"20160205 IR_SWAP/RATE/EUR/2D/1D/8Y 0.001668",
"20160205 IR_SWAP/RATE/EUR/2D/1D/9Y 0.002792",
"20160205 IR_SWAP/RATE/EUR/2D/1D/10Y 0.003885",
"20160205 IR_SWAP/RATE/EUR/2D/1D/11Y 0.004756",
"20160205 IR_SWAP/RATE/EUR/2D/1D/12Y 0.005534",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1Y3M -0.003315",
"20160205 IR_SWAP/RATE/EUR/2D/1D/15Y 0.007364",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1Y6M -0.003327",
"20160205 IR_SWAP/RATE/EUR/2D/1D/20Y 0.008899",
"20160205 IR_SWAP/RATE/EUR/2D/1D/1Y9M -0.003356",
"20160205 IR_SWAP/RATE/EUR/2D/1D/25Y 0.009418",
"20160205 IR_SWAP/RATE/EUR/2D/1D/30Y 0.009692",
"20160205 IR_SWAP/RATE/EUR/2D/1D/40Y 0.009853",
"20160205 IR_SWAP/RATE/EUR/2D/1D/50Y 0.009208",
"20160205 IR_SWAP/RATE/EUR/2D/6M/2Y -0.000466",
"20160205 IR_SWAP/RATE/EUR/2D/6M/3Y -0.000156",
"20160205 IR_SWAP/RATE/EUR/2D/6M/4Y 0.00063",
"20160205 IR_SWAP/RATE/EUR/2D/6M/5Y 0.001522",
"20160205 IR_SWAP/RATE/EUR/2D/6M/6Y 0.002481",
"20160205 IR_SWAP/RATE/EUR/2D/6M/7Y 0.003689",
"20160205 IR_SWAP/RATE/EUR/2D/6M/8Y 0.004815",
"20160205 IR_SWAP/RATE/EUR/2D/6M/9Y 0.005884",
"20160205 IR_SWAP/RATE/EUR/2D/6M/10Y 0.006948",
"20160205 IR_SWAP/RATE/EUR/2D/6M/11Y 0.007614",
"20160205 IR_SWAP/RATE/EUR/2D/6M/12Y 0.008324",
"20160205 IR_SWAP/RATE/EUR/2D/6M/13Y 0.008966",
"20160205 IR_SWAP/RATE/EUR/2D/6M/14Y 0.009591",
"20160205 IR_SWAP/RATE/EUR/2D/6M/15Y 0.009959",
"20160205 IR_SWAP/RATE/EUR/2D/6M/16Y 0.010385",
"20160205 IR_SWAP/RATE/EUR/2D/6M/17Y 0.010706",
"20160205 IR_SWAP/RATE/EUR/2D/6M/18Y 0.010931",
"20160205 IR_SWAP/RATE/EUR/2D/6M/19Y 0.011189",
"20160205 IR_SWAP/RATE/EUR/2D/6M/20Y 0.011244",
"20160205 IR_SWAP/RATE/EUR/2D/6M/21Y 0.011529",
"20160205 IR_SWAP/RATE/EUR/2D/6M/22Y 0.011633",
"20160205 IR_SWAP/RATE/EUR/2D/6M/23Y 0.011589",
"20160205 IR_SWAP/RATE/EUR/2D/6M/24Y 0.011738",
"20160205 IR_SWAP/RATE/EUR/2D/6M/25Y 0.011601",
"20160205 IR_SWAP/RATE/EUR/2D/6M/26Y 0.011672",
"20160205 IR_SWAP/RATE/EUR/2D/6M/27Y 0.011619",
"20160205 IR_SWAP/RATE/EUR/2D/6M/28Y 0.011626",
"20160205 IR_SWAP/RATE/EUR/2D/6M/29Y 0.011575",
"20160205 IR_SWAP/RATE/EUR/2D/6M/30Y 0.011548",
"20160205 IR_SWAP/RATE/EUR/2D/6M/40Y 0.011414",
"20160205 IR_SWAP/RATE/EUR/2D/6M/50Y 0.010841",
"20160205 MM/RATE/USD/0D/1D 0.00448",
"20160205 MM/RATE/USD/2D/1M 0.007411",
"20160205 MM/RATE/USD/2D/1W 0.005809",
"20160205 MM/RATE/USD/0D/2D 0.005598",
"20160205 MM/RATE/USD/2D/2M 0.009422",
"20160205 MM/RATE/USD/2D/2W 0.006034",
"20160205 MM/RATE/USD/2D/3M 0.007961",
"20160205 MM/RATE/USD/2D/6M 0.008047",
"20160205 MM/RATE/USD/2D/3W 0.006156",
"20160205 IR_SWAP/RATE/USD/2D/1D/1M 0.004458",
"20160205 IR_SWAP/RATE/USD/2D/1D/1W 0.004473",
"20160205 IR_SWAP/RATE/USD/2D/1D/2M 0.00479",
"20160205 IR_SWAP/RATE/USD/2D/1D/2W 0.004587",
"20160205 IR_SWAP/RATE/USD/2D/1D/3M 0.004851",
"20160205 IR_SWAP/RATE/USD/2D/1D/3W 0.004491",
"20160205 IR_SWAP/RATE/USD/2D/1D/4M 0.004863",
"20160205 IR_SWAP/RATE/USD/2D/1D/5M 0.004999",
"20160205 IR_SWAP/RATE/USD/2D/1D/6M 0.005237",
"20160205 IR_SWAP/RATE/USD/2D/1D/7M 0.005175",
"20160205 IR_SWAP/RATE/USD/2D/1D/8M 0.005371",
"20160205 IR_SWAP/RATE/USD/2D/1D/9M 0.005471",
"20160205 IR_SWAP/RATE/USD/2D/1D/10M 0.005521",
"20160205 IR_SWAP/RATE/USD/2D/1D/11M 0.005605",
"20160205 IR_SWAP/RATE/USD/2D/1D/1Y 0.005614",
"20160205 IR_SWAP/RATE/USD/2D/1D/2Y 0.006433",
"20160205 IR_SWAP/RATE/USD/2D/1D/3Y 0.007101",
"20160205 IR_SWAP/RATE/USD/2D/1D/4Y 0.008264",
"20160205 IR_SWAP/RATE/USD/2D/1D/5Y 0.009269",
"20160205 IR_SWAP/RATE/USD/2D/1D/7Y 0.011035",
"20160205 IR_SWAP/RATE/USD/2D/1D/10Y 0.013318",
"20160205 IR_SWAP/RATE/USD/2D/1D/12Y 0.01459",
"20160205 IR_SWAP/RATE/USD/2D/1D/1Y3M 0.005857",
"20160205 IR_SWAP/RATE/USD/2D/1D/15Y 0.016029",
"20160205 IR_SWAP/RATE/USD/2D/1D/1Y6M 0.006054",
"20160205 IR_SWAP/RATE/USD/2D/1D/20Y 0.01734",
"20160205 IR_SWAP/RATE/USD/2D/1D/1Y9M 0.006097",
"20160205 IR_SWAP/RATE/USD/2D/1D/25Y 0.01804",
"20160205 IR_SWAP/RATE/USD/2D/1D/30Y 0.018326",
"20160205 IR_SWAP/RATE/USD/2D/1D/50Y 0.0182",
"20160205 IR_SWAP/RATE/USD/2D/3M/2Y 0.009268",
"20160205 IR_SWAP/RATE/USD/2D/3M/3Y 0.010244",
"20160205 IR_SWAP/RATE/USD/2D/3M/4Y 0.011307",
"20160205 IR_SWAP/RATE/USD/2D/3M/5Y 0.012404",
"20160205 IR_SWAP/RATE/USD/2D/3M/6Y 0.013502",
"20160205 IR_SWAP/RATE/USD/2D/3M/7Y 0.014357",
"20160205 IR_SWAP/RATE/USD/2D/3M/8Y 0.015181",
"20160205 IR_SWAP/RATE/USD/2D/3M/9Y 0.016063",
"20160205 IR_SWAP/RATE/USD/2D/3M/10Y 0.016805",
"20160205 IR_SWAP/RATE/USD/2D/3M/12Y 0.018038",
"20160205 IR_SWAP/RATE/USD/2D/3M/15Y 0.019323",
"20160205 IR_SWAP/RATE/USD/2D/3M/20Y 0.020666",
"20160205 IR_SWAP/RATE/USD/2D/3M/25Y 0.021296",
"20160205 IR_SWAP/RATE/USD/2D/3M/30Y 0.021745",
"20160205 IR_SWAP/RATE/USD/2D/3M/40Y 0.021951",
"20160205 IR_SWAP/RATE/USD/2D/3M/50Y 0.021741",
"20160205 FRA/RATE/USD/3M/3M 0.008132",
"20160205 FRA/RATE/USD/6M/3M 0.00858",
"20160205 FRA/RATE/USD/9M/3M 0.009141",
"20160205 FRA/RATE/USD/1Y/3M 0.009594",
"20160205 FX/RATE/EUR/USD 1.132337",
"20160205 SWAPTION/RATE_NVOL/EUR/1Y/10Y/ATM 0.006978",
"20160205 SWAPTION/RATE_NVOL/EUR/1Y/1Y/ATM 0.003543",
"20160205 SWAPTION/RATE_NVOL/EUR/1Y/5Y/ATM 0.00527",
"20160205 SWAPTION/RATE_NVOL/EUR/5Y/10Y/ATM 0.00782",
"20160205 SWAPTION/RATE_NVOL/EUR/5Y/1Y/ATM 0.007013",
"20160205 SWAPTION/RATE_NVOL/EUR/5Y/5Y/ATM 0.007443",
"20160205 SWAPTION/RATE_NVOL/EUR/10Y/10Y/ATM 0.007611",
"20160205 SWAPTION/RATE_NVOL/EUR/10Y/1Y/ATM 0.007668",
"20160205 SWAPTION/RATE_NVOL/EUR/10Y/5Y/ATM 0.007705",
"20160205 SWAPTION/RATE_LNVOL/USD/1Y/10Y/ATM 0.522381",
"20160205 SWAPTION/RATE_LNVOL/USD/1Y/1Y/ATM 0.742497",
"20160205 SWAPTION/RATE_LNVOL/USD/1Y/5Y/ATM 0.665892",
"20160205 SWAPTION/RATE_LNVOL/USD/5Y/10Y/ATM 0.413209",
"20160205 SWAPTION/RATE_LNVOL/USD/5Y/1Y/ATM 0.562741",
"20160205 SWAPTION/RATE_LNVOL/USD/5Y/5Y/ATM 0.466931",
"20160205 SWAPTION/RATE_LNVOL/USD/10Y/10Y/ATM 0.343264",
"20160205 SWAPTION/RATE_LNVOL/USD/10Y/1Y/ATM 0.38573",
"20160205 SWAPTION/RATE_LNVOL/USD/10Y/5Y/ATM 0.368886",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/30Y/ATM 0.173742",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/7Y/ATM 0.132847",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/9M/ATM 0.121563",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/1W/ATM 0.114403",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/18M/ATM 0.121216",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/3Y/ATM 0.122993",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/10Y/ATM 0.13628",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/2M/ATM 0.1196",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/3M/ATM 0.115589",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/1Y/ATM 0.120825",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/4Y/ATM 0.126561",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/5Y/ATM 0.129459",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/1M/ATM 0.121699",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/2Y/ATM 0.120465",
"20160205 FX_OPTION/RATE_LNVOL/EUR/USD/6M/ATM 0.121982",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/0Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/1Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/2Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/3Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/4Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/5Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/7Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/10Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/15Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/20Y 0.01",
"20160205 HAZARD_RATE/RATE/CPTY_A/SR/USD/30Y 0.01",
"20160205 RECOVERY_RATE/RATE/CPTY_A/SR/USD 0.4",
]

fixingData = [
"20150202 EUR-EONIA -0.00024", 
"20150202 EUR-EURIBOR-3M 0.00055",
"20150202 EUR-EURIBOR-6M 0.00134"
]

asof = "2016-02-05"
outputPath = "Output"
logFile = "log.txt"
logMask = 15

print ("Build input parameters...")

inputs = InputParameters()
inputs.setAsOfDate(asof);
inputs.setResultsPath(outputPath)
inputs.setBaseCurrency("EUR")
inputs.setConventions(conventionsXML)
inputs.setCurveConfigs(curveConfigXML)
inputs.setPricingEngine(pricingEngineXML)
inputs.setTodaysMarketParams(todaysMarketXML)
inputs.setRefDataManager(refDataXML)
inputs.setPortfolio(portfolioXML)
inputs.setThreads(1)
inputs.setEntireMarket(True)
inputs.setAllFixings(True)

inputs.setAmc(False)
inputs.setExposureBaseCurrency("EUR")
inputs.setExposureSimMarketParams(simMarketXML)
inputs.setScenarioGeneratorData(scenarioGeneratorXML)
inputs.setCrossAssetModelData(crossAssetModelXML)
inputs.setSimulationPricingEngine(simulationPricingEngineXML)
inputs.setAmcPricingEngine(amcPricingEngineXML)
inputs.setNettingSetManager(nettingSetManagerXML)
inputs.setWriteCube(True)
inputs.setXvaBaseCurrency("EUR")
inputs.setExposureProfiles(True)
inputs.setExposureProfilesByTrade(False)
inputs.setCvaAnalytic(True)

inputs.setAnalytics("NPV,CASHFLOW,XVA,EXPOSURE")

print ("Initialise ORE...")
ore = OREApp(inputs, logFile, logMask);

print ("Running ORE process...");
ore.run(marketData, fixingData)

print ("Running ORE process done");

############################################################
# Alternatively, read inputs from files and kick off ORE run

#params = Parameters()
#params.fromFile("Input/ore.xml")

#print ("Creating OREApp...")
#ore = OREApp(params)

#print ("Running ORE process...");
#ore.run()

#print ("Running ORE process done");

###########################################
# Check the analytics we have requested/run

print ("\nRequested analytics:")
analyticTypes = ore.getAnalyticTypes()
for name in analyticTypes:
    print("analytc:", name)

print("\npress <enter> ...")
sys.stdin.readline()

#####################################
# List all results, reports and cubes

print ("Result reports:");
reportNames = ore.getReportNames()
for name in reportNames:
    print("report:", name)

print ("\nResult cubes:");
cubeNames = ore.getCubeNames()
for name in cubeNames:
    print("cube:", name)

print("\npress <enter> ...")
sys.stdin.readline()

#######################
# Access report details

# pick one
reportName = "exposure_nettingset_CPTY_A"
print ("Load report", reportName)
report = ore.getReport(reportName)

# see PlainInMemoryReport
columnTypes = { 0: "Size",
                1: "Real",
                2: "string",
                3: "Date",
                4: "Period" }

print ("columns:", report.columns())
print ("rows:", report.rows())
for i in range(0, report.columns()):
    print("colum", i, "header", report.header(i), "type", report.columnType(i), columnTypes[report.columnType(i)])

print("\npress <enter> ...")
sys.stdin.readline()

time = report.dataAsReal(2);
epe = report.dataAsReal(3);
ene = report.dataAsReal(4);
print ("#Time", "EPE")
for i in range(0, report.rows()):
    print("%5.2f  %12.2f  %12.2f" % (time[i], epe[i], ene[i]))

print("\npress <enter> ...")
sys.stdin.readline()

#####################
# Access cube details

cubeName = "cube"
print ("Load NPV cube:", cubeName)
cube = ore.getCube(cubeName)
print ("cube ids:", cube.numIds())
print ("cube samples:", cube.samples())
print ("cube dates:", cube.numDates())
print ("cube depth:", cube.depth())

print("\npress <enter> ...")
sys.stdin.readline()

cubeIds = cube.ids() 
cubeDates = cube.dates()

for i in range (0, cube.numIds()):
    for j in range (0, cube.numDates()):
        for k in range (0, cube.samples()):
            for d in range (0, cube.depth()):
                npv = cube.get(i, j, k, d)
                print ("%s %s %4d %d %10.2f" % (cubeIds[i], cubeDates[j].ISO(), k, d, npv))

###########################################################
# Access one analytic e.g. to query the market or portfolio

print("\npress <enter> ...")
sys.stdin.readline()

print("Inspect NPV analytic ...")
analytic = ore.getAnalytic("NPV")
market  = analytic.getMarket()

print("Market asof:", market.asofDate())

curve = market.discountCurve("EUR")
print("EUR discount factor at 10Y =", curve.discount(10 * Years))

portfolio = analytic.portfolio()
tradeIds = portfolio.ids();
print("Portfolio size:", portfolio.size())

for tid in tradeIds:
    trade = portfolio.get(tid)
    print("trade id=%s type=%s" % (trade.id(), trade.tradeType()))
    
print("Done")
