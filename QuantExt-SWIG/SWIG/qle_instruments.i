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

#ifndef qle_instruments_i
#define qle_instruments_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i
%include qle_ccyswap.i
%include qle_indexes.i
%include qle_termstructures.i

%{
using QuantExt::CrossCcyBasisSwap;
using QuantExt::CrossCcyBasisMtMResetSwap;
using QuantExt::CommodityForward;
using QuantExt::DiscountingCommodityForwardEngine;
using QuantExt::FxForward;
using QuantExt::DiscountingFxForwardEngine;
using QuantExt::Payment;
using QuantExt::PaymentDiscountingEngine;
using QuantExt::OvernightIndexedBasisSwap;
using QuantExt::Deposit;
using QuantExt::DepositEngine;
using QuantExt::DiscountingSwapEngineMultiCurve;
%}

%shared_ptr(CrossCcyBasisSwap)
class CrossCcyBasisSwap : public CrossCcySwap {
  public:
    CrossCcyBasisSwap(QuantLib::Real payNominal,
                      const QuantLib::Currency& payCurrency,
                      const QuantLib::Schedule& paySchedule,
                      const boost::shared_ptr<IborIndex>& payIndex,
                      QuantLib::Spread paySpread,
		      QuantLib::Real payGearing,
                      QuantLib::Real recNominal,
                      const QuantLib::Currency& recCurrency,
                      const QuantLib::Schedule& recSchedule,
                      const boost::shared_ptr<IborIndex>& recIndex,
                      QuantLib::Spread recSpread,
		      QuantLib::Real recGearing);
    QuantLib::Real payNominal() const;
    const QuantLib::Currency& payCurrency() const;
    const QuantLib::Schedule& paySchedule() const;
    QuantLib::Spread paySpread() const;
    QuantLib::Real payGearing() const;
    QuantLib::Real recNominal() const;
    const QuantLib::Currency& recCurrency() const;
    const QuantLib::Schedule& recSchedule() const;
    QuantLib::Spread recSpread() const;
    QuantLib::Real recGearing() const;
    QuantLib::Spread fairPaySpread() const;
    QuantLib::Spread fairRecSpread() const;
};


%shared_ptr(CrossCcyBasisMtMResetSwap)
class CrossCcyBasisMtMResetSwap : public CrossCcySwap {
  public:
    CrossCcyBasisMtMResetSwap(Real foreignNominal,
                              const Currency& foreignCurrency,
                              const Schedule& foreignSchedule,
                              const boost::shared_ptr<IborIndex>& foreignIndex,
                              Spread foreignSpread,
                              const Currency& domesticCurrency,
                              const Schedule& domesticSchedule,
                              const boost::shared_ptr<IborIndex>& domesticIndex,
                              Spread domesticSpread,
                              const boost::shared_ptr<FxIndex>& fxIdx,
                              bool receiveDomestic = true);
    Spread fairForeignSpread() const;
    Spread fairDomesticSpread() const;
};


%shared_ptr(Deposit)
class Deposit : public Instrument {
  public:
    Deposit(const QuantLib::Real nominal,
            const QuantLib::Rate rate,
            const QuantLib::Period& tenor,
            const QuantLib::Natural fixingDays,
            const QuantLib::Calendar& calendar,
            const QuantLib::BusinessDayConvention convention,
            const bool endOfMonth,
            const QuantLib::DayCounter& dayCounter,
            const QuantLib::Date& tradeDate,
            const bool isLong = true,
            const QuantLib::Period forwardStart = QuantLib::Period(0, QuantLib::Days));
    QuantLib::Date fixingDate() const;
    QuantLib::Date startDate() const;
    QuantLib::Date maturityDate() const;
    QuantLib::Real fairRate() const;
    const QuantLib::Leg& leg() const;
};

%shared_ptr(DepositEngine)
class DepositEngine : public PricingEngine {
  public:
    DepositEngine(const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                  boost::optional<bool> includeSettlementDateFlows = boost::none,
                  QuantLib::Date settlementDate = QuantLib::Date(),
                  QuantLib::Date npvDate = QuantLib::Date());
};

