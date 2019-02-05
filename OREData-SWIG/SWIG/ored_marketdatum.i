
/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_marketdatum_i
#define ored_marketdatum_i

%{
using ore::data::MarketDatum;
using ore::data::parseMarketDatum;
%}

boost::shared_ptr<MarketDatum> parseMarketDatum(const Date&, const std::string&, const Real&);

%ignore MarketDatum;
class MarketDatum {
public:
    enum class InstrumentType {
        ZERO,
        DISCOUNT,
        MM,
        MM_FUTURE,
        FRA,
        IMM_FRA,
        IR_SWAP,
        BASIS_SWAP,
        BMA_SWAP,
        CC_BASIS_SWAP,
        CC_FIX_FLOAT_SWAP,
        CDS,
        CDS_INDEX,
        FX_SPOT,
        FX_FWD,
        HAZARD_RATE,
        RECOVERY_RATE,
        SWAPTION,
        CAPFLOOR,
        FX_OPTION,
        ZC_INFLATIONSWAP,
        ZC_INFLATIONCAPFLOOR,
        YY_INFLATIONSWAP,
        YY_INFLATIONCAPFLOOR,
        SEASONALITY,
        EQUITY_SPOT,
        EQUITY_FWD,
        EQUITY_DIVIDEND,
        EQUITY_OPTION,
        BOND,
        INDEX_CDS_OPTION,
        COMMODITY_SPOT,
        COMMODITY_FWD,
        COMMODITY_OPTION,
        CPR
    };

    enum class QuoteType {
        BASIS_SPREAD,
        CREDIT_SPREAD,
        YIELD_SPREAD,
        HAZARD_RATE,
        RATE,
        RATIO,
        PRICE,
        RATE_LNVOL,
        RATE_NVOL,
        RATE_SLNVOL,
        BASE_CORRELATION,
        SHIFT
    };
    MarketDatum(Real value, Date asofDate, const std::string& name, QuoteType quoteType, InstrumentType instrumentType);
    const std::string& name() const;
    const Handle<Quote>& quote() const;
    Date asofDate() const;
};
%template(MarketDatum) boost::shared_ptr<MarketDatum>;


%extend boost::shared_ptr<MarketDatum> {

    static const MarketDatum::InstrumentType InstrumentType_ZERO = MarketDatum::InstrumentType::ZERO;
    static const MarketDatum::InstrumentType InstrumentType_DISCOUNT = MarketDatum::InstrumentType::DISCOUNT;
    static const MarketDatum::InstrumentType InstrumentType_MM = MarketDatum::InstrumentType::MM;
    static const MarketDatum::InstrumentType InstrumentType_MM_FUTURE = MarketDatum::InstrumentType::MM_FUTURE;
    static const MarketDatum::InstrumentType InstrumentType_FRA = MarketDatum::InstrumentType::FRA;
    static const MarketDatum::InstrumentType InstrumentType_IMM_FRA = MarketDatum::InstrumentType::IMM_FRA;
    static const MarketDatum::InstrumentType InstrumentType_IR_SWAP = MarketDatum::InstrumentType::IR_SWAP;
    static const MarketDatum::InstrumentType InstrumentType_BASIS_SWAP = MarketDatum::InstrumentType::BASIS_SWAP;
    static const MarketDatum::InstrumentType InstrumentType_BMA_SWAP = MarketDatum::InstrumentType::BMA_SWAP;
    static const MarketDatum::InstrumentType InstrumentType_CC_BASIS_SWAP = MarketDatum::InstrumentType::CC_BASIS_SWAP;
    static const MarketDatum::InstrumentType InstrumentType_CC_FIX_FLOAT_SWAP = MarketDatum::InstrumentType::CC_FIX_FLOAT_SWAP;
    static const MarketDatum::InstrumentType InstrumentType_CDS = MarketDatum::InstrumentType::CDS;
    static const MarketDatum::InstrumentType InstrumentType_CDS_INDEX = MarketDatum::InstrumentType::CDS_INDEX;
    static const MarketDatum::InstrumentType InstrumentType_FX_SPOT = MarketDatum::InstrumentType::FX_SPOT;
    static const MarketDatum::InstrumentType InstrumentType_FX_FWD = MarketDatum::InstrumentType::FX_FWD;
    static const MarketDatum::InstrumentType InstrumentType_HAZARD_RATE = MarketDatum::InstrumentType::HAZARD_RATE;
    static const MarketDatum::InstrumentType InstrumentType_RECOVERY_RATE = MarketDatum::InstrumentType::RECOVERY_RATE;
    static const MarketDatum::InstrumentType InstrumentType_SWAPTION = MarketDatum::InstrumentType::SWAPTION;
    static const MarketDatum::InstrumentType InstrumentType_CAPFLOOR = MarketDatum::InstrumentType::CAPFLOOR;
    static const MarketDatum::InstrumentType InstrumentType_FX_OPTION = MarketDatum::InstrumentType::FX_OPTION;
    static const MarketDatum::InstrumentType InstrumentType_ZC_INFLATIONSWAP = MarketDatum::InstrumentType::ZC_INFLATIONSWAP;
    static const MarketDatum::InstrumentType InstrumentType_ZC_INFLATIONCAPFLOOR = MarketDatum::InstrumentType::ZC_INFLATIONCAPFLOOR;
    static const MarketDatum::InstrumentType InstrumentType_YY_INFLATIONSWAP = MarketDatum::InstrumentType::YY_INFLATIONSWAP;
    static const MarketDatum::InstrumentType InstrumentType_YY_INFLATIONCAPFLOOR = MarketDatum::InstrumentType::YY_INFLATIONCAPFLOOR;
    static const MarketDatum::InstrumentType InstrumentType_SEASONALITY = MarketDatum::InstrumentType::SEASONALITY;
    static const MarketDatum::InstrumentType InstrumentType_EQUITY_SPOT = MarketDatum::InstrumentType::EQUITY_SPOT;
    static const MarketDatum::InstrumentType InstrumentType_EQUITY_FWD = MarketDatum::InstrumentType::EQUITY_FWD;
    static const MarketDatum::InstrumentType InstrumentType_EQUITY_DIVIDEND = MarketDatum::InstrumentType::EQUITY_DIVIDEND;
    static const MarketDatum::InstrumentType InstrumentType_EQUITY_OPTION = MarketDatum::InstrumentType::EQUITY_OPTION;
    static const MarketDatum::InstrumentType InstrumentType_BOND = MarketDatum::InstrumentType::BOND;
    static const MarketDatum::InstrumentType InstrumentType_INDEX_CDS_OPTION = MarketDatum::InstrumentType::INDEX_CDS_OPTION;
    static const MarketDatum::InstrumentType InstrumentType_COMMODITY_SPOT = MarketDatum::InstrumentType::COMMODITY_SPOT;
    static const MarketDatum::InstrumentType InstrumentType_COMMODITY_FWD = MarketDatum::InstrumentType::COMMODITY_FWD;
    static const MarketDatum::InstrumentType InstrumentType_COMMODITY_OPTION = MarketDatum::InstrumentType::COMMODITY_OPTION;
    static const MarketDatum::InstrumentType InstrumentType_CPR = MarketDatum::InstrumentType::CPR;

    static const MarketDatum::QuoteType QuoteType_BASIS_SPREAD = MarketDatum::QuoteType::BASIS_SPREAD;
    static const MarketDatum::QuoteType QuoteType_CREDIT_SPREAD = MarketDatum::QuoteType::CREDIT_SPREAD;
    static const MarketDatum::QuoteType QuoteType_YIELD_SPREAD = MarketDatum::QuoteType::YIELD_SPREAD;
    static const MarketDatum::QuoteType QuoteType_HAZARD_RATE = MarketDatum::QuoteType::HAZARD_RATE;
    static const MarketDatum::QuoteType QuoteType_RATE = MarketDatum::QuoteType::RATE;
    static const MarketDatum::QuoteType QuoteType_RATIO = MarketDatum::QuoteType::RATIO;
    static const MarketDatum::QuoteType QuoteType_PRICE = MarketDatum::QuoteType::PRICE;
    static const MarketDatum::QuoteType QuoteType_RATE_LNVOL = MarketDatum::QuoteType::RATE_LNVOL;
    static const MarketDatum::QuoteType QuoteType_RATE_NVOL = MarketDatum::QuoteType::RATE_NVOL;
    static const MarketDatum::QuoteType QuoteType_RATE_SLNVOL = MarketDatum::QuoteType::RATE_SLNVOL;
    static const MarketDatum::QuoteType QuoteType_BASE_CORRELATION = MarketDatum::QuoteType::BASE_CORRELATION;
    static const MarketDatum::QuoteType QuoteType_SHIFT = MarketDatum::QuoteType::SHIFT;
    
    MarketDatum::InstrumentType instrumentType() {
        return boost::dynamic_pointer_cast<MarketDatum>(*self)->instrumentType();
    }
    MarketDatum::QuoteType quoteType() {
        return boost::dynamic_pointer_cast<MarketDatum>(*self)->quoteType();
    }
}


