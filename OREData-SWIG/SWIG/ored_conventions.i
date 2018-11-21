
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_conventions_i
#define ored_conventions_i

%include indexes.i
%include inflation.i

%{
// put c++ declarations here
using ore::data::Conventions;
using ore::data::Convention;
using ore::data::ZeroRateConvention;
using ore::data::DepositConvention;
using ore::data::FutureConvention;
using ore::data::FraConvention;
using ore::data::OisConvention;
using ore::data::SwapIndexConvention;
using ore::data::IRSwapConvention;
using ore::data::AverageOisConvention;
using ore::data::TenorBasisSwapConvention;
using ore::data::TenorBasisTwoSwapConvention;
using ore::data::BMABasisSwapConvention;
using ore::data::FXConvention;
using ore::data::CrossCcyBasisSwapConvention;
using ore::data::CrossCcyFixFloatSwapConvention;
using ore::data::CdsConvention;
using ore::data::InflationSwapConvention;
using ore::data::SecuritySpreadConvention;


typedef boost::shared_ptr<ore::data::ZeroRateConvention> ZeroRateConventionPtr;
typedef boost::shared_ptr<ore::data::DepositConvention> DepositConventionPtr;
typedef boost::shared_ptr<ore::data::FutureConvention> FutureConventionPtr;
typedef boost::shared_ptr<ore::data::FraConvention> FraConventionPtr;
typedef boost::shared_ptr<ore::data::OisConvention> OisConventionPtr;
typedef boost::shared_ptr<ore::data::SwapIndexConvention> SwapIndexConventionPtr;
typedef boost::shared_ptr<ore::data::IRSwapConvention> IRSwapConventionPtr;
typedef boost::shared_ptr<ore::data::AverageOisConvention> AverageOisConventionPtr;
typedef boost::shared_ptr<ore::data::TenorBasisSwapConvention> TenorBasisSwapConventionPtr;
typedef boost::shared_ptr<ore::data::TenorBasisTwoSwapConvention> TenorBasisTwoSwapConventionPtr;
typedef boost::shared_ptr<ore::data::BMABasisSwapConvention> BMABasisSwapConventionPtr;
typedef boost::shared_ptr<ore::data::FXConvention> FXConventionPtr;
typedef boost::shared_ptr<ore::data::CrossCcyBasisSwapConvention> CrossCcyBasisSwapConventionPtr;
typedef boost::shared_ptr<ore::data::CrossCcyFixFloatSwapConvention> CrossCcyFixFloatSwapConventionPtr;
typedef boost::shared_ptr<ore::data::CdsConvention> CdsConventionPtr;
typedef boost::shared_ptr<ore::data::InflationSwapConvention> InflationSwapConventionPtr;
typedef boost::shared_ptr<ore::data::SecuritySpreadConvention> SecuritySpreadConventionPtr;

using QuantLib::DayCounter;
using QuantLib::Calendar;
using QuantLib::Compounding;
using QuantLib::Frequency;
using QuantLib::Period;
using QuantLib::Natural;
using QuantLib::BusinessDayConvention;
using QuantLib::Size;
using QuantLib::DateGeneration;
using QuantExt::SubPeriodsCoupon;
%}

class Conventions {
  public:
    Conventions();
    boost::shared_ptr<Convention> get(const std::string& id) const;
    void clear();
    void add(const boost::shared_ptr<Convention>& convention);
    void fromXMLString(const std::string& xmlString);
};

%ignore Convention;
class Convention {
  public:
    const std::string& id() const;
    Convention::Type type() const;
    void fromXMLString(const std::string& xmlString);
    std::string toXMLString();
    
