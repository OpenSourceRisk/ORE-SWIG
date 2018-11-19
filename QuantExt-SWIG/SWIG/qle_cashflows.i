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
        const FxIndexPtr index() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->index();
        }
        bool invertIndex() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->invertIndex();
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
        FloatingRateFXLinkedNotionalCouponPtr(QuantLib::Real foreignAmount, 
                                              const QuantLib::Date& fxFixingDate, 
                                              FxIndexPtr fxIndex,
                                              bool invertFxIndex, 
                                              const QuantLib::Date& paymentDate, 
                                              const QuantLib::Date& startDate,
                                              const QuantLib::Date& endDate, 
                                              QuantLib::Natural fixingDays,
                                              const InterestRateIndexPtr& index, 
                                              QuantLib::Real gearing = 1.0,
                                              QuantLib::Spread spread = 0.0, 
                                              const QuantLib::Date& refPeriodStart = QuantLib::Date(),
                                              const QuantLib::Date& refPeriodEnd = QuantLib::Date(), 
                                              const QuantLib::DayCounter& dayCounter = QuantLib::DayCounter(),
                                              bool isInArrears = false) {
            boost::shared_ptr<FxIndex> FXIndex = boost::dynamic_pointer_cast<FxIndex>(fxIndex);
            boost::shared_ptr<InterestRateIndex> floatIndex = boost::dynamic_pointer_cast<InterestRateIndex>(index);
            return new FloatingRateFXLinkedNotionalCouponPtr(
                new FloatingRateFXLinkedNotionalCoupon(foreignAmount,
                                                       fxFixingDate,
                                                       FXIndex,
                                                       invertFxIndex,
                                                       paymentDate,
                                                       startDate,
                                                       endDate,
                                                       fixingDays,
                                                       floatIndex,
                                                       gearing,
                                                       spread,
                                                       refPeriodStart,
                                                       refPeriodEnd,
                                                       dayCounter,
                                                       isInArrears));
        }
        const FXLinkedCashFlow& fxLinkedCashFlow() {
            return boost::dynamic_pointer_cast<FloatingRateFXLinkedNotionalCoupon>(*self)->fxLinkedCashFlow();
        }
    }
};

#endif