%{
using ore::data::MoneyMarketQuote;
typedef boost::shared_ptr<MarketDatum> MoneyMarketQuotePtr;
%}

%rename(MoneyMarketQuote) MoneyMarketQuotePtr;
class MoneyMarketQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        MoneyMarketQuotePtr(Real value, Date asofDate, const std::string& name,
                            MarketDatum::QuoteType quoteType, std::string ccy,
                            Period fwdStart, Period term) {
            return new MoneyMarketQuotePtr(new MoneyMarketQuote(value, asofDate, name,
                                                                quoteType, ccy,
                                                                fwdStart, term));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<MoneyMarketQuote>(*self)->ccy();
        }
        const Period& fwdStart() const {
            return boost::dynamic_pointer_cast<MoneyMarketQuote>(*self)->fwdStart();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<MoneyMarketQuote>(*self)->term();
        }
  }
};

%{
using ore::data::FRAQuote;
typedef boost::shared_ptr<MarketDatum> FRAQuotePtr;
%}

%rename(FRAQuote) FRAQuotePtr;
class FRAQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        FRAQuotePtr(Real value, Date asofDate, const std::string& name,
                    MarketDatum::QuoteType quoteType, std::string ccy,
                    Period fwdStart, Period term) {
            return new FRAQuotePtr(new FRAQuote(value, asofDate, name,
                                                quoteType, ccy,
                                                fwdStart, term));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<FRAQuote>(*self)->ccy();
        }
        const Period& fwdStart() const {
            return boost::dynamic_pointer_cast<FRAQuote>(*self)->fwdStart();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<FRAQuote>(*self)->term();
        }
  }
};

%{
using ore::data::ImmFraQuote;
typedef boost::shared_ptr<MarketDatum> ImmFraQuotePtr;
%}

%rename(ImmFraQuote) ImmFraQuotePtr;
class ImmFraQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        ImmFraQuotePtr(Real value, Date asofDate, const std::string& name,
                       MarketDatum::QuoteType quoteType, std::string ccy, Size imm1, Size imm2) {
            return new ImmFraQuotePtr(new ImmFraQuote(value, asofDate, name,
                                                      quoteType, ccy,
                                                      imm1, imm2));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<ImmFraQuote>(*self)->ccy();
        }
        const Size& imm1() const {
            return boost::dynamic_pointer_cast<ImmFraQuote>(*self)->imm1();
        }
        const Size& imm2() const {
            return boost::dynamic_pointer_cast<ImmFraQuote>(*self)->imm2();
        }
  }
};