    enum class Type {
        Zero,
        Deposit,
        Future,
        FRA,
        OIS,
        Swap,
        AverageOIS,
        TenorBasisSwap,
        TenorBasisTwoSwap,
        BMABasisSwap,
        FX,
        CrossCcyBasis,
        CrossCcyFixFloat,
        CDS,
        SwapIndex,
        InflationSwap,
        SecuritySpread
    };
};
%template(Convention) boost::shared_ptr<Convention>;
%extend boost::shared_ptr<Convention> {
    static const Convention::Type Zero = Convention::Type::Zero;
    static const Convention::Type Deposit = Convention::Type::Deposit;
    static const Convention::Type Future = Convention::Type::Future;
    static const Convention::Type FRA = Convention::Type::FRA;
    static const Convention::Type OIS = Convention::Type::OIS;
    static const Convention::Type Swap = Convention::Type::Swap;
    static const Convention::Type AverageOis = Convention::Type::AverageOIS;
    static const Convention::Type TenorBasisSwap = Convention::Type::TenorBasisSwap;
    static const Convention::Type TenorBasisTwoSwap = Convention::Type::TenorBasisTwoSwap;
    static const Convention::Type BMABasisSwap = Convention::Type::BMABasisSwap;
    static const Convention::Type FX = Convention::Type::FX;
    static const Convention::Type CrossCcyBasis = Convention::Type::CrossCcyBasis;
    static const Convention::Type CrossCcyFixFloat = Convention::Type::CrossCcyFixFloat;
    static const Convention::Type CDS = Convention::Type::CDS;
    static const Convention::Type SwapIndex = Convention::Type::SwapIndex;
    static const Convention::Type InflationSwap = Convention::Type::InflationSwap;
    static const Convention::Type SecuritySpread = Convention::Type::SecuritySpread;
    
	Convention::Type conventionType() { 
		return boost::dynamic_pointer_cast<Convention>(*self)->type(); 
	}
}

%rename(ZeroRateConvention) ZeroRateConventionPtr;
class ZeroRateConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    ZeroRateConventionPtr() {
        return new ZeroRateConventionPtr(new ore::data::ZeroRateConvention());
    }
    ZeroRateConventionPtr(const std::string& id, const std::string& dayCounter, 
        const std::string& tenorCalendar, const std::string& compounding = "Continuous", 
        const std::string& compoundingFrequency = "Annual", const std::string& spotLag = "", 
        const std::string& spotCalendar = "", const std::string& rollConvention = "",
        const std::string& eom = "") {
        
        return new ZeroRateConventionPtr(new ore::data::ZeroRateConvention(id, dayCounter, 
            tenorCalendar, compounding, compoundingFrequency, spotLag, spotCalendar, 
            rollConvention, eom));
    }
    
    const DayCounter& dayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->dayCounter();
    }
    const Calendar& tenorCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->tenorCalendar();
    }
    Compounding compounding() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->compounding();
    }
    Frequency compoundingFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->compoundingFrequency();
    }
    Natural spotLag() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->spotLag();
    }
    const Calendar& spotCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->spotCalendar();
    }
    BusinessDayConvention rollConvention() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->rollConvention();
    }
    bool eom() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->eom();
    }
    bool tenorBased() const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(*self)->tenorBased();
    }
    
    static const ZeroRateConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::ZeroRateConvention>(baseInput);
    }
  }
};

%rename(DepositConvention) DepositConventionPtr;
class DepositConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    DepositConventionPtr() {
        return new DepositConventionPtr(new ore::data::DepositConvention());
    }
    DepositConventionPtr(const std::string& id, const std::string& index) {
        return new DepositConventionPtr(new ore::data::DepositConvention(id, index));
    }
    DepositConventionPtr(const std::string& id, const std::string& calendar, 
        const std::string& convention, const std::string& eom, const std::string& dayCounter, 
        const std::string& settlementDays) {
        
        return new DepositConventionPtr(new ore::data::DepositConvention(id, calendar, 
            convention, eom, dayCounter, settlementDays));
    }
    
    const std::string& index() const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->index();
    }
    const Calendar& calendar() const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->calendar();
    }
    BusinessDayConvention convention() const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->convention();
    }
    bool eom() {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->eom();
    }
    const DayCounter& dayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->dayCounter();
    }
    const Size settlementDays() const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->settlementDays();
    }
    bool indexBased() {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(*self)->indexBased();
    }
   
    static const DepositConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::DepositConvention>(baseInput);
    }
  }
};

%rename(FutureConvention) FutureConventionPtr;
class FutureConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    FutureConventionPtr() {
        return new FutureConventionPtr(new ore::data::FutureConvention());
    }
    FutureConventionPtr(const std::string& id, const std::string& index) {
        return new FutureConventionPtr(new ore::data::FutureConvention(id, index));
    }
    const IborIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::FutureConvention>(*self)->index();
    }
    
    static const FutureConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::FutureConvention>(baseInput);
    }
  }
};

