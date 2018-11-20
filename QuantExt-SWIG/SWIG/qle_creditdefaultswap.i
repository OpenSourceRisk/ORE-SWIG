/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_credit_default_swap_i
#define qle_credit_default_swap_i

%include instruments.i
%include credit.i
%include termstructures.i
%include bonds.i
%include null.i
%include creditdefaultswap.i

%{
//using QuantExt::CreditDefaultSwap;
//using QuantExt::MidPointCdsEngine;

typedef boost::shared_ptr<Instrument> QLECreditDefaultSwapPtr;
typedef boost::shared_ptr<PricingEngine> QLEMidPointCdsEnginePtr;
%}

%rename(QLECreditDefaultSwap) QLECreditDefaultSwapPtr;
class QLECreditDefaultSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        QLECreditDefaultSwapPtr(QuantLib::Protection::Side side, 
                                QuantLib::Real notional, 
                                QuantLib::Rate spread, 
                                const QuantLib::Schedule& schedule,
                                QuantLib::BusinessDayConvention paymentConvention, 
                                const QuantLib::DayCounter& dayCounter, 
                                bool settlesAccrual = true,
                                bool paysAtDefaultTime = true, 
                                const QuantLib::Date& protectionStart = QuantLib::Date()) {
            return new QLECreditDefaultSwapPtr(
                new QuantExt::CreditDefaultSwap(side, 
                                                notional, 
                                                spread, 
                                                schedule,
                                                paymentConvention, 
                                                dayCounter,
                                                settlesAccrual, 
                                                paysAtDefaultTime,
                                                protectionStart));
        }
        QLECreditDefaultSwapPtr(QuantLib::Protection::Side side, 
                                QuantLib::Real notional, 
                                QuantLib::Rate upfront, 
                                QuantLib::Rate spread, 
                                const QuantLib::Schedule& schedule,
                                QuantLib::BusinessDayConvention paymentConvention, 
                                const QuantLib::DayCounter& dayCounter, 
                                bool settlesAccrual = true,
                                bool paysAtDefaultTime = true, 
                                const QuantLib::Date& protectionStart = QuantLib::Date(),
                                const QuantLib::Date& upfrontDate = QuantLib::Date()) {
            return new QLECreditDefaultSwapPtr(
                new QuantExt::CreditDefaultSwap(side, 
                                                notional, 
                                                upfront, 
                                                spread,
                                                schedule, 
                                                paymentConvention,
                                                dayCounter, 
                                                settlesAccrual,
                                                paysAtDefaultTime,
                                                protectionStart,
                                                upfrontDate));
        }
        QuantLib::Protection::Side side() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->side();
        }
        QuantLib::Real notional() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->notional();
        }
        QuantLib::Rate runningSpread() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->runningSpread();
        }
        boost::optional<QuantLib::Rate> upfront() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->upfront();
        }
        bool settlesAccrual() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->settlesAccrual();
        }
        bool paysAtDefaultTime() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->paysAtDefaultTime();
        }
        const QuantLib::Leg& coupons() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->coupons();
        }
        const QuantLib::Date& protectionStartDate() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->protectionStartDate();
        }
        const QuantLib::Date& protectionEndDate() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->protectionEndDate();
        }
        QuantLib::Rate fairUpfront() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->fairUpfront();
        }
        QuantLib::Rate fairSpread() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->fairSpread();
        }
       QuantLib::Real couponLegBPS() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->couponLegBPS();
        }
        QuantLib::Real upfrontBPS() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->upfrontBPS();
        }
        QuantLib::Real couponLegNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->couponLegNPV();
        }
        QuantLib::Real defaultLegNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->defaultLegNPV();
        }
        QuantLib::Real upfrontNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->upfrontNPV();
        }
        QuantLib::Real accrualRebateNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->accrualRebateNPV();
        }
        QuantLib::Date maturity() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->maturity();
        }
        QuantLib::Rate impliedHazardRate(QuantLib::Real targetNPV, 
                                         const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                         const QuantLib::DayCounter& dayCounter, 
                                         QuantLib::Real recoveryRate = 0.4, 
                                         QuantLib::Real accuracy = 1.0e-6) const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->impliedHazardRate(targetNPV, 
                                                                                                      discountCurve, 
                                                                                                      dayCounter,
                                                                                                      recoveryRate, 
                                                                                                      accuracy);
        }
        QuantLib::Rate conventionalSpread(QuantLib::Real conventionalRecovery, 
                                          const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                          const QuantLib::DayCounter& dayCounter) const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->conventionalSpread(conventionalRecovery,
                                                                                                       discountCurve,
                                                                                                       dayCounter);
        }
    }
};


%rename(QLEMidPointCdsEngine) QLEMidPointCdsEnginePtr;
class QLEMidPointCdsEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        QLEMidPointCdsEnginePtr(const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability, 
                                QuantLib::Real recoveryRate,
                                const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve) {
            return new QLEMidPointCdsEnginePtr(
                new QuantExt::MidPointCdsEngine(probability, 
                                                recoveryRate,
                                                discountCurve));
        }
    }
};


#endif
