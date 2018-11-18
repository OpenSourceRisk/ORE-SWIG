/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_averageois_i
#define qle_averageois_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i
%include swap.i

%{
using QuantExt::AverageOIS;
using QuantExt::AverageONIndexedCouponPricer;

typedef boost::shared_ptr<Instrument> AverageOISPtr;
typedef boost::shared_ptr<FloatingRateCouponPricer> AverageONIndexedCouponPricerPtr;
%}

%ignore AverageOIS
class AverageOIS {
  public:
    enum Type { Receiver = -1, Payer = 1 };
};

%rename(AverageOIS) AverageOISPtr;
class AverageOISPtr : public SwapPtr {
  public:
    %extend{
        static const AverageOIS::Type Receiver = AverageOIS::Receiver;
        static const AverageOIS::Type Payer = AverageOIS::Payer;
        AverageOISPtr(AverageOIS::Type type,
                      QuantLib::Real nominal,
                      const QuantLib::Schedule& fixedSchedule,
                      QuantLib::Rate fixedRate,
                      const QuantLib::DayCounter& fixedDayCounter,
                      QuantLib::BusinessDayConvention fixedPaymentAdjustment,
                      const QuantLib::Calendar& fixedPaymentCalendar,
                      const QuantLib::Schedule& onSchedule,
                      const OvernightIndexPtr& overnightIndex,
                      QuantLib::BusinessDayConvention onPaymentAdjustment,
                      const QuantLib::Calendar& onPaymentCalendar,
                      QuantLib::Natural rateCutoff = 0,
                      QuantLib::Spread onSpread = 0.0,
                      QuantLib::Real onGearing = 1.0,
                      const QuantLib::DayCounter& onDayCounter = QuantLib::DayCounter(),
                      const AverageONIndexedCouponPricerPtr& onCouponPricer = boost::shared_ptr<AverageONIndexedCouponPricer>()) {
             boost::shared_ptr<OvernightIndex> floatIndex = boost::dynamic_pointer_cast<OvernightIndex>(overnightIndex);
             return new AverageOISPtr(
                 new AverageOIS(type,
                                nominal,
                                fixedSchedule,
                                fixedRate,
                                fixedDayCounter,
                                fixedPaymentAdjustment,
                                fixedPaymentCalendar,
                                onSchedule,floatIndex,
                                onPaymentAdjustment,
                                onPaymentCalendar,
                                rateCutoff,
                                onSpread,
                                onGearing,
                                onDayCounter,
                                onCouponPricer)); 
        }
        AverageOIS::Type type() { 
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->type(); 
        } 
        QuantLib::Real nominal() { 
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->nominal(); 
        } 
        const std::vector<QuantLib::Real>& nominals() { 
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->nominals(); 
        } 
        QuantLib::Rate fixedRate() { 
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedRate(); 
        } 
        const std::vector<QuantLib::Rate>& fixedRates() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedRates(); 
        } 
        const QuantLib::DayCounter& fixedDayCounter() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedDayCounter(); 
        } 
        QuantLib::Natural rateCutoff() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->rateCutoff(); 
        } 
        QuantLib::Spread onSpread() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->onSpread(); 
        } 
        const std::vector<QuantLib::Spread>& onSpreads() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->onSpreads(); 
        } 
        QuantLib::Real onGearing() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->onGearing(); 
        } 
        const std::vector<QuantLib::Real>& onGearings() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->onGearings(); 
        }
        const QuantLib::DayCounter& onDayCounter() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->onDayCounter(); 
        }
        const QuantLib::Leg& fixedLeg() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedLeg(); 
        }
        const QuantLib::Leg& overnightLeg() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->overnightLeg(); 
        }
        QuantLib::Real fixedLegBPS() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedLegBPS(); 
        }
        QuantLib::Real fixedLegNPV() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fixedLegNPV(); 
        }
        QuantLib::Real fairRate() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fairRate();         
        }
        QuantLib::Real overnightLegBPS() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->overnightLegBPS(); 
        }
        QuantLib::Real overnightLegNPV() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->overnightLegNPV(); 
        }
        QuantLib::Spread fairSpread() {  
            return boost::dynamic_pointer_cast<AverageOIS>(*self)->fairSpread(); 
        }
    }
};

%ignore AverageONIndexedCouponPricer
class AverageONIndexedCouponPricer {
  public:
    enum Approximation { Takada, None };
};

%rename(AverageONIndexedCouponPricer) AverageONIndexedCouponPricerPtr;
class AverageONIndexedCouponPricerPtr : public FloatingRateCouponPricerPtr {
  public:
    %extend{
        static const AverageONIndexedCouponPricer::Approximation Takada = AverageONIndexedCouponPricer::Takada;
        static const AverageONIndexedCouponPricer::Approximation None = AverageONIndexedCouponPricer::None;
        AverageONIndexedCouponPricerPtr(AverageONIndexedCouponPricer::Approximation approxType = Takada) {
             return new AverageONIndexedCouponPricerPtr(
                 new AverageONIndexedCouponPricer(approxType));
        }
        void initialize(const QuantLib::FloatingRateCoupon& coupon) { 
            return boost::dynamic_pointer_cast<AverageONIndexedCouponPricer>(*self)->initialize(); 
        }
        QuantLib::Rate swapletRate() const { 
            return boost::dynamic_pointer_cast<AverageONIndexedCouponPricer>(*self)->swapletRate(); 
        } 
    }
};

#endif