%rename(FraConvention) FraConventionPtr;
class FraConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    FraConventionPtr() {
        return new FraConventionPtr(new ore::data::FraConvention());
    }
    FraConventionPtr(const std::string& id,const std::string& index) {
        return new FraConventionPtr(new ore::data::FraConvention(id, index));
    }
    const IborIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::FraConvention>(*self)->index();
    }
    static const FraConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::FraConvention>(baseInput);
    }
  }
};

%rename(OisConvention) OisConventionPtr;
class OisConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    OisConventionPtr() {
        return new OisConventionPtr(new ore::data::OisConvention());
    }
    OisConventionPtr(const std::string& id,const std::string& spotLag, const std::string& index,
        const std::string& fixedDayCounter = "", const std::string& paymentLag = "", 
        const std::string& eom = "", const std::string& fixedFrequency = "", 
        const std::string& fixedConvention = "", const std::string& fixedPaymentConvention = "", 
        const std::string& rule = "") {
        
        return new OisConventionPtr(new ore::data::OisConvention(id, spotLag, index, fixedDayCounter,
            paymentLag, eom, fixedFrequency, fixedConvention, fixedPaymentConvention, rule));
    }
    Natural spotLag() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->spotLag();
    }
    const std::string& indexName() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->indexName();
    }
    const OvernightIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->index();
    }
    const DayCounter& fixedDayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->fixedDayCounter();
    }
    Natural paymentLag() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->paymentLag();
    }
    bool eom() {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->eom();
    }
    Frequency fixedFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->fixedFrequency();
    }
    BusinessDayConvention fixedConvention() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->fixedConvention();
    }
    BusinessDayConvention fixedPaymentConvention() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->fixedPaymentConvention();
    }
    DateGeneration::Rule rule() const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(*self)->rule();
    }
    static const OisConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::OisConvention>(baseInput);
    }
  }
};

%rename(SwapIndexConvention) SwapIndexConventionPtr;
class SwapIndexConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    SwapIndexConventionPtr() {
        return new SwapIndexConventionPtr(new ore::data::SwapIndexConvention());
    }
    SwapIndexConventionPtr(const std::string& id,const std::string& conventions) {      
        return new SwapIndexConventionPtr(new ore::data::SwapIndexConvention(id, conventions));
    }
    const std::string& conventions() const {
        return boost::dynamic_pointer_cast<ore::data::SwapIndexConvention>(*self)->conventions();
    }
    static const SwapIndexConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::SwapIndexConvention>(baseInput);
    }
  }
};

%rename(IRSwapConvention) IRSwapConventionPtr;
class IRSwapConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    IRSwapConventionPtr() {
        return new IRSwapConventionPtr(new ore::data::IRSwapConvention());
    }
    IRSwapConventionPtr(const std::string& id,const std::string& fixedCalendar, 
        const std::string& fixedFrequency, const std::string& fixedConvention, 
        const std::string& fixedDayCounter, const std::string& index, bool hasSubPeriod = false, 
        const std::string& floatFrequency = "", const std::string& subPeriodsCouponType = "") {
        
        return new IRSwapConventionPtr(new ore::data::IRSwapConvention(id, fixedCalendar, fixedFrequency, 
            fixedConvention, fixedDayCounter, index, hasSubPeriod, floatFrequency, subPeriodsCouponType));
    }
    const Calendar& fixedCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->fixedCalendar();
    }
    Frequency fixedFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->fixedFrequency();
    }
    BusinessDayConvention fixedConvention() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->fixedConvention();
    }
    const DayCounter& fixedDayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->fixedDayCounter();
    }
    const std::string& indexName() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->indexName();
    }
    const IborIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->index();
    }
    bool hasSubPeriod() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->hasSubPeriod();
    }
    Frequency floatFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->floatFrequency();
    }
    SubPeriodsCoupon::Type subPeriodsCouponType() const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(*self)->subPeriodsCouponType();
    }
    static const IRSwapConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::IRSwapConvention>(baseInput);
    }
  }
};