%{
using ore::data::SwapQuote;
typedef boost::shared_ptr<MarketDatum> SwapQuotePtr;
%}

%rename(SwapQuote) SwapQuotePtr;
class SwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        SwapQuotePtr(Real value, Date asofDate, const std::string& name,
                     MarketDatum::QuoteType quoteType, std::string ccy,
                     Period fwdStart, Period term, Period tenor) {
            return new SwapQuotePtr(new SwapQuote(value, asofDate, name,
                                                  quoteType, ccy,
                                                  fwdStart, term, tenor));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<SwapQuote>(*self)->ccy();
        }
        const Period& fwdStart() const {
            return boost::dynamic_pointer_cast<SwapQuote>(*self)->fwdStart();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<SwapQuote>(*self)->term();
        }
        const Period& tenor() const {
            return boost::dynamic_pointer_cast<SwapQuote>(*self)->tenor();
        }
  }
};

%{
using ore::data::ZeroQuote;
typedef boost::shared_ptr<MarketDatum> ZeroQuotePtr;
%}

%rename(ZeroQuote) ZeroQuotePtr;
class ZeroQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        ZeroQuotePtr(Real value, Date asofDate, const std::string& name,
                     MarketDatum::QuoteType quoteType, std::string ccy, Date date,
                     DayCounter dayCounter, Period tenor = Period()) {
            return new ZeroQuotePtr(new ZeroQuote(value, asofDate, name,
                                                  quoteType, ccy, date,
                                                  dayCounter, tenor));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<ZeroQuote>(*self)->ccy();
        }
        Date date() const {
            return boost::dynamic_pointer_cast<ZeroQuote>(*self)->date();
        }
        DayCounter dayCounter() const {
            return boost::dynamic_pointer_cast<ZeroQuote>(*self)->dayCounter();
        }
        const Period& tenor() const {
            return boost::dynamic_pointer_cast<ZeroQuote>(*self)->tenor();
        }
        bool tenorBased() const {
            return boost::dynamic_pointer_cast<ZeroQuote>(*self)->tenorBased();
        }
  }
};

%{
using ore::data::DiscountQuote;
typedef boost::shared_ptr<MarketDatum> DiscountQuotePtr;
%}

%rename(DiscountQuote) DiscountQuotePtr;
class DiscountQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        DiscountQuotePtr(Real value, Date asofDate, const std::string& name,
                         MarketDatum::QuoteType quoteType, std::string ccy, Date date) {
            return new DiscountQuotePtr(new DiscountQuote(value, asofDate, name,
                                                          quoteType, ccy, date));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<DiscountQuote>(*self)->ccy();
        }
        Date date() const {
            return boost::dynamic_pointer_cast<DiscountQuote>(*self)->date();
        }
  }
};

%{
using ore::data::MMFutureQuote;
typedef boost::shared_ptr<MarketDatum> MMFutureQuotePtr;
%}

%rename(MMFutureQuote) MMFutureQuotePtr;
class MMFutureQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        MMFutureQuotePtr(Real value, Date asofDate, const std::string& name,
                         MarketDatum::QuoteType quoteType, std::string ccy, std::string expiry,
                         std::string contract="", Period tenor = 3 * Months) {
            return new MMFutureQuotePtr(new MMFutureQuote(value, asofDate, name,
                                                          quoteType, ccy, expiry,
                                                          contract, tenor));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->ccy();
        }
        const std::string expiry() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->expiry();
        }
        Natural expiryYear() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->expiryYear();
        }
        Month expiryMonth() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->expiryMonth();
        }
        const std::string& contract() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->contract();
        }
        const Period& tenor() const {
            return boost::dynamic_pointer_cast<MMFutureQuote>(*self)->tenor();
        }
  }
};

%{
using ore::data::BasisSwapQuote;
typedef boost::shared_ptr<MarketDatum> BasisSwapQuotePtr;
%}

%rename(BasisSwapQuote) BasisSwapQuotePtr;
class BasisSwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        BasisSwapQuotePtr(Real value, Date asofDate, const std::string& name,
                          MarketDatum::QuoteType quoteType, Period flatTerm, Period term,
                          std::string ccy= "USD", Period maturity = 3 * Months) {
            return new BasisSwapQuotePtr(new BasisSwapQuote(value, asofDate, name,
                                                            quoteType, flatTerm, term,
                                                            ccy, maturity));
        }
        const Period& flatTerm() const {
            return boost::dynamic_pointer_cast<BasisSwapQuote>(*self)->flatTerm();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<BasisSwapQuote>(*self)->term();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<BasisSwapQuote>(*self)->ccy();
        }
        const Period& maturity() const {
            return boost::dynamic_pointer_cast<BasisSwapQuote>(*self)->maturity();
        }
  }
};

%{
using ore::data::BMASwapQuote;
typedef boost::shared_ptr<MarketDatum> BMASwapQuotePtr;
%}

%rename(BMASwapQuote) BMASwapQuotePtr;
class BMASwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        BMASwapQuotePtr(Real value, Date asofDate, const std::string& name,
                        MarketDatum::QuoteType quoteType, Period term,
                        std::string ccy= "USD", Period maturity = 3 * Months) {
            return new BMASwapQuotePtr(new BMASwapQuote(value, asofDate, name,
                                                        quoteType, term,
                                                        ccy, maturity));
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<BMASwapQuote>(*self)->term();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<BMASwapQuote>(*self)->ccy();
        }
        const Period& maturity() const {
            return boost::dynamic_pointer_cast<BMASwapQuote>(*self)->maturity();
        }
  }
};

%{
using ore::data::CrossCcyBasisSwapQuote;
typedef boost::shared_ptr<MarketDatum> CrossCcyBasisSwapQuotePtr;
%}

