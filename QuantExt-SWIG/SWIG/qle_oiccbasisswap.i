/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_oiccbasisswap_i
#define qle_oiccbasisswap_i

%include instruments.i
%include scheduler.i
%include indexes.i

%{
using QuantExt::OvernightIndexedCrossCcyBasisSwap;
using QuantExt::OvernightIndexedCrossCcyBasisSwapEngine;

typedef boost::shared_ptr<Instrument> OvernightIndexedCrossCcyBasisSwapPtr;
typedef boost::shared_ptr<PricingEngine> OvernightIndexedCrossCcyBasisSwapEnginePtr;
%}

%rename(OvernightIndexedCrossCcyBasisSwap) OvernightIndexedCrossCcyBasisSwapPtr;
class OvernightIndexedCrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
    public:
    %extend {
		OvernightIndexedCrossCcyBasisSwapPtr(QuantLib::Real payNominal,
											  QuantLib::Currency payCurrency,
											  const QuantLib::Schedule& paySchedule,
											  const OvernightIndexPtr& payIndex,
											  QuantLib::Real paySpread,
											  QuantLib::Real recNominal,
											  QuantLib::Currency recCurrency,
											  const QuantLib::Schedule& recSchedule,
											  const OvernightIndexPtr& recIndex,
											  QuantLib::Real recSpread) {
			boost::shared_ptr<OvernightIndex> pIndex = boost::dynamic_pointer_cast<OvernightIndex>(payIndex);
			boost::shared_ptr<OvernightIndex> rIndex = boost::dynamic_pointer_cast<OvernightIndex>(recIndex);			
            return new OvernightIndexedCrossCcyBasisSwapPtr(
                new OvernightIndexedCrossCcyBasisSwap(payNominal,
													  payCurrency,
													  paySchedule,
													  pIndex,
													  paySpread,
													  recNominal,
													  recCurrency,
													  recSchedule,
													  rIndex,
													  recSpread));
		}
		/*Name Inspectors*/
		/*Pay Leg*/
		QuantLib::Real payNominal() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->payNominal(); 
        }
        QuantLib::Currency payCurrency() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->payCurrency(); 
        }
        const QuantLib::Schedule& paySchedule() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->paySchedule(); 
        }
        QuantLib::Real paySpread() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->paySpread(); 
        }
		
		/*Receiver Leg*/
		QuantLib::Real recNominal() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recNominal(); 
        }
        QuantLib::Currency recCurrency() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recCurrency(); 
        }
        const QuantLib::Schedule& recSchedule() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recSchedule(); 
        }
        QuantLib::Real recSpread() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recSpread(); 
        }
		
		/*Other*/
		const QuantLib::Leg& payLeg() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->payLeg(); 
        }
        const QuantLib::Leg& recLeg() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recLeg(); 
        }
		
		/*Name Results*/
		QuantLib::Real payLegBPS() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->payLegBPS(); 
        }
        QuantLib::Real payLegNPV() { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->payLegNPV(); 
        }
		QuantLib::Real fairPayLegSpread() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->fairPayLegSpread(); 
        }
        QuantLib::Real recLegBPS() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recLegBPS(); 
        }
        QuantLib::Real recLegNPV() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->recLegNPV(); 
        }
        QuantLib::Spread fairRecLegSpread() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedCrossCcyBasisSwap>(*self)->fairRecLegSpread(); 
        }
	}
};


%rename(OvernightIndexedCrossCcyBasisSwapEngine) OvernightIndexedCrossCcyBasisSwapEnginePtr;
class OvernightIndexedCrossCcyBasisSwapEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        OvernightIndexedCrossCcyBasisSwapEnginePtr(const QuantLib::Handle<QuantLib::YieldTermStructure>& ts1,
												  const QuantLib::Currency& ccy1,
												  const QuantLib::Handle<QuantLib::YieldTermStructure>& ts2,
												  const QuantLib::Currency& ccy2,
												  const QuantLib::Handle<QuantLib::Quote>& fx) {
            return new OvernightIndexedCrossCcyBasisSwapEnginePtr(
                                  new OvernightIndexedCrossCcyBasisSwapEngine(ts1,
																			 ccy1,
																			 ts2,
																			 ccy2,
																			 fx));
        }
    }
};

#endif
