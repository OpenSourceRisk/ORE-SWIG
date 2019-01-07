/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_cashflows_i
#define qle_cashflows_i

%include date.i
%include types.i
%include calendars.i
%include daycounters.i
%include indexes.i
%include termstructures.i
%include scheduler.i
%include vectors.i
%include cashflows.i
%include qle_indexes.i

%{
using QuantExt::FXLinkedCashFlow;
using QuantExt::FloatingRateFXLinkedNotionalCoupon;

typedef boost::shared_ptr<CashFlow> FXLinkedCashFlowPtr;
typedef boost::shared_ptr<CashFlow> FloatingRateFXLinkedNotionalCouponPtr;
%}

%rename(FXLinkedCashFlow) FXLinkedCashFlowPtr;
class FXLinkedCashFlowPtr : public boost::shared_ptr<CashFlow> {
public:
    %extend{
        FXLinkedCashFlowPtr(const QuantLib::Date& cashFlowDate, 
                            const QuantLib::Date& fixingDate, 
                            QuantLib::Real foreignAmount,
                            FxIndexPtr fxIndex, 
                            bool invertIndex = false) {
            boost::shared_ptr<FxIndex> FXIndex = boost::dynamic_pointer_cast<FxIndex>(fxIndex);
            return new FXLinkedCashFlowPtr(
                new FXLinkedCashFlow(cashFlowDate,
                                     fixingDate,
                                     foreignAmount,
                                     FXIndex,
                                     invertIndex));
        }
        QuantLib::Date fxFixingDate() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->fxFixingDate();
        }
        const FxIndexPtr fxIndex() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->fxIndex();
        }
        bool invertFxIndex() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->invertFxIndex();
        }
        QuantLib::Real fxRate() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->fxRate();
        }
    }
};

%rename(FloatingRateFXLinkedNotionalCoupon) FloatingRateFXLinkedNotionalCouponPtr;
class FloatingRateFXLinkedNotionalCouponPtr : public FloatingRateCouponPtr {
public:
    %extend{
        FloatingRateFXLinkedNotionalCouponPtr(const QuantLib::Date& fxFixingDate,
                                              QuantLib::Real foreignAmount,
                                              FxIndexPtr fxIndex,
                                              bool invertFxIndex, 
                                              const FloatingRateCouponPtr underlying) {
            boost::shared_ptr<FxIndex> fxidx = boost::dynamic_pointer_cast<FxIndex>(fxIndex);
            boost::shared_ptr<FloatingRateCoupon> floatCoupon = boost::dynamic_pointer_cast<FloatingRateCoupon>(underlying);
            return new FloatingRateFXLinkedNotionalCouponPtr(
                new FloatingRateFXLinkedNotionalCoupon(fxFixingDate,
                                                       foreignAmount,
                                                       fxidx,
                                                       invertFxIndex,
                                                       floatCoupon));
        }
        
        Real nominal() const { 
            return boost::dynamic_pointer_cast<FloatingRateFXLinkedNotionalCoupon>(*self)->nominal(); 
        }
        Rate rate() const { 
            return boost::dynamic_pointer_cast<FloatingRateFXLinkedNotionalCoupon>(*self)->rate(); 
        }
        Rate indexFixing() const { 
            return boost::dynamic_pointer_cast<FloatingRateFXLinkedNotionalCoupon>(*self)->indexFixing(); 
        }
        void setPricer(const boost::shared_ptr<FloatingRateCouponPricer>& p) {
            return boost::dynamic_pointer_cast<FloatingRateFXLinkedNotionalCoupon>(*self)->setPricer(p);
        }
    }
};

#endif
