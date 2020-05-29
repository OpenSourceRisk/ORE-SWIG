/*
 Copyright (C) 2019, 2020 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qlep_instruments_i
#define qlep_instruments_i

%include qle_creditdefaultswap.i
%include options.i

%{
using QuantExt::IndexCreditDefaultSwap;
using QuantExt::IndexCdsOption;
using QuantExt::MidPointIndexCdsEngine;
using QuantExt::BlackIndexCdsOptionEngine;
%}

%shared_ptr(IndexCreditDefaultSwap)
class IndexCreditDefaultSwap : public Instrument {
  public:
    IndexCreditDefaultSwap(QuantLib::Protection::Side side,
                           QuantLib::Real notional,
                           std::vector<QuantLib::Real> underlyingNotionals,
                           QuantLib::Rate spread,
                           const QuantLib::Schedule& schedule,
                           QuantLib::BusinessDayConvention paymentConvention,
                           const QuantLib::DayCounter& dayCounter,
                           bool settlesAccrual = true,
                           bool paysAtDefaultTime = true,
                           const QuantLib::Date& protectionStart = QuantLib::Date(),
                           const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>());
    IndexCreditDefaultSwap(QuantLib::Protection::Side side,
                           QuantLib::Real notional,
                           std::vector<QuantLib::Real> underlyingNotionals,
                           QuantLib::Rate upfront,
                           QuantLib::Rate spread,
                           const QuantLib::Schedule& schedule,
                           QuantLib::BusinessDayConvention paymentConvention,
                           const QuantLib::DayCounter& dayCounter,
                           bool settlesAccrual = true,
                           bool paysAtDefaultTime = true,
                           const QuantLib::Date& protectionStart = QuantLib::Date(),
                           const QuantLib::Date& upfrontDate = Date(),
                           const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>());
    QuantLib::Protection::Side side() const;
    QuantLib::Real notional() const;
    QuantLib::Rate runningSpread() const;
    bool settlesAccrual() const;
    bool paysAtDefaultTime() const;
    const QuantLib::Leg& coupons() const;
    const QuantLib::Date& protectionStartDate() const;
    const QuantLib::Date& protectionEndDate() const;
    QuantLib::Rate fairUpfront() const;
    QuantLib::Rate fairSpread() const;
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
    const std::vector<QuantLib::Real>& underlyingNotionals() const;
};

%shared_ptr(IndexCdsOption)
class IndexCdsOption : public Instrument {
  public:
    IndexCdsOption(const boost::shared_ptr<IndexCreditDefaultSwap>& swap,
                   const boost::shared_ptr<QuantLib::Exercise>& exercise,
                   bool knocksOut = true);
    boost::shared_ptr<QuantLib::Payoff> payoff();
    boost::shared_ptr<QuantLib::Exercise> exercise();
    const boost::shared_ptr<IndexCreditDefaultSwap> underlyingSwap() const;
    QuantLib::Rate atmRate() const;
    QuantLib::Real riskyAnnuity() const;
    QuantLib::Volatility impliedVolatility(QuantLib::Real price,
                                           const Handle<QuantLib::YieldTermStructure>& termStructure,
                                           const Handle<DefaultProbabilityTermStructure>& probability,
                                           QuantLib::Real recoveryRate,
                                           QuantLib::Real accuracy = 1.e-4,
                                           Size maxEvaluations = 100,
                                           QuantLib::Volatility minVol = 1.0e-7,
                                           QuantLib::Volatility maxVol = 4.0) const;
};

%shared_ptr(MidPointIndexCdsEngine)
class MidPointIndexCdsEngine : public PricingEngine {
  public:
    MidPointIndexCdsEngine(const Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                           QuantLib::Real recoveryRate,
                           const Handle<QuantLib::YieldTermStructure>& discountCurve,
                           boost::optional<bool> includeSettlementDateFlows = boost::none);
    MidPointIndexCdsEngine(const std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>& probabilities,
                           const std::vector<QuantLib::Real> underlyingRecoveryRate,
                           const Handle<QuantLib::YieldTermStructure>& discountCurve,
                           boost::optional<bool> includeSettlementDateFlows = boost::none);
};

%shared_ptr(BlackIndexCdsOptionEngine)
class BlackIndexCdsOptionEngine : public PricingEngine {
  public:
    BlackIndexCdsOptionEngine(const Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                              QuantLib::Real recoveryRate,
                              const Handle<QuantLib::YieldTermStructure>& termStructure,
                              const Handle<QuantLib::BlackVolTermStructure>& vol);
    BlackIndexCdsOptionEngine(const std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>& probabilities,
                              const std::vector<QuantLib::Real>& recoveryRate,
                              const Handle<QuantLib::YieldTermStructure>& termStructure,
                              const Handle<QuantLib::BlackVolTermStructure>& vol);
};

%template(DefaultProbailityTermStructureHandleVector) std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>;

#endif