%rename(CrossCcyBasisSwapQuote) CrossCcyBasisSwapQuotePtr;
class CrossCcyBasisSwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CrossCcyBasisSwapQuotePtr(Real value, Date asofDate, const std::string& name,
                                  MarketDatum::QuoteType quoteType, std::string flatCcy, Period flatTerm,
                                  std::string ccy, Period term, Period maturity = 3 * Months) {
            return new CrossCcyBasisSwapQuotePtr(new CrossCcyBasisSwapQuote(value, asofDate, name,
                                                                            quoteType, flatCcy, flatTerm,
                                                                            ccy, term, maturity));
        }
        const std::string& flatCcy() const {
            return boost::dynamic_pointer_cast<CrossCcyBasisSwapQuote>(*self)->flatCcy();
        }
        const Period& flatTerm() const {
            return boost::dynamic_pointer_cast<CrossCcyBasisSwapQuote>(*self)->flatTerm();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<CrossCcyBasisSwapQuote>(*self)->ccy();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<CrossCcyBasisSwapQuote>(*self)->term();
        }
        const Period& maturity() const {
            return boost::dynamic_pointer_cast<CrossCcyBasisSwapQuote>(*self)->maturity();
        }
  }
};

%{
using ore::data::CrossCcyFixFloatSwapQuote;
typedef boost::shared_ptr<MarketDatum> CrossCcyFixFloatSwapQuotePtr;
%}

%rename(CrossCcyFixFloatSwapQuote) CrossCcyFixFloatSwapQuotePtr;
class CrossCcyFixFloatSwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CrossCcyFixFloatSwapQuotePtr(Real value, Date asofDate, const std::string& name,
                                     MarketDatum::QuoteType quoteType,
                                     const QuantLib::Currency& floatCurrency, const Period& floatTenor,
                                     const QuantLib::Currency& fixedCurrency, const Period& fixedTenor,
                                     const Period& maturity = 3 * Months) {
            return new CrossCcyFixFloatSwapQuotePtr(new CrossCcyFixFloatSwapQuote(value, asofDate, name,
                                                                                  quoteType,
                                                                                  floatCurrency, floatTenor,
                                                                                  fixedCurrency, fixedTenor,
                                                                                  maturity));
        }
        const QuantLib::Currency& floatCurrency() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapQuote>(*self)->floatCurrency();
        }
        const QuantLib::Period& floatTenor() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapQuote>(*self)->floatTenor();
        }
        const QuantLib::Currency& fixedCurrency() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapQuote>(*self)->fixedCurrency();
        }
        const QuantLib::Period& fixedTenor() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapQuote>(*self)->fixedTenor();
        }
        const QuantLib::Period& maturity() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapQuote>(*self)->maturity();
        }
  }
};

%{
using ore::data::CdsSpreadQuote;
typedef boost::shared_ptr<MarketDatum> CdsSpreadQuotePtr;
%}

%rename(CdsSpreadQuote) CdsSpreadQuotePtr;
class CdsSpreadQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CdsSpreadQuotePtr(Real value, Date asofDate, const std::string& name,
                          const std::string& underlyingName, const std::string& seniority,
                          const std::string& ccy, Period term) {
            return new CdsSpreadQuotePtr(new CdsSpreadQuote(value, asofDate, name,
                                                            underlyingName, seniority,
                                                            ccy, term));
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<CdsSpreadQuote>(*self)->term();
        }
        const std::string& seniority() const {
            return boost::dynamic_pointer_cast<CdsSpreadQuote>(*self)->seniority();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<CdsSpreadQuote>(*self)->ccy();
        }
        const std::string& underlyingName() const {
            return boost::dynamic_pointer_cast<CdsSpreadQuote>(*self)->underlyingName();
        }
  }
};

%{
using ore::data::HazardRateQuote;
typedef boost::shared_ptr<MarketDatum> HazardRateQuotePtr;
%}

%rename(HazardRateQuote) HazardRateQuotePtr;
class HazardRateQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        HazardRateQuotePtr(Real value, Date asofDate, const std::string& name,
                           const std::string& underlyingName, const std::string& seniority,
                           const std::string& ccy, Period term) {
            return new HazardRateQuotePtr(new HazardRateQuote(value, asofDate, name,
                                                              underlyingName, seniority,
                                                              ccy, term));
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<HazardRateQuote>(*self)->term();
        }
        const std::string& seniority() const {
            return boost::dynamic_pointer_cast<HazardRateQuote>(*self)->seniority();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<HazardRateQuote>(*self)->ccy();
        }
        const std::string& underlyingName() const {
            return boost::dynamic_pointer_cast<HazardRateQuote>(*self)->underlyingName();
        }
  }
};

%{
using ore::data::RecoveryRateQuote;
typedef boost::shared_ptr<MarketDatum> RecoveryRateQuotePtr;
%}

%rename(RecoveryRateQuote) RecoveryRateQuotePtr;
class RecoveryRateQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        RecoveryRateQuotePtr(Real value, Date asofDate, const std::string& name,
                             const std::string& underlyingName, const std::string& seniority,
                             const std::string& ccy) {
            return new RecoveryRateQuotePtr(new RecoveryRateQuote(value, asofDate, name,
                                                                  underlyingName, seniority,
                                                                  ccy));
        }
        const std::string& seniority() const {
            return boost::dynamic_pointer_cast<RecoveryRateQuote>(*self)->seniority();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<RecoveryRateQuote>(*self)->ccy();
        }
        const std::string& underlyingName() const {
            return boost::dynamic_pointer_cast<RecoveryRateQuote>(*self)->underlyingName();
        }
  }
};

%{
using ore::data::SwaptionQuote;
typedef boost::shared_ptr<MarketDatum> SwaptionQuotePtr;
%}

