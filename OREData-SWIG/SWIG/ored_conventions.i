
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_conventions_i
#define qored_conventions_i

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


typedef boost::shared_ptr<ore::data::ZeroRateConvention> ZeroRateConventionPtr;
typedef boost::shared_ptr<ore::data::DepositConvention> DepositConventionPtr;
typedef boost::shared_ptr<ore::data::FutureConvention> FutureConventionPtr;
typedef boost::shared_ptr<ore::data::FraConvention> FraConventiontr;
typedef boost::shared_ptr<ore::data::OisConvention> OisConventionPtr;
typedef boost::shared_ptr<ore::data::SwapIndexConvention> DSwapIndexConventionPtr;
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

using QuantLib::DayCounter;
using QuantLib::Calendar;
using QuantLib::Compounding;
using QuantLib::Frequency;
using QuantLib::Natural;
using QuantLib::BusinessDayConvention;
using QuantLib::Size;
%}

class Conventions {
  public:
    Conventions();
    boost::shared_ptr<Convention> get(const std::string& id) const;
    void clear();
    void add(const boost::shared_ptr<Convention>& convention);
    void loadFromXMLString(const std::string& xmlString);
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
    static const Convention::Type AverageOIS = Convention::Type::AverageOIS;
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
  }
};


#endif