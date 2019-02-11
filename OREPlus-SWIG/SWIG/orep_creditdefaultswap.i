
/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
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

typedef boost::shared_ptr<Instrument> IndexCreditDefaultSwapPtr;
typedef boost::shared_ptr<Instrument> IndexCdsOptionPtr;
typedef boost::shared_ptr<PricingEngine> MidPointIndexCdsEnginePtr;
typedef boost::shared_ptr<PricingEngine> BlackIndexCdsOptionEnginePtr;
%}

%rename(IndexCreditDefaultSwap) IndexCreditDefaultSwapPtr;
class IndexCreditDefaultSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        IndexCreditDefaultSwapPtr(QuantLib::Protection::Side side,
                                  QuantLib::Real notional,
                                  std::vector<QuantLib::Real> underlyingNotionals,
                                  QuantLib::Rate spread,
                                  const QuantLib::Schedule& schedule,
                                  QuantLib::BusinessDayConvention paymentConvention,
                                  const QuantLib::DayCounter& dayCounter,
                                  bool settlesAccrual = true,
                                  bool paysAtDefaultTime = true,
                                  const QuantLib::Date& protectionStart = QuantLib::Date(),
                                  const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>()) {
            return new IndexCreditDefaultSwapPtr(
                new QuantExt::IndexCreditDefaultSwap(side,
                                                     notional,
                                                     underlyingNotionals,
                                                     spread,
                                                     schedule,
                                                     paymentConvention,
                                                     dayCounter,
                                                     settlesAccrual,
                                                     paysAtDefaultTime,
                                                     protectionStart,
                                                     claim));
        }
        IndexCreditDefaultSwapPtr(QuantLib::Protection::Side side,
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
                                  const boost::shared_ptr<QuantLib::Claim>& claim = boost::shared_ptr<QuantLib::Claim>()) {
            return new IndexCreditDefaultSwapPtr(
                new QuantExt::IndexCreditDefaultSwap(side,
                                                     notional,
                                                     underlyingNotionals,
                                                     upfront,
                                                     spread,
                                                     schedule,
                                                     paymentConvention,
                                                     dayCounter,
                                                     settlesAccrual,
                                                     paysAtDefaultTime,
                                                     protectionStart,
                                                     upfrontDate,
                                                     claim));
        }
        QuantLib::Protection::Side side() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->side();
        }
        QuantLib::Real notional() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->notional();
        }
        QuantLib::Rate runningSpread() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->runningSpread();
        }
        bool settlesAccrual() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->settlesAccrual();
        }
        bool paysAtDefaultTime() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->paysAtDefaultTime();
        }
        const QuantLib::Leg& coupons() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->coupons();
        }
        const QuantLib::Date& protectionStartDate() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->protectionStartDate();
        }
        const QuantLib::Date& protectionEndDate() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->protectionEndDate();
        }
        QuantLib::Rate fairUpfront() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->fairUpfront();
        }
        QuantLib::Rate fairSpread() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->fairSpread();
        }
        QuantLib::Real couponLegBPS() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->couponLegBPS();
        }
        QuantLib::Real upfrontBPS() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->upfrontBPS();
        }
        QuantLib::Real couponLegNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->couponLegNPV();
        }
        QuantLib::Real defaultLegNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->defaultLegNPV();
        }
        QuantLib::Real upfrontNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->upfrontNPV();
        }
        QuantLib::Real accrualRebateNPV() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->accrualRebateNPV();
        }
        QuantLib::Date maturity() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->maturity();
        }
        QuantLib::Rate impliedHazardRate(QuantLib::Real targetNPV,
                                         const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                         const QuantLib::DayCounter& dayCounter,
                                         QuantLib::Real recoveryRate = 0.4,
                                         QuantLib::Real accuracy = 1.0e-6) const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->impliedHazardRate(targetNPV,
                                                                                                           discountCurve,
                                                                                                           dayCounter,
                                                                                                           recoveryRate,
                                                                                                           accuracy);
        }
        QuantLib::Rate conventionalSpread(QuantLib::Real conventionalRecovery,
                                          const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                          const QuantLib::DayCounter& dayCounter) const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->conventionalSpread(conventionalRecovery,
                                                                                                            discountCurve,
                                                                                                            dayCounter);
        }
        const std::vector<QuantLib::Real>& underlyingNotionals() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(*self)->underlyingNotionals();
        }
    }
};