%rename(SwaptionQuote) SwaptionQuotePtr;
class SwaptionQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        SwaptionQuotePtr(Real value, Date asofDate, const std::string& name,
                         MarketDatum::QuoteType quoteType, std::string ccy, Period expiry,
                         Period term, std::string dimension, Real strike = 0.0) {
            return new SwaptionQuotePtr(new SwaptionQuote(value, asofDate, name,
                                                          quoteType, ccy, expiry,
                                                          term, dimension, strike));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<SwaptionQuote>(*self)->ccy();
        }
        const Period& expiry() const {
            return boost::dynamic_pointer_cast<SwaptionQuote>(*self)->expiry();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<SwaptionQuote>(*self)->term();
        }
        const std::string& dimension() const {
            return boost::dynamic_pointer_cast<SwaptionQuote>(*self)->dimension();
        }
        Real strike() const {
            return boost::dynamic_pointer_cast<SwaptionQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::SwaptionShiftQuote;
typedef boost::shared_ptr<MarketDatum> SwaptionShiftQuotePtr;
%}

%rename(SwaptionShiftQuote) SwaptionShiftQuotePtr;
class SwaptionShiftQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        SwaptionShiftQuotePtr(Real value, Date asofDate, const std::string& name,
                              MarketDatum::QuoteType quoteType, std::string ccy, Period term) {
            return new SwaptionShiftQuotePtr(new SwaptionShiftQuote(value, asofDate, name,
                                                                    quoteType, ccy, term));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<SwaptionShiftQuote>(*self)->ccy();
        }
        const Period& expiry() const {
            return boost::dynamic_pointer_cast<SwaptionShiftQuote>(*self)->expiry();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<SwaptionShiftQuote>(*self)->term();
        }
  }
};

%{
using ore::data::CapFloorQuote;
typedef boost::shared_ptr<MarketDatum> CapFloorQuotePtr;
%}

%rename(CapFloorQuote) CapFloorQuotePtr;
class CapFloorQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CapFloorQuotePtr(Real value, Date asofDate, const std::string& name,
                         MarketDatum::QuoteType quoteType, std::string ccy, Period term,
                         Period underlying, bool atm, bool relative, Real strike = 0.0) {
            return new CapFloorQuotePtr(new CapFloorQuote(value, asofDate, name,
                                                          quoteType, ccy, term,
                                                          underlying, atm, relative, strike));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->ccy();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->term();
        }
        const Period& underlying() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->underlying();
        }
        bool atm() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->atm();
        }
        bool relative() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->relative();
        }
        Real strike() const {
            return boost::dynamic_pointer_cast<CapFloorQuote>(*self)->strike();
        }
        
  }
};

%{
using ore::data::CapFloorShiftQuote;
typedef boost::shared_ptr<MarketDatum> CapFloorShiftQuotePtr;
%}

%rename(CapFloorShiftQuote) CapFloorShiftQuotePtr;
class CapFloorShiftQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CapFloorShiftQuotePtr(Real value, Date asofDate, const std::string& name,
                              MarketDatum::QuoteType quoteType, std::string ccy,
                              const Period& indexTenor) {
            return new CapFloorShiftQuotePtr(new CapFloorShiftQuote(value, asofDate, name,
                                                                    quoteType, ccy, indexTenor));
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<CapFloorShiftQuote>(*self)->ccy();
        }
        const Period& indexTenor() const {
            return boost::dynamic_pointer_cast<CapFloorShiftQuote>(*self)->indexTenor();
        }
  }
};

%{
using ore::data::FXSpotQuote;
typedef boost::shared_ptr<MarketDatum> FXSpotQuotePtr;
%}

%rename(FXSpotQuote) FXSpotQuotePtr;
class FXSpotQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        FXSpotQuotePtr(Real value, Date asofDate, const std::string& name,
                       MarketDatum::QuoteType quoteType,
                       std::string unitCcy, std::string ccy) {
            return new FXSpotQuotePtr(new FXSpotQuote(value, asofDate, name,
                                                      quoteType, unitCcy, ccy));
        }
        const std::string& unitCcy() const {
            return boost::dynamic_pointer_cast<FXSpotQuote>(*self)->unitCcy();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<FXSpotQuote>(*self)->ccy();
        }
  }
};

%{
using ore::data::FXForwardQuote;
typedef boost::shared_ptr<MarketDatum> FXForwardQuotePtr;
%}

%rename(FXForwardQuote) FXForwardQuotePtr;
class FXForwardQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        FXForwardQuotePtr(Real value, Date asofDate, const std::string& name,
                          MarketDatum::QuoteType quoteType,
                          std::string unitCcy, std::string ccy,
                          const Period& term, Real conversionFactor = 1.0) {
            return new FXForwardQuotePtr(new FXForwardQuote(value, asofDate, name,
                                                            quoteType, unitCcy, ccy,
                                                            term, conversionFactor));
        }
        const std::string& unitCcy() const {
            return boost::dynamic_pointer_cast<FXForwardQuote>(*self)->unitCcy();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<FXForwardQuote>(*self)->ccy();
        }
        const Period& term() const {
            return boost::dynamic_pointer_cast<FXForwardQuote>(*self)->term();
        }
        Real conversionFactor() const {
            return boost::dynamic_pointer_cast<FXForwardQuote>(*self)->conversionFactor();
        }
  }
};

%{
using ore::data::FXOptionQuote;
typedef boost::shared_ptr<MarketDatum> FXOptionQuotePtr;
%}

%rename(FXOptionQuote) FXOptionQuotePtr;
class FXOptionQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        FXOptionQuotePtr(Real value, Date asofDate, const std::string& name,
                         MarketDatum::QuoteType quoteType,
                         std::string unitCcy, std::string ccy,
                         Period expiry, std::string strike) {
            return new FXOptionQuotePtr(new FXOptionQuote(value, asofDate, name,
                                                          quoteType, unitCcy, ccy,
                                                          expiry, strike));
        }
        const std::string& unitCcy() const {
            return boost::dynamic_pointer_cast<FXOptionQuote>(*self)->unitCcy();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<FXOptionQuote>(*self)->ccy();
        }
        const Period& expiry() const {
            return boost::dynamic_pointer_cast<FXOptionQuote>(*self)->expiry();
        }
        const std::string& strike() const {
            return boost::dynamic_pointer_cast<FXOptionQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::ZcInflationSwapQuote;
typedef boost::shared_ptr<MarketDatum> ZcInflationSwapQuotePtr;
%}