%shared_ptr(OvernightIndexedBasisSwap)
class OvernightIndexedBasisSwap : public Swap {
  public:
    enum Type { Receiver = -1, Payer = 1 };
    OvernightIndexedBasisSwap(OvernightIndexedBasisSwap::Type type,
                                    QuantLib::Real nominal,
                                    const QuantLib::Schedule& oisSchedule,
                                    const boost::shared_ptr<OvernightIndex>& overnightIndex,
                                    const QuantLib::Schedule& iborSchedule,
                                    const boost::shared_ptr<IborIndex>& iborIndex,
                                    QuantLib::Spread oisSpread = 0.0,
                                    QuantLib::Spread iborSpread = 0.0);
    QuantLib::Real nominal() const ;
    const QuantLib::Schedule& oisSchedule();
    const QuantLib::Schedule& iborSchedule();
    QuantLib::Spread oisSpread();
    QuantLib::Spread iborSpread();
    const QuantLib::Leg& iborLeg();
    const QuantLib::Leg& overnightLeg();
    QuantLib::Real iborLegBPS() const;
    QuantLib::Real iborLegNPV() const;
    QuantLib::Real fairIborSpread() const;
    QuantLib::Real overnightLegBPS() const;
    QuantLib::Real overnightLegNPV() const;
    QuantLib::Real fairOvernightSpread() const;
};


%shared_ptr(Payment)
class Payment : public Instrument {
  public:
    Payment(const QuantLib::Real amount,
            const QuantLib::Currency& currency,
            const QuantLib::Date& date);
    QuantLib::Currency currency() const;
    boost::shared_ptr<SimpleCashFlow> cashFlow() const;
};


%shared_ptr(PaymentDiscountingEngine)
class PaymentDiscountingEngine : public PricingEngine {
  public:
    PaymentDiscountingEngine(const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                             const QuantLib::Handle<QuantLib::Quote>& spotFX = QuantLib::Handle<QuantLib::Quote>(),
                             boost::optional<bool> includeSettlementDateFlows = boost::none,
                             const QuantLib::Date& settlementDate = QuantLib::Date(),
                             const QuantLib::Date& npvDate = QuantLib::Date());    
    const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve();    
    const QuantLib::Handle<QuantLib::Quote>& spotFX();
};


%shared_ptr(FxForward)
class FxForward : public Instrument {
  public:
    FxForward(const QuantLib::Real& nominal1,
              const QuantLib::Currency& currency1,
              const QuantLib::Real& nominal2,
              const QuantLib::Currency& currency2,
              const QuantLib::Date& maturityDate,
              const bool& payCurrency1);
    const QuantLib::ExchangeRate& fairForwardRate();
    QuantLib::Real currency1Nominal() const;
    QuantLib::Real currency2Nominal() const;
    QuantLib::Currency currency1() const;
    QuantLib::Currency currency2() const;
    QuantLib::Date maturityDate() const;
    bool payCurrency1() const;
};


%shared_ptr(DiscountingFxForwardEngine)
class DiscountingFxForwardEngine : public PricingEngine {
  public:
    DiscountingFxForwardEngine(const QuantLib::Currency& ccy1,
                               const QuantLib::Handle<QuantLib::YieldTermStructure>& currency1Discountcurve,
                               const QuantLib::Currency& ccy2,
                               const QuantLib::Handle<QuantLib::YieldTermStructure>& currency2Discountcurve,
                               const QuantLib::Handle<QuantLib::Quote>& spotFX,
                               boost::optional<bool> includeSettlementDateFlows = boost::none,
                               const QuantLib::Date& settlementDate = QuantLib::Date(),
                               const QuantLib::Date& npvDate = QuantLib::Date());
};


%shared_ptr(CommodityForward)
class CommodityForward : public Instrument {
public:
    CommodityForward(const ext::shared_ptr<CommodityIndex>& index,
                     const QuantLib::Currency& currency,
                     QuantLib::Position::Type position,
                     QuantLib::Real quantity,
                     const QuantLib::Date& maturityDate,
                     QuantLib::Real strike);
    const ext::shared_ptr<CommodityIndex>& index() const;
    const QuantLib::Currency& currency() const;
    QuantLib::Position::Type position() const;
    QuantLib::Real quantity() const;
    const QuantLib::Date& maturityDate() const;
    QuantLib::Real strike() const;
};

%shared_ptr(DiscountingCommodityForwardEngine)
class DiscountingCommodityForwardEngine : public PricingEngine {
public:
    DiscountingCommodityForwardEngine(const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                      boost::optional<bool> includeSettlementDateFlows = boost::none,
                                      const QuantLib::Date& npvDate = QuantLib::Date());
};

%shared_ptr(DiscountingSwapEngineMultiCurve)
class DiscountingSwapEngineMultiCurve : public PricingEngine {
public:
    DiscountingSwapEngineMultiCurve(const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve
                                        = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                                    bool minimalResults = true,
                                    boost::optional<bool> includeSettlementDateFlows = boost::none,
                                    QuantLib::Date settlementDate = QuantLib::Date(),
                                    QuantLib::Date npvDate = QuantLib::Date());
    QuantLib::Handle<QuantLib::YieldTermStructure> discountCurve();
};

#endif
