/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_ccyswap_i
#define qle_ccyswap_i

%include qle_currencies.i
%include instruments.i
%include termstructures.i
%include money.i
%include marketelements.i
%include exchangerates.i

%{
using QuantExt::CrossCcySwap;
typedef boost::shared_ptr<Instrument> CrossCcySwapPtr;
%}

%rename(CrossCcySwap) CrossCcySwapPtr;
class CrossCcySwapPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
	CrossCcySwapPtr(const QuantLib::Leg& firstLeg,
					const QuantLib::Currency& firstLegCcy,
					const QuantLib::Leg& secondLeg,
					const QuantLib::Currency& secondLegCcy) {
            return new CrossCcySwapPtr(
                new CrossCcySwap(firstLeg,
								 firstLegCcy,
								 secondLeg,
								 secondLegCcy));
				}
	
	    
		
	CrossCcySwapPtr(const std::vector<QuantLib::Leg>& legs,
					const std::vector<bool>& payer,
					const std::vector<QuantLib::Currency>& currencies) {
            return new CrossCcySwapPtr(
                new CrossCcySwap(legs,
								 payer,
								 currencies));
				}
	
	    }
};

%{
using QuantExt:: CrossCcySwapEngine;
typedef boost::shared_ptr<PricingEngine> CrossCcySwapEnginePtr;
%}

%rename(CrossCcySwapEngine) CrossCcySwapEnginePtr;
class CrossCcySwapEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        CrossCcySwapEnginePtr(const QuantLib::Currency& ccy1,
							  const QuantLib::Handle<QuantLib::YieldTermStructure>& currency1DiscountCurve,
							  const QuantLib::Currency& ccy2,
							  const QuantLib::Handle<QuantLib::YieldTermStructure>& currency2DiscountCurve,
							  const QuantLib::Handle<QuantLib::Quote>& spotFX,
							  boost::optional<bool> includeSettlementDateFlows = boost::none,
							  const QuantLib::Date& settlementDate = QuantLib::Date(),
							  const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new CrossCcySwapEnginePtr(
                                  new CrossCcySwapEngine(ccy1,
														 currency1DiscountCurve,
														 ccy2,
														 currency2DiscountCurve,
														 spotFX,
														 includeSettlementDateFlows,
														 settlementDate,
														 npvDate));
        }
    }
};

#endif
