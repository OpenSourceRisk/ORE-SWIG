/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_instruments_i
#define qle_instruments_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i

%include qle_termstructures.i

%{
using QuantExt::CrossCcyBasisSwap;
using QuantExt::CommodityForward;
using QuantExt::DiscountingCommodityForwardEngine;
using QuantExt::FxForward;
using QuantExt::DiscountingFxForwardEngine;
using QuantExt::OvernightIndexedBasisSwap;
using QuantExt::Deposit;
using QuantExt::DepositEngine;
using QuantExt::CrossCcyBasisSwap;

typedef boost::shared_ptr<Instrument> CrossCcyBasisSwapPtr;
typedef boost::shared_ptr<Instrument> CommodityForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingCommodityForwardEnginePtr;
typedef boost::shared_ptr<Instrument> FxForwardPtr;
typedef boost::shared_ptr<PricingEngine> DiscountingFxForwardEnginePtr;
typedef boost::shared_ptr<Instrument> OvernightIndexedBasisSwapPtr;
typedef boost::shared_ptr<Instrument> DepositPtr;
typedef boost::shared_ptr<PricingEngine> DepositEnginePtr;
typedef boost::shared_ptr<Instrument> CrossCcyBasisSwapPtr;
%}

%rename(CrossCcyBasisSwap) CrossCcyBasisSwapPtr;
class CrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        CrossCcyBasisSwapPtr(QuantLib::Real payNominal,
                             const QuantLib::Currency& payCurrency,
                             const QuantLib::Schedule& paySchedule,
                             const IborIndexPtr& payIndex,
                             QuantLib::Spread paySpread,
                             QuantLib::Real recNominal,
                             const QuantLib::Currency& recCurrency,
                             const QuantLib::Schedule& recSchedule,
                             const IborIndexPtr& recIndex,
                             QuantLib::Spread recSpread) {
            boost::shared_ptr<IborIndex> pIndex = boost::dynamic_pointer_cast<IborIndex>(payIndex);
            boost::shared_ptr<IborIndex> rIndex = boost::dynamic_pointer_cast<IborIndex>(recIndex);
            return new CrossCcyBasisSwapPtr(
                new CrossCcyBasisSwap(payNominal,
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
        QuantLib::Real payNominal() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->payNominal(); 
        }
        const QuantLib::Currency& payCurrency() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->payCurrency(); 
        }
        const QuantLib::Schedule& paySchedule() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->paySchedule(); 
        }
        QuantLib::Spread paySpread() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->paySpread(); 
        }
        QuantLib::Real recNominal() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->recNominal(); 
        }
        const QuantLib::Currency& recCurrency() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->recCurrency(); 
        }
        const QuantLib::Schedule& recSchedule() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->recSchedule(); 
        }
        QuantLib::Spread recSpread() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->recSpread(); 
        }
        QuantLib::Spread fairPaySpread() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->fairPaySpread(); 
        }
        QuantLib::Spread fairRecSpread() const { 
            return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->fairRecSpread(); 
        }
    }
};


%rename(Deposit) DepositPtr;
class DepositPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        DepositPtr(const QuantLib::Real nominal,
                   const QuantLib::Rate rate,
                   const QuantLib::Period& tenor, 
                   const QuantLib::Natural fixingDays,
                   const QuantLib::Calendar& calendar, 
                   const QuantLib::BusinessDayConvention convention, 
                   const bool endOfMonth,
                   const QuantLib::DayCounter& dayCounter, 
                   const QuantLib::Date& tradeDate, 
                   const bool isLong = true,
                   const QuantLib::Period forwardStart = QuantLib::Period(0, QuantLib::Days)) {
            return new DepositPtr(
                new Deposit(nominal,
                            rate,
                            tenor,
                            fixingDays,
                            calendar,
                            convention,
                            endOfMonth,
                            dayCounter,
                            tradeDate,
                            isLong,
                            forwardStart));
        }
        QuantLib::Date fixingDate() const { 
            return boost::dynamic_pointer_cast<Deposit>(*self)->fixingDate(); 
        }
        QuantLib::Date startDate() const { 
            return boost::dynamic_pointer_cast<Deposit>(*self)->startDate(); 
        }
        QuantLib::Date maturityDate() const { 
            return boost::dynamic_pointer_cast<Deposit>(*self)->maturityDate(); 
        }
        QuantLib::Real fairRate() const { 
            return boost::dynamic_pointer_cast<Deposit>(*self)->fairRate(); 
        }
        const QuantLib::Leg& leg() const { 
            return boost::dynamic_pointer_cast<Deposit>(*self)->leg(); 
        }
    }
};