%rename(AverageOisConvention) AverageOisConventionPtr;
class AverageOisConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    AverageOisConventionPtr() {
        return new AverageOisConventionPtr(new ore::data::AverageOisConvention());
    }
    AverageOisConventionPtr(const std::string& id,const std::string& spotLag, const std::string& fixedTenor,
        const std::string& fixedDayCounter, const std::string& fixedCalendar, 
        const std::string& fixedConvention, const std::string& fixedPaymentConvention, 
        const std::string& index, const std::string& onTenor, const std::string& rateCutoff) {
        
        return new AverageOisConventionPtr(new ore::data::AverageOisConvention(id, spotLag, fixedTenor, 
            fixedDayCounter, fixedCalendar, fixedConvention, fixedPaymentConvention, index, onTenor, 
            rateCutoff));
    }
    Natural spotLag() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->spotLag();
    }
    const Period& fixedTenor() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->fixedTenor();
    }
    const DayCounter& fixedDayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->fixedDayCounter();
    }
    const Calendar& fixedCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->fixedCalendar();
    }
    BusinessDayConvention fixedConvention() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->fixedConvention();
    }
    BusinessDayConvention fixedPaymentConvention() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->fixedPaymentConvention();
    }
    const std::string& indexName() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->indexName();
    }
    const OvernightIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->index();
    }
    const Period& onTenor() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->onTenor();
    }
    Natural rateCutoff() const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(*self)->rateCutoff();
    }
    static const AverageOisConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::AverageOisConvention>(baseInput);
    }
  }
};

%rename(TenorBasisSwapConvention) TenorBasisSwapConventionPtr;
class TenorBasisSwapConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    TenorBasisSwapConventionPtr() {
        return new TenorBasisSwapConventionPtr(new ore::data::TenorBasisSwapConvention());
    }
    TenorBasisSwapConventionPtr(const std::string& id,const std::string& longIndex, 
        const std::string& shortIndex, const std::string& shortPayTenor = "", 
        const std::string& spreadOnShort = "", const std::string& includeSpread = "", 
        const std::string& subPeriodsCouponType = "") {
        
        return new TenorBasisSwapConventionPtr(new ore::data::TenorBasisSwapConvention(id, longIndex, 
            shortIndex, shortPayTenor, spreadOnShort, includeSpread, subPeriodsCouponType));
    }
    const IborIndexPtr longIndex() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->longIndex();
    }
    const IborIndexPtr shortIndex() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->shortIndex();
    }
    const std::string& longIndexName() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->longIndexName();
    }
    const std::string& shortIndexName() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->shortIndexName();
    }
    const Period& shortPayTenor() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->shortPayTenor();
    }
    bool spreadOnShort() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->spreadOnShort();
    }
    bool includeSpread() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->includeSpread();
    }
    SubPeriodsCoupon::Type subPeriodsCouponType() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(*self)->subPeriodsCouponType();
    }
    static const TenorBasisSwapConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisSwapConvention>(baseInput);
    }
  }
};

%rename(TenorBasisTwoSwapConvention) TenorBasisTwoSwapConventionPtr;
class TenorBasisTwoSwapConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    TenorBasisTwoSwapConventionPtr() {
        return new TenorBasisTwoSwapConventionPtr(new ore::data::TenorBasisTwoSwapConvention());
    }
    TenorBasisTwoSwapConventionPtr(const std::string& id, const std::string& calendar, 
        const std::string& longFixedFrequency, const std::string& longFixedConvention, 
        const std::string& longFixedDayCounter, const std::string& longIndex, 
        const std::string& shortFixedFrequency, const std::string& shortFixedConvention, 
        const std::string& shortFixedDayCounter, const std::string& shortIndex, 
        const std::string& longMinusShort = "") {
        
        return new TenorBasisTwoSwapConventionPtr(new ore::data::TenorBasisTwoSwapConvention(id, calendar, 
            longFixedFrequency, longFixedConvention, longFixedDayCounter, longIndex, shortFixedFrequency, 
            shortFixedConvention, shortFixedDayCounter, shortIndex, longMinusShort));
    }
    const Calendar& calendar() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->calendar();
    }
    Frequency longFixedFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->longFixedFrequency();
    }
    BusinessDayConvention longFixedConvention() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->longFixedConvention();
    }
    const DayCounter& longFixedDayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->longFixedDayCounter();
    }
    const IborIndexPtr longIndex() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->longIndex();
    }
    Frequency shortFixedFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->shortFixedFrequency();
    }
    BusinessDayConvention shortFixedConvention() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->shortFixedConvention();
    }
    const DayCounter& shortFixedDayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->shortFixedDayCounter();
    }
    const IborIndexPtr shortIndex() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->shortIndex();
    }
    bool longMinusShort() const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(*self)->longMinusShort();
    }
    static const TenorBasisTwoSwapConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::TenorBasisTwoSwapConvention>(baseInput);
    }
  }
};

