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

#ifndef qle_credit_default_swap_i
#define qle_credit_default_swap_i

%include instruments.i
%include credit.i
%include termstructures.i
%include bonds.i
%include null.i
%include creditdefaultswap.i

%{
using QLECreditDefaultSwap = QuantExt::CreditDefaultSwap;
using QLEMidPointCdsEngine = QuantExt::MidPointCdsEngine;
using QLECdsOption = QuantExt::CdsOption;
using QLEBlackCdsOptionEngine = QuantExt::BlackCdsOptionEngine;
%}

%shared_ptr(QLECreditDefaultSwap)
class QLECreditDefaultSwap : public Instrument {
  public:
    enum ProtectionPaymentTime { atDefault, atPeriodEnd, atMaturity };
    QLECreditDefaultSwap(QuantLib::Protection::Side side,
                         QuantLib::Real notional,
                         QuantLib::Rate spread,
                         const QuantLib::Schedule& schedule,
                         QuantLib::BusinessDayConvention paymentConvention,
                         const QuantLib::DayCounter& dayCounter,
                         bool settlesAccrual = true,
			 QLECreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime = QLECreditDefaultSwap::atDefault,
                         const QuantLib::Date& protectionStart = QuantLib::Date(),
                         const ext::shared_ptr<QuantLib::Claim>& claim = ext::shared_ptr<QuantLib::Claim>(),
			 const QuantLib::DayCounter& lastPeriodDayCounter = QuantLib::DayCounter());

    QLECreditDefaultSwap(QuantLib::Protection::Side side,
                         QuantLib::Real notional,
                         QuantLib::Rate upfront,
                         QuantLib::Rate spread,
                         const QuantLib::Schedule& schedule,
                         QuantLib::BusinessDayConvention paymentConvention,
                         const QuantLib::DayCounter& dayCounter,
                         bool settlesAccrual = true,
                         QLECreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime = QLECreditDefaultSwap::atDefault,
                         const QuantLib::Date& protectionStart = QuantLib::Date(),
                         const QuantLib::Date& upfrontDate = QuantLib::Date(),
                         const ext::shared_ptr<QuantLib::Claim>& claim = ext::shared_ptr<QuantLib::Claim>(),
			 const QuantLib::DayCounter& lastPeriodDayCounter = QuantLib::DayCounter());
    QuantLib::Protection::Side side() const;
    QuantLib::Real notional() const;
    QuantLib::Rate runningSpread() const;
    bool settlesAccrual() const;
    QLECreditDefaultSwap::ProtectionPaymentTime protectionPaymentTime() const;
    const QuantLib::Leg& coupons() const;
    const QuantLib::Date& protectionStartDate() const;
    const QuantLib::Date& protectionEndDate() const;
    const ext::shared_ptr<SimpleCashFlow>& upfrontPayment() const;
    const ext::shared_ptr<SimpleCashFlow>& accrualRebate() const;
    //const ext::shared_ptr<SimpleCashFlow>& accrualRebateCurrent() const;
    const QuantLib::Date& tradeDate() const;
    QuantLib::Natural cashSettlementDays() const;
    QuantLib::Rate fairUpfront() const;
    QuantLib::Rate fairSpreadDirty() const;
    QuantLib::Rate fairSpreadClean() const;
    QuantLib::Real couponLegBPS() const;
    QuantLib::Real upfrontBPS() const;
    QuantLib::Real couponLegNPV() const;
    QuantLib::Real defaultLegNPV() const;
    QuantLib::Real upfrontNPV() const;
    QuantLib::Real accrualRebateNPV() const;
    QuantLib::Date maturity() const;
    QuantLib::Rate impliedHazardRate(QuantLib::Real targetNPV,
                                     const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                     const QuantLib::DayCounter& dayCounter,
                                     QuantLib::Real recoveryRate = 0.4,
                                     QuantLib::Real accuracy = 1.0e-6) const;
    QuantLib::Rate conventionalSpread(QuantLib::Real conventionalRecovery,
                                      const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                      const QuantLib::DayCounter& dayCounter) const;
};

%shared_ptr(QLEMidPointCdsEngine)
class QLEMidPointCdsEngine : public PricingEngine {
  public:
    QLEMidPointCdsEngine(const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                         QuantLib::Real recoveryRate,
                         const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve);
};


%shared_ptr(QLECdsOption)
class QLECdsOption : public Instrument {
  public:
    enum StrikeType { Price, Spread };
    QLECdsOption(const ext::shared_ptr<QLECreditDefaultSwap> swap,
		 const ext::shared_ptr<QuantLib::Exercise>& exercise,
		 bool knocksOut = true, const QuantLib::Real strike = Null<Real>(),
         const StrikeType strikeType = StrikeType::Spread);
    const ext::shared_ptr<QLECreditDefaultSwap> underlyingSwap() const;
    QuantLib::Rate atmRate() const;
    QuantLib::Real riskyAnnuity() const;
    QuantLib::Volatility impliedVolatility(QuantLib::Real price,
                                           const QuantLib::Handle<QuantLib::YieldTermStructure>& termStructure,
                                           const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                                           QuantLib::Real recoveryRate,
                                           QuantLib::Real accuracy = 1.e-4,
                                           QuantLib::Size maxEvaluations = 100,
                                           QuantLib::Volatility minVol = 1.0e-7,
                                           QuantLib::Volatility maxVol = 4.0) const;
};

%shared_ptr(QLEBlackCdsOptionEngine)
class QLEBlackCdsOptionEngine : public PricingEngine {
  public:
    QLEBlackCdsOptionEngine(const QuantLib::Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
			    QuantLib::Real recoveryRate,
			    const QuantLib::Handle<QuantLib::YieldTermStructure>& termStructure,
			    const QuantLib::Handle<QuantExt::CreditVolCurve>& vol);
};

#endif