%rename(ZcInflationSwapQuote) ZcInflationSwapQuotePtr;
class ZcInflationSwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        ZcInflationSwapQuotePtr(Real value, Date asofDate, const std::string& name,
                                const std::string& index, Period term) {
            return new ZcInflationSwapQuotePtr(new ZcInflationSwapQuote(value, asofDate, name,
                                                                        index, term));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<ZcInflationSwapQuote>(*self)->index();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<ZcInflationSwapQuote>(*self)->term();
        }
  }
};

%{
using ore::data::InflationCapFloorQuote;
typedef boost::shared_ptr<MarketDatum> InflationCapFloorQuotePtr;
%}

%rename(InflationCapFloorQuote) InflationCapFloorQuotePtr;
class InflationCapFloorQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        InflationCapFloorQuotePtr(Real value, Date asofDate, const std::string& name,
                                  MarketDatum::QuoteType quoteType,
                                  const std::string& index, Period term,
                                  bool isCap, const std::string& strike,
                                  MarketDatum::InstrumentType instrumentType) {
            return new InflationCapFloorQuotePtr(new InflationCapFloorQuote(value, asofDate, name,
                                                                            quoteType,
                                                                            index, term,
                                                                            isCap, strike, instrumentType));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<InflationCapFloorQuote>(*self)->index();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<InflationCapFloorQuote>(*self)->term();
        }
        bool isCap() const {
            return boost::dynamic_pointer_cast<InflationCapFloorQuote>(*self)->isCap();
        }
        std::string strike() const {
            return boost::dynamic_pointer_cast<InflationCapFloorQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::ZcInflationCapFloorQuote;
typedef boost::shared_ptr<MarketDatum> ZcInflationCapFloorQuotePtr;
%}

%rename(ZcInflationCapFloorQuote) ZcInflationCapFloorQuotePtr;
class ZcInflationCapFloorQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        ZcInflationCapFloorQuotePtr(Real value, Date asofDate, const std::string& name,
                                    MarketDatum::QuoteType quoteType,
                                    const std::string& index, Period term,
                                    bool isCap, const std::string& strike) {
            return new ZcInflationCapFloorQuotePtr(new ZcInflationCapFloorQuote(value, asofDate, name,
                                                                                quoteType,
                                                                                index, term,
                                                                                isCap, strike));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<ZcInflationCapFloorQuote>(*self)->index();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<ZcInflationCapFloorQuote>(*self)->term();
        }
        bool isCap() const {
            return boost::dynamic_pointer_cast<ZcInflationCapFloorQuote>(*self)->isCap();
        }
        std::string strike() const {
            return boost::dynamic_pointer_cast<ZcInflationCapFloorQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::YoYInflationSwapQuote;
typedef boost::shared_ptr<MarketDatum> YoYInflationSwapQuotePtr;
%}

%rename(YoYInflationSwapQuote) YoYInflationSwapQuotePtr;
class YoYInflationSwapQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        YoYInflationSwapQuotePtr(Real value, Date asofDate, const std::string& name,
                                 const std::string& index, Period term) {
            return new YoYInflationSwapQuotePtr(new YoYInflationSwapQuote(value, asofDate, name,
                                                                          index, term));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<YoYInflationSwapQuote>(*self)->index();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<YoYInflationSwapQuote>(*self)->term();
        }
  }
};

%{
using ore::data::YyInflationCapFloorQuote;
typedef boost::shared_ptr<MarketDatum> YyInflationCapFloorQuotePtr;
%}

%rename(YyInflationCapFloorQuote) YyInflationCapFloorQuotePtr;
class YyInflationCapFloorQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        YyInflationCapFloorQuotePtr(Real value, Date asofDate, const std::string& name,
                                     MarketDatum::QuoteType quoteType,
                                     const std::string& index, Period term,
                                     bool isCap, const std::string& strike) {
            return new YyInflationCapFloorQuotePtr(new YyInflationCapFloorQuote(value, asofDate, name,
                                                                                quoteType,
                                                                                index, term,
                                                                                isCap, strike));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<YyInflationCapFloorQuote>(*self)->index();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<YyInflationCapFloorQuote>(*self)->term();
        }
        bool isCap() const {
            return boost::dynamic_pointer_cast<YyInflationCapFloorQuote>(*self)->isCap();
        }
        std::string strike() const {
            return boost::dynamic_pointer_cast<YyInflationCapFloorQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::SeasonalityQuote;
typedef boost::shared_ptr<MarketDatum> SeasonalityQuotePtr;
%}

%rename(SeasonalityQuote) SeasonalityQuotePtr;
class SeasonalityQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        SeasonalityQuotePtr(Real value, Date asofDate, const std::string& name,
                            const std::string& index, const std::string& type,
                            const std::string& month) {
            return new SeasonalityQuotePtr(new SeasonalityQuote(value, asofDate, name,
                                                                index, type, month));
        }
        std::string index() const {
            return boost::dynamic_pointer_cast<SeasonalityQuote>(*self)->index();
        }
        std::string type() const {
            return boost::dynamic_pointer_cast<SeasonalityQuote>(*self)->type();
        }
        std::string month() const {
            return boost::dynamic_pointer_cast<SeasonalityQuote>(*self)->month();
        }
        QuantLib::Size applyMonth() const {
            return boost::dynamic_pointer_cast<SeasonalityQuote>(*self)->applyMonth();
        }
  }
};