%rename(IndexCdsOption) IndexCdsOptionPtr;
class IndexCdsOptionPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        IndexCdsOptionPtr(const IndexCreditDefaultSwapPtr& swap,
                          const boost::shared_ptr<QuantLib::Exercise>& exercise,
                          bool knocksOut = true) {
            boost::shared_ptr<QuantExt::IndexCreditDefaultSwap> cds = boost::dynamic_pointer_cast<QuantExt::IndexCreditDefaultSwap>(swap);
            return new IndexCdsOptionPtr(
                new QuantExt::IndexCdsOption(cds,
                                             exercise,
                                             knocksOut));
        }
        boost::shared_ptr<QuantLib::Payoff> payoff() {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)->payoff();
        }
        boost::shared_ptr<QuantLib::Exercise> exercise() {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)->exercise();
        }
        const IndexCreditDefaultSwapPtr underlyingSwap() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)->underlyingSwap();
        }
        QuantLib::Rate atmRate() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)->atmRate();
        }
        QuantLib::Real riskyAnnuity() const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)->riskyAnnuity();
        }
        QuantLib::Volatility impliedVolatility(QuantLib::Real price,
                                               const Handle<QuantLib::YieldTermStructure>& termStructure,
                                               const Handle<DefaultProbabilityTermStructure>& probability,
                                               QuantLib::Real recoveryRate,
                                               QuantLib::Real accuracy = 1.e-4,
                                               Size maxEvaluations = 100,
                                               QuantLib::Volatility minVol = 1.0e-7,
                                               QuantLib::Volatility maxVol = 4.0) const {
            return boost::dynamic_pointer_cast<QuantExt::IndexCdsOption>(*self)
                ->impliedVolatility(price,
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

%rename(MidPointIndexCdsEngine) MidPointIndexCdsEnginePtr;
class MidPointIndexCdsEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        MidPointIndexCdsEnginePtr(const Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                                  QuantLib::Real recoveryRate,
                                  const Handle<QuantLib::YieldTermStructure>& discountCurve,
                                  boost::optional<bool> includeSettlementDateFlows = boost::none) {
            return new MidPointIndexCdsEnginePtr(
                new QuantExt::MidPointIndexCdsEngine(probability,
                                                     recoveryRate,
                                                     discountCurve,
                                                     includeSettlementDateFlows));
        }
        MidPointIndexCdsEnginePtr(const std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>& probabilities,
                                  const std::vector<QuantLib::Real> underlyingRecoveryRate,
                                  const Handle<QuantLib::YieldTermStructure>& discountCurve,
                                  boost::optional<bool> includeSettlementDateFlows = boost::none) {
            return new MidPointIndexCdsEnginePtr(
                new QuantExt::MidPointIndexCdsEngine(probabilities,
                                                     underlyingRecoveryRate,
                                                     discountCurve,
                                                     includeSettlementDateFlows));
        }
    }
};

%rename(BlackIndexCdsOptionEngine) BlackIndexCdsOptionEnginePtr;
class BlackIndexCdsOptionEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        BlackIndexCdsOptionEnginePtr(const Handle<QuantLib::DefaultProbabilityTermStructure>& probability,
                                     QuantLib::Real recoveryRate,
                                     const Handle<QuantLib::YieldTermStructure>& termStructure,
                                     const Handle<QuantLib::BlackVolTermStructure>& vol) {
            return new BlackIndexCdsOptionEnginePtr(
                new QuantExt::BlackIndexCdsOptionEngine(probability,
                                                        recoveryRate,
                                                        termStructure,
                                                        vol));
        }
        BlackIndexCdsOptionEnginePtr(const std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>& probabilities,
                                     const std::vector<QuantLib::Real>& recoveryRate,
                                     const Handle<QuantLib::YieldTermStructure>& termStructure,
                                     const Handle<QuantLib::BlackVolTermStructure>& vol) {
            return new BlackIndexCdsOptionEnginePtr(
                new QuantExt::BlackIndexCdsOptionEngine(probabilities,
                                                        recoveryRate,
                                                        termStructure,
                                                        vol));
        }
    }
};

%template(DefaultProbailityTermStructureHandleVector) std::vector<Handle<QuantLib::DefaultProbabilityTermStructure>>;

#endif