%rename(DepositEngine) DepositEnginePtr;
class DepositEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        DepositEnginePtr(const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                         boost::optional<bool> includeSettlementDateFlows = boost::none,
                         QuantLib::Date& settlementDate = QuantLib::Date(),
                         QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DepositEnginePtr(
                new DepositEngine(discountCurve,
                                  includeSettlementDateFlows,
                                  settlementDate,
                                  npvDate));
        }
    }
};


%ignore OvernightIndexedBasisSwap;
class OvernightIndexedBasisSwap {
  public:
    enum Type { Receiver = -1, Payer = 1 };
};

%rename(OvernightIndexedBasisSwap) OvernightIndexedBasisSwapPtr;
class OvernightIndexedBasisSwapPtr : public SwapPtr {
  public:
    %extend {
        static const OvernightIndexedBasisSwap::Type Receiver = OvernightIndexedBasisSwap::Receiver;
        static const OvernightIndexedBasisSwap::Type Payer = OvernightIndexedBasisSwap::Payer;
        OvernightIndexedBasisSwapPtr(OvernightIndexedBasisSwap::Type type,
                                     QuantLib::Real nominal, 
                                     const QuantLib::Schedule& oisSchedule,
                                     const OvernightIndexPtr& overnightIndex,
                                     const QuantLib::Schedule& iborSchedule,
                                     const IborIndexPtr& iborIndex,
                                     QuantLib::Spread oisSpread = 0.0,
                                     QuantLib::Spread iborSpread = 0.0) {
            boost::shared_ptr<OvernightIndex> onIndex = boost::dynamic_pointer_cast<OvernightIndex>(overnightIndex);
            boost::shared_ptr<IborIndex> ibIndex = boost::dynamic_pointer_cast<IborIndex>(iborIndex);
            return new OvernightIndexedBasisSwapPtr(
                new OvernightIndexedBasisSwap(type,
                                              nominal,
                                              oisSchedule,
                                              onIndex,
                                              iborSchedule,
                                              ibIndex,
                                              oisSpread,
                                              iborSpread));
        } 
        QuantLib::Real nominal() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->nominal(); 
        }
        const QuantLib::Schedule& oisSchedule() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->oisSchedule(); 
        }
        const QuantLib::Schedule& iborSchedule() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->iborSchedule(); 
        }
        QuantLib::Spread oisSpread() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->oisSpread(); 
        }
        QuantLib::Spread iborSpread() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->iborSpread(); 
        }
        const QuantLib::Leg& iborLeg() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->iborLeg(); 
        }
        const QuantLib::Leg& overnightLeg() { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->overnightLeg(); 
        }
        QuantLib::Real iborLegBPS() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->iborLegBPS(); 
        }
        QuantLib::Real iborLegNPV() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->iborLegNPV(); 
        }
        QuantLib::Real fairIborSpread() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->fairIborSpread(); 
        }
        QuantLib::Real overnightLegBPS() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->overnightLegBPS(); 
        }
        QuantLib::Real overnightLegNPV() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->overnightLegNPV(); 
        }
        QuantLib::Real fairOvernightSpread() const { 
            return boost::dynamic_pointer_cast<OvernightIndexedBasisSwap>(*self)->fairOvernightSpread(); 
        }
    }
};


%rename(FxForward) FxForwardPtr;
class FxForwardPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
        FxForwardPtr(const QuantLib::Real& nominal1,
                     const QuantLib::Currency& currency1,
                     const QuantLib::Real& nominal2,
                     const QuantLib::Currency& currency2,
                     const QuantLib::Date& maturityDate,
                     const bool& payCurrency1) {
            return new FxForwardPtr(
                new FxForward(nominal1, 
                              currency1, 
                              nominal2, 
                              currency2,
                              maturityDate, 
                              payCurrency1));
        }
        const QuantLib::ExchangeRate& fairForwardRate() { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->fairForwardRate(); 
        }
        QuantLib::Real currency1Nominal() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency1Nominal(); 
        }
        QuantLib::Real currency2Nominal() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency2Nominal(); 
        }
        QuantLib::Currency currency1() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency1(); 
        }
        QuantLib::Currency currency2() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->currency2(); 
        }
        QuantLib::Date maturityDate() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->maturityDate(); 
        }
        bool payCurrency1() const { 
            return boost::dynamic_pointer_cast<FxForward>(*self)->payCurrency1(); 
        }
    }
};