%{
using ore::data::EquitySpotQuote;
typedef boost::shared_ptr<MarketDatum> EquitySpotQuotePtr;
%}

%rename(EquitySpotQuote) EquitySpotQuotePtr;
class EquitySpotQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        EquitySpotQuotePtr(Real value, Date asofDate, const std::string& name,
                            MarketDatum::QuoteType quoteType,
                            std::string equityName, std::string ccy) {
            return new EquitySpotQuotePtr(new EquitySpotQuote(value, asofDate, name,
                                                              quoteType,
                                                              equityName, ccy));
        }
        const std::string& eqName() const {
            return boost::dynamic_pointer_cast<EquitySpotQuote>(*self)->eqName();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<EquitySpotQuote>(*self)->ccy();
        }
  }
};

%{
using ore::data::EquityForwardQuote;
typedef boost::shared_ptr<MarketDatum> EquityForwardQuotePtr;
%}

%rename(EquityForwardQuote) EquityForwardQuotePtr;
class EquityForwardQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        EquityForwardQuotePtr(Real value, Date asofDate, const std::string& name,
                              MarketDatum::QuoteType quoteType,
                              std::string equityName, std::string ccy,
                              const Date& expiryDate) {
            return new EquityForwardQuotePtr(new EquityForwardQuote(value, asofDate, name,
                                                                    quoteType,
                                                                    equityName, ccy, expiryDate));
        }
        const std::string& eqName() const {
            return boost::dynamic_pointer_cast<EquityForwardQuote>(*self)->eqName();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<EquityForwardQuote>(*self)->ccy();
        }
        const Date& expiryDate() const {
            return boost::dynamic_pointer_cast<EquityForwardQuote>(*self)->expiryDate();
        }
  }
};

%{
using ore::data::EquityDividendYieldQuote;
typedef boost::shared_ptr<MarketDatum> EquityDividendYieldQuotePtr;
%}

%rename(EquityDividendYieldQuote) EquityDividendYieldQuotePtr;
class EquityDividendYieldQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        EquityDividendYieldQuotePtr(Real value, Date asofDate, const std::string& name,
                                    MarketDatum::QuoteType quoteType,
                                    std::string equityName, std::string ccy,
                                    const Date& tenorDate) {
            return new EquityDividendYieldQuotePtr(new EquityDividendYieldQuote(value, asofDate, name,
                                                                                quoteType,
                                                                                equityName, ccy, tenorDate));
        }
        const std::string& eqName() const {
            return boost::dynamic_pointer_cast<EquityDividendYieldQuote>(*self)->eqName();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<EquityDividendYieldQuote>(*self)->ccy();
        }
        const Date& tenorDate() const {
            return boost::dynamic_pointer_cast<EquityDividendYieldQuote>(*self)->tenorDate();
        }
  }
};

%{
using ore::data::EquityOptionQuote;
typedef boost::shared_ptr<MarketDatum> EquityOptionQuotePtr;
%}

%rename(EquityOptionQuote) EquityOptionQuotePtr;
class EquityOptionQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        EquityOptionQuotePtr(Real value, Date asofDate, const std::string& name,
                             MarketDatum::QuoteType quoteType,
                             std::string equityName, std::string ccy,
                             std::string expiry, std::string strike) {
            return new EquityOptionQuotePtr(new EquityOptionQuote(value, asofDate, name,
                                                                  quoteType, equityName, ccy,
                                                                  expiry, strike));
        }
        const std::string& eqName() const {
            return boost::dynamic_pointer_cast<EquityOptionQuote>(*self)->eqName();
        }
        const std::string& ccy() const {
            return boost::dynamic_pointer_cast<EquityOptionQuote>(*self)->ccy();
        }
        const std::string& expiry() const {
            return boost::dynamic_pointer_cast<EquityOptionQuote>(*self)->expiry();
        }
        const std::string& strike() const {
            return boost::dynamic_pointer_cast<EquityOptionQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::SecuritySpreadQuote;
typedef boost::shared_ptr<MarketDatum> SecuritySpreadQuotePtr;
%}

%rename(SecuritySpreadQuote) SecuritySpreadQuotePtr;
class SecuritySpreadQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        SecuritySpreadQuotePtr(Real value, Date asofDate, const std::string& name,
                               const std::string securityID) {
            return new SecuritySpreadQuotePtr(new SecuritySpreadQuote(value, asofDate, name,
                                                                      securityID));
        }
        const std::string& securityID() const {
            return boost::dynamic_pointer_cast<SecuritySpreadQuote>(*self)->securityID();
        }
  }
};

%{
using ore::data::BaseCorrelationQuote;
typedef boost::shared_ptr<MarketDatum> BaseCorrelationQuotePtr;
%}

%rename(BaseCorrelationQuote) BaseCorrelationQuotePtr;
class BaseCorrelationQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        BaseCorrelationQuotePtr(Real value, Date asofDate, const std::string& name,
                                MarketDatum::QuoteType quoteType,
                                const std::string cdsIndexName,
                                Period term, Real detachmentPoint) {
            return new BaseCorrelationQuotePtr(new BaseCorrelationQuote(value, asofDate, name,
                                                                        quoteType, cdsIndexName,
                                                                        term, detachmentPoint));
        }
        const std::string& cdsIndexName() const {
            return boost::dynamic_pointer_cast<BaseCorrelationQuote>(*self)->cdsIndexName();
        }
        Real detachmentPoint() const {
            return boost::dynamic_pointer_cast<BaseCorrelationQuote>(*self)->detachmentPoint();
        }
        Period term() const {
            return boost::dynamic_pointer_cast<BaseCorrelationQuote>(*self)->term();
        }
  }
};

%{
using ore::data::IndexCDSOptionQuote;
typedef boost::shared_ptr<MarketDatum> IndexCDSOptionQuotePtr;
%}