%rename(FXConvention) FXConventionPtr;
class FXConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    FXConventionPtr() {
        return new FXConventionPtr(new ore::data::FXConvention());
    }
    FXConventionPtr(const std::string& id,const std::string& spotDays, 
        const std::string& sourceCurrency, const std::string& targetCurrency, 
        const std::string& pointsFactor, const std::string& advanceCalendar = "", 
        const std::string& spotRelative = "") {
        
        return new FXConventionPtr(new ore::data::FXConvention(id, spotDays, 
            sourceCurrency, targetCurrency, pointsFactor, advanceCalendar, spotRelative));
    }
    Natural spotDays() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->spotDays();
    }
    const Currency& sourceCurrency() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->sourceCurrency();
    }
    const Currency& targetCurrency() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->targetCurrency();
    }
    Real pointsFactor() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->pointsFactor();
    }
    const Calendar& advanceCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->advanceCalendar();
    }
    bool spotRelative() const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(*self)->spotRelative();
    }
    static const FXConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::FXConvention>(baseInput);
    }
  }
};

%rename(CrossCcyBasisSwapConvention) CrossCcyBasisSwapConventionPtr;
class CrossCcyBasisSwapConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    CrossCcyBasisSwapConventionPtr() {
        return new CrossCcyBasisSwapConventionPtr(new ore::data::CrossCcyBasisSwapConvention());
    }
    CrossCcyBasisSwapConventionPtr(const std::string& id,const std::string& strSettlementDays, 
        const std::string& strSettlementCalendar, const std::string& strRollConvention, 
        const std::string& flatIndex, const std::string& spreadIndex, 
        const std::string& strEom = "") {
        
        return new CrossCcyBasisSwapConventionPtr(new ore::data::CrossCcyBasisSwapConvention(
            id, strSettlementDays, strSettlementCalendar, strRollConvention, flatIndex, 
            spreadIndex, strEom));
    }
    Natural settlementDays() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->settlementDays();
    }
    const Calendar& settlementCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->settlementCalendar();
    }
    BusinessDayConvention rollConvention() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->rollConvention();
    }
    const IborIndexPtr flatIndex() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->flatIndex();
    }
    const IborIndexPtr spreadIndex() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->spreadIndex();
    }
    const std::string& flatIndexName() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->flatIndexName();
    }
    const std::string& spreadIndexName() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->spreadIndexName();
    }
    bool eom() const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(*self)->eom();
    }
    static const CrossCcyBasisSwapConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::CrossCcyBasisSwapConvention>(baseInput);
    }
  }
};

%rename(CdsConvention) CdsConventionPtr;
class CdsConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    CdsConventionPtr() {
        return new CdsConventionPtr(new ore::data::CdsConvention());
    }
    CdsConventionPtr(const std::string& id, const std::string& strSettlementDays, 
        const std::string& strCalendar, const std::string& strFrequency, 
        const std::string& strPaymentConvention, const std::string& strRule, 
        const std::string& dayCounter, const std::string& settlesAccrual, 
        const std::string& paysAtDefaultTime) {
        
        return new CdsConventionPtr(new ore::data::CdsConvention(id, strSettlementDays, 
            strCalendar, strFrequency, strPaymentConvention, strRule, dayCounter, 
            settlesAccrual, paysAtDefaultTime));
    }
    Natural settlementDays() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->settlementDays();
    }
    const Calendar& calendar() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->calendar();
    }
    Frequency frequency() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->frequency();
    }
    BusinessDayConvention paymentConvention() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->paymentConvention();
    }
    DateGeneration::Rule rule() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->rule();
    }
    const DayCounter& dayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->dayCounter();
    }
    bool settlesAccrual() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->settlesAccrual();
    }
    bool paysAtDefaultTime() const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(*self)->paysAtDefaultTime();
    }
    static const CdsConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::CdsConvention>(baseInput);
    }
  }
};

