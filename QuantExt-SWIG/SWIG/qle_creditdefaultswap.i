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
using QuantExt::CdsOption;
using QuantExt::BlackCdsOptionEngine;

typedef boost::shared_ptr<Instrument> QLECreditDefaultSwapPtr;
typedef boost::shared_ptr<PricingEngine> QLEMidPointCdsEnginePtr;
typedef boost::shared_ptr<PricingEngine> BlackCdsOptionEnginePtr;
typedef boost::shared_ptr<Instrument> CdsOptionPtr;
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
                                QuantExt::CreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime = QuantExt::CreditDefaultSwap::atDefault,
                                const QuantLib::Date& protectionStart = QuantLib::Date(), 
                                const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>(),
				const DayCounter& lastPeriodDayCounter = DayCounter()) {
            return new QLECreditDefaultSwapPtr(
                new QuantExt::CreditDefaultSwap(side, 
                                                notional, 
                                                spread, 
                                                schedule,
                                                paymentConvention, 
                                                dayCounter,
                                                settlesAccrual, 
                                                protectionPaymentTime,
                                                protectionStart, 
                                                claim,
						lastPeriodDayCounter));
        }
        QLECreditDefaultSwapPtr(QuantLib::Protection::Side side, 
                                QuantLib::Real notional, 
                                QuantLib::Rate upfront, 
                                QuantLib::Rate spread, 
                                const QuantLib::Schedule& schedule,
                                QuantLib::BusinessDayConvention paymentConvention, 
                                const QuantLib::DayCounter& dayCounter, 
                                bool settlesAccrual = true,
                                QuantExt::CreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime = QuantExt::CreditDefaultSwap::atDefault, 
                                const QuantLib::Date& protectionStart = QuantLib::Date(),
                                const QuantLib::Date& upfrontDate = QuantLib::Date(),
                                const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>(),
				const DayCounter& lastPeriodDayCounter = DayCounter()) {
            return new QLECreditDefaultSwapPtr(
                new QuantExt::CreditDefaultSwap(side, 
                                                notional, 
                                                upfront, 
                                                spread,
                                                schedule, 
                                                paymentConvention,
                                                dayCounter, 
                                                settlesAccrual,
                                                protectionPaymentTime,
                                                protectionStart,
                                                upfrontDate, 
                                                claim,
						lastPeriodDayCounter));
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
        bool settlesAccrual() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->settlesAccrual();
        }
        QuantExt::CreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime() const {
            return boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(*self)->protectionPaymentTime();
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

%rename(CdsOption) CdsOptionPtr;
class CdsOptionPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        CdsOptionPtr(const QLECreditDefaultSwapPtr& swap, 
                     const boost::shared_ptr<QuantLib::Exercise>& exercise,
                     bool knocksOut = true) {
            boost::shared_ptr<QuantExt::CreditDefaultSwap> cds = boost::dynamic_pointer_cast<QuantExt::CreditDefaultSwap>(swap);
            return new CdsOptionPtr(
                new QuantExt::CdsOption(cds,
                                        exercise,
                                        knocksOut));
        }
        const QLECreditDefaultSwapPtr underlyingSwap() const {
            return boost::dynamic_pointer_cast<QuantExt::CdsOption>(*self)->underlyingSwap();
        }
        QuantLib::Rate atmRate() const {
            return boost::dynamic_pointer_cast<QuantExt::CdsOption>(*self)->atmRate();
        }
        QuantLib::Real riskyAnnuity() const {
            return boost::dynamic_pointer_cast<QuantExt::CdsOption>(*self)->riskyAnnuity();
        }
        QuantLib::Volatility impliedVolatility(QuantLib::Real price, 
                                               const QuantLib::Handle<QuantLib::YieldTermStructure>& termStructure,
                                               const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability, 
                                               QuantLib::Real recoveryRate,
                                               QuantLib::Real accuracy = 1.e-4, 
                                               QuantLib::Size maxEvaluations = 100, 
                                               QuantLib::Volatility minVol = 1.0e-7,
                                               QuantLib::Volatility maxVol = 4.0) const {
            return boost::dynamic_pointer_cast<QuantExt::CdsOption>(*self)->impliedVolatility(price,
                                                                                              termStructure,
                                                                                              probability,
                                                                                              recoveryRate,
                                                                                              accuracy,
                                                                                              maxEvaluations,
                                                                                              minVol,
                                                                                              maxVol);
        }
    }
};

%rename(BlackCdsOptionEngine) BlackCdsOptionEnginePtr;
class BlackCdsOptionEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        BlackCdsOptionEnginePtr(const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability, 
                                QuantLib::Real recoveryRate,
                                const QuantLib::Handle<QuantLib::YieldTermStructure>& termStructure, 
                                const QuantLib::Handle<QuantLib::BlackVolTermStructure>& vol) {
            return new BlackCdsOptionEnginePtr(
                new QuantExt::BlackCdsOptionEngine(probability, 
                                                   recoveryRate,
                                                   termStructure, 
                                                   vol));
        }
    }
};


#endif