%rename(IndexCDSOptionQuote) IndexCDSOptionQuotePtr;
class IndexCDSOptionQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        IndexCDSOptionQuotePtr(Real value, Date asofDate, const std::string& name,
                               const std::string& indexName, const std::string& expiry) {
            return new IndexCDSOptionQuotePtr(new IndexCDSOptionQuote(value, asofDate, name,
                                                                      indexName, expiry));
        }
        const std::string& indexName() const {
            return boost::dynamic_pointer_cast<IndexCDSOptionQuote>(*self)->indexName();
        }
        const std::string& expiry() const {
            return boost::dynamic_pointer_cast<IndexCDSOptionQuote>(*self)->expiry();
        }
  }
};

%{
using ore::data::CommoditySpotQuote;
typedef boost::shared_ptr<MarketDatum> CommoditySpotQuotePtr;
%}

%rename(CommoditySpotQuote) CommoditySpotQuotePtr;
class CommoditySpotQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CommoditySpotQuotePtr(Real value, Date asofDate, const std::string& name,
                                MarketDatum::QuoteType quoteType,
                                const std::string commodityName,
                                const std::string quoteCurrency) {
            return new CommoditySpotQuotePtr(new CommoditySpotQuote(value, asofDate, name,
                                                                    quoteType,
                                                                    commodityName, quoteCurrency));
        }
        const std::string& commodityName() const {
            return boost::dynamic_pointer_cast<CommoditySpotQuote>(*self)->commodityName();
        }
        const std::string& quoteCurrency() const {
            return boost::dynamic_pointer_cast<CommoditySpotQuote>(*self)->quoteCurrency();
        }
  }
};

%{
using ore::data::CommodityForwardQuote;
typedef boost::shared_ptr<MarketDatum> CommodityForwardQuotePtr;
%}

%rename(CommodityForwardQuote) CommodityForwardQuotePtr;
class CommodityForwardQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CommodityForwardQuotePtr(Real value, Date asofDate, const std::string& name,
                                 MarketDatum::QuoteType quoteType,
                                 const std::string commodityName,
                                 const std::string quoteCurrency,
                                 const QuantLib::Date& expiryDate) {
            return new CommodityForwardQuotePtr(new CommodityForwardQuote(value, asofDate, name,
                                                                          quoteType,
                                                                          commodityName, quoteCurrency,
                                                                          expiryDate));
        }
        const std::string& commodityName() const {
            return boost::dynamic_pointer_cast<CommodityForwardQuote>(*self)->commodityName();
        }
        const std::string& quoteCurrency() const {
            return boost::dynamic_pointer_cast<CommodityForwardQuote>(*self)->quoteCurrency();
        }
        const QuantLib::Date& expiryDate() const {
            return boost::dynamic_pointer_cast<CommodityForwardQuote>(*self)->expiryDate();
        }
  }
};

%{
using ore::data::CommodityOptionQuote;
typedef boost::shared_ptr<MarketDatum> CommodityOptionQuotePtr;
%}

%rename(CommodityOptionQuote) CommodityOptionQuotePtr;
class CommodityOptionQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CommodityOptionQuotePtr(Real value, Date asofDate, const std::string& name,
                                MarketDatum::QuoteType quoteType,
                                const std::string commodityName,
                                const std::string quoteCurrency,
                                const std::string expiry,
                                const std::string strike) {
            return new CommodityOptionQuotePtr(new CommodityOptionQuote(value, asofDate, name,
                                                                        quoteType,
                                                                        commodityName, quoteCurrency,
                                                                        expiry, strike));
        }
        const std::string& commodityName() const {
            return boost::dynamic_pointer_cast<CommodityOptionQuote>(*self)->commodityName();
        }
        const std::string& quoteCurrency() const {
            return boost::dynamic_pointer_cast<CommodityOptionQuote>(*self)->quoteCurrency();
        }
        const std::string& expiry() const {
            return boost::dynamic_pointer_cast<CommodityOptionQuote>(*self)->expiry();
        }
        const std::string& strike() const {
            return boost::dynamic_pointer_cast<CommodityOptionQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::CorrelationQuote;
typedef boost::shared_ptr<MarketDatum> CorrelationQuotePtr;
%}

%rename(CorrelationQuote) CorrelationQuotePtr;
class CorrelationQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CorrelationQuotePtr(Real value, Date asofDate, const std::string& name,
                            MarketDatum::QuoteType quoteType,
                            const std::string index1,
                            const std::string index2,
                            const std::string expiry,
                            const std::string strike) {
            return new CorrelationQuotePtr(new CorrelationQuote(value, asofDate, name,
                                                                quoteType,
                                                                index1, index2,
                                                                expiry, strike));
        }
        const std::string& index1() const {
            return boost::dynamic_pointer_cast<CorrelationQuote>(*self)->index1();
        }
        const std::string& index2() const {
            return boost::dynamic_pointer_cast<CorrelationQuote>(*self)->index2();
        }
        const std::string& expiry() const {
            return boost::dynamic_pointer_cast<CorrelationQuote>(*self)->expiry();
        }
        const std::string& strike() const {
            return boost::dynamic_pointer_cast<CorrelationQuote>(*self)->strike();
        }
  }
};

%{
using ore::data::CPRQuote;
typedef boost::shared_ptr<MarketDatum> CPRQuotePtr;
%}

%rename(CPRQuote) CPRQuotePtr;
class CPRQuotePtr : public boost::shared_ptr<MarketDatum> {
public:
  %extend {
        CPRQuotePtr(Real value, Date asofDate, const std::string& name,
                    const std::string securityID) {
            return new CPRQuotePtr(new CPRQuote(value, asofDate, name, securityID));
        }
        const std::string& securityID() const {
            return boost::dynamic_pointer_cast<CPRQuote>(*self)->securityID();
        }
  }
};

#endif