%rename(InflationSwapConvention) InflationSwapConventionPtr;
class InflationSwapConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    InflationSwapConventionPtr() {
        return new InflationSwapConventionPtr(new ore::data::InflationSwapConvention());
    }
    InflationSwapConventionPtr(const std::string& id,const std::string& strFixCalendar, 
        const std::string& strFixConvention, const std::string& strDayCounter, const std::string& strIndex, 
        const std::string& strInterpolated, const std::string& strObservationLag, 
        const std::string& strAdjustInfObsDates, const std::string& strInfCalendar, 
        const std::string& strInfConvention) {
        
        return new InflationSwapConventionPtr(new ore::data::InflationSwapConvention(id, strFixCalendar, 
            strFixConvention, strDayCounter, strIndex, strInterpolated, strObservationLag, 
            strAdjustInfObsDates, strInfCalendar, strInfConvention));
    }
    const Calendar& fixCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->fixCalendar();
    }
    BusinessDayConvention fixConvention() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->fixConvention();
    }
    const DayCounter& dayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->dayCounter();
    }
    const ZeroInflationIndexPtr index() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->index();
    }
    const std::string& indexName() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->indexName();
    }
    bool interpolated() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->interpolated();
    }
    Period observationLag() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->observationLag();
    }
    bool adjustInfObsDates() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->adjustInfObsDates();
    }
    const Calendar& infCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->infCalendar();
    }
    BusinessDayConvention infConvention() const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(*self)->infConvention();
    }
    static const InflationSwapConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::InflationSwapConvention>(baseInput);
    }
  }
};

%rename(SecuritySpreadConvention) SecuritySpreadConventionPtr;
class SecuritySpreadConventionPtr : public boost::shared_ptr<Convention> {
public:
  %extend {
    SecuritySpreadConventionPtr() {
        return new SecuritySpreadConventionPtr(new ore::data::SecuritySpreadConvention());
    }
    //SecuritySpreadConventionPtr(const std::string& id,const std::string& dayCounter, 
    //    const std::string& compounding, const std::string& compoundingFrequency) {
    //    
    //    return new SecuritySpreadConventionPtr(new ore::data::SecuritySpreadConvention(
    //       id, dayCounter, tenorCalendar, compounding, compoundingFrequency, spotLag, spotCalendar,
    //        rollConvention, eom));
    //}
    SecuritySpreadConventionPtr(const std::string& id,const std::string& dayCounter, 
        const std::string& tenorCalendar, const std::string& compounding = "Continuous",
        const std::string& compoundingFrequency = "Annual", const std::string& spotLag = "",
        const std::string& spotCalendar = "", const std::string& rollConvention = "", 
        const std::string& eom = "") {
        
        return new SecuritySpreadConventionPtr(new ore::data::SecuritySpreadConvention(
            id, dayCounter, tenorCalendar, compounding, compoundingFrequency, spotLag, spotCalendar,
            rollConvention, eom));
    }
    
    const DayCounter& dayCounter() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->dayCounter();
    }
    const Calendar& tenorCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->tenorCalendar();
    }
    Compounding compounding() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->compounding();
    }
    Frequency compoundingFrequency() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->compoundingFrequency();
    }
    Natural spotLag() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->spotLag();
    }
    const Calendar& spotCalendar() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->spotCalendar();
    }
    BusinessDayConvention rollConvention() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->rollConvention();
    }
    bool eom() const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(*self)->eom();
    }
    static const SecuritySpreadConventionPtr getFullView(boost::shared_ptr<Convention> baseInput) const {
        return boost::dynamic_pointer_cast<ore::data::SecuritySpreadConvention>(baseInput);
    }
  }
};

#endif