%rename(DiscountingFxForwardEngine) DiscountingFxForwardEnginePtr;
class DiscountingFxForwardEnginePtr : public boost::shared_ptr<PricingEngine> {
  public:
    %extend {
        DiscountingFxForwardEnginePtr(const QuantLib::Currency& ccy1,
                                      const QuantLib::Handle<QuantLib::YieldTermStructure>& currency1Discountcurve,
                                      const QuantLib::Currency& ccy2,
                                      const QuantLib::Handle<QuantLib::YieldTermStructure>& currency2Discountcurve,
                                      const QuantLib::Handle<QuantLib::Quote>& spotFX,
                                      boost::optional<bool> includeSettlementDateFlows = boost::none,
                                      const QuantLib::Date& settlementDate = QuantLib::Date(),
                                      const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DiscountingFxForwardEnginePtr(
                                  new DiscountingFxForwardEngine(ccy1,
                                                                 currency1Discountcurve,
                                                                 ccy2,
                                                                 currency2Discountcurve,
                                                                 spotFX,
                                                                 includeSettlementDateFlows,
                                                                 settlementDate,
                                                                 npvDate));
        }
    }
};


%rename(CrossCcyBasisSwap) CrossCcyBasisSwapPtr;
class CrossCcyBasisSwapPtr : public boost::shared_ptr<Instrument> {
 public:
  %extend {
    CrossCcyBasisSwapPtr(QuantLib::Real payNominal,
                         const QuantLib::Currency& payCurrency,
                         const QuantLib::Schedule& paySchedule,
                         const IborIndexPtr& payIndex,
                         QuantLib::Spread paySpread,
                         QuantLib::Real recNominal,
                         const QuantLib::Currency& recCurrency,
                         const QuantLib::Schedule& recSchedule,
                         const IborIndexPtr& recIndex,
                         QuantLib::Spread recSpread) {
            boost::shared_ptr<IborIndex> payIbor = boost::dynamic_pointer_cast<IborIndex>(payIndex);
            boost::shared_ptr<IborIndex> recIbor = boost::dynamic_pointer_cast<IborIndex>(recIndex);
            return new CrossCcyBasisSwapPtr(
                new CrossCcyBasisSwap(payNominal, 
                                      payCurrency, 
                                      paySchedule, 
                                      payIbor,
                                      paySpread, 
                                      recNominal, 
                                      recCurrency, 
                                      recSchedule, 
                                      recIbor, 
                                      recSpread));
    }
    Real payNominal() {
      return boost::dynamic_pointer_cast<CrossCcyBasisSwap>(*self)->payNominal();
    }
  }
};


%rename(CommodityForward) CommodityForwardPtr;
class CommodityForwardPtr : public boost::shared_ptr<Instrument> {
public:
    %extend {
        CommodityForwardPtr(const std::string& name, 
                            const QuantLib::Currency& currency,
                            QuantLib::Position::Type position, 
                            QuantLib::Real quantity,
                            const QuantLib::Date& maturityDate, 
                            QuantLib::Real strike) {
            return new CommodityForwardPtr(
                new CommodityForward(name, 
                                     currency, 
                                     position, 
                                     quantity, 
                                     maturityDate, 
                                     strike));
        }
        const std::string& name() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->name(); 
        }
        const QuantLib::Currency& currency() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->currency();
        }
        QuantLib::Position::Type position() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->position();
        }
        QuantLib::Real quantity() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->quantity(); 
        }
        const QuantLib::Date& maturityDate() const {
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->maturityDate();
        }
        QuantLib::Real strike() const { 
            return boost::dynamic_pointer_cast<CommodityForward>(*self)->strike(); 
        }
    }
};

%rename(DiscountingCommodityForwardEngine) DiscountingCommodityForwardEnginePtr;
class DiscountingCommodityForwardEnginePtr : public boost::shared_ptr<PricingEngine> {
public:
    %extend {
        DiscountingCommodityForwardEnginePtr(const QuantLib::Handle<PriceTermStructure>& priceCurve,
                                             const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
                                             boost::optional<bool> includeSettlementDateFlows = boost::none,
                                             const QuantLib::Date& npvDate = QuantLib::Date()) {
            return new DiscountingCommodityForwardEnginePtr(
                new DiscountingCommodityForwardEngine(priceCurve, 
                                                      discountCurve, 
                                                      includeSettlementDateFlows, 
                                                      npvDate));
        }
    }
};


#endif
