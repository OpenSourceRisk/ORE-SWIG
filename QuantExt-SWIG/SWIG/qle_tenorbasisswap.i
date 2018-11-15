/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_tenorbasisswap_i
#define qle_tenorbasisswap_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i

%include qle_termstructures.i

%{
using QuantExt::TenorBasisSwap;
using QuantExt::SubPeriodsCoupon;
using QuantExt::SubPeriodsCouponPricer;
using QuantExt::SubPeriodsSwap;

typedef boost::shared_ptr<Instrument> TenorBasisSwapPtr;
typedef boost::shared_ptr<CashFlow> SubPeriodsCouponPtr;
typedef boost::shared_ptr<CashFlow> SubPeriodsCouponPricerPtr;
typedef boost::shared_ptr<Instrument> SubPeriodsSwapPtr;
%}

%ignore SubPeriodsCoupon;
class SubPeriodsCoupon {
  public:
    enum Type { Averaging, Compounding };
};

%rename(SubPeriodsCoupon) SubPeriodsCouponPtr;
class SubPeriodsCouponPtr : public FloatingRateCouponPtr {
  public:
    %extend {
        static const SubPeriodsCoupon::Type Averaging = SubPeriodsCoupon::Averaging;
        static const SubPeriodsCoupon::Type Compounding = SubPeriodsCoupon::Compounding;
        SubPeriodsCouponPtr(const QuantLib::Date& paymentDate, 
                            QuantLib::Real nominal,
                            const QuantLib::Date& startDate, 
                            const QuantLib::Date& endDate,
                            const InterestRateIndexPtr& index,
                            SubPeriodsCoupon::Type type,
                            QuantLib::BusinessDayConvention convention,
                            QuantLib::Spread spread = 0.0,
                            const QuantLib::DayCounter& dayCounter = QuantLib::DayCounter(),
                            bool includeSpread = false,
                            QuantLib::Real gearing = 1.0) {
            boost::shared_ptr<InterestRateIndex> interestIndex = boost::dynamic_pointer_cast<InterestRateIndex>(index);
            return new SubPeriodsCouponPtr(
                new SubPeriodsCoupon(paymentDate,
                                     nominal,
                                     startDate,
                                     endDate,
                                     interestIndex,
                                     type,
                                     convention,
                                     spread,
                                     dayCounter,
                                     includeSpread,
                                     gearing));
        }
        const std::vector<QuantLib::Date>& fixingDates() const { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->fixingDates(); 
        }
        const std::vector<QuantLib::Time>& accrualFractions() const { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->accrualFractions(); 
        }
        const std::vector<QuantLib::Rate>& indexFixings() const { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->indexFixings(); 
        }
        const std::vector<QuantLib::Date>& valueDates() const { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->valueDates(); 
        }
        bool includeSpread() const { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->includeSpread(); 
        }
        QuantLib::Spread spread() { 
            return boost::dynamic_pointer_cast<SubPeriodsCoupon>(*self)->spread(); 
        }
    }
};

%rename(SubPeriodsCouponPricer) SubPeriodsCouponPricerPtr;
class SubPeriodsCouponPricerPtr : public FloatingRateCouponPricerPtr {
  private:
    SubPeriodsCouponPricerPtr();
  public:
    %extend {
        QuantLib::Rate swapletRate() const {
            return boost::dynamic_pointer_cast<SubPeriodsCouponPricer>(*self)->swapletRate();
        }
    }
};

%rename(TenorBasisSwap) TenorBasisSwapPtr;
class TenorBasisSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        TenorBasisSwapPtr(const QuantLib::Date& effectiveDate,
                          QuantLib::Real nominal,
                          const QuantLib::Period& swapTenor,
                          bool payLongIndex,
                          const IborIndexPtr& longIndex,
                          QuantLib::Spread longSpread,
                          const IborIndexPtr& shortIndex,
                          QuantLib::Spread shortSpread,
                          const QuantLib::Period& shortPayTenor,
                          QuantLib::DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
                          bool includeSpread = false,
                          SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
            boost::shared_ptr<IborIndex> lIndex = boost::dynamic_pointer_cast<IborIndex>(longIndex);
            boost::shared_ptr<IborIndex> sIndex = boost::dynamic_pointer_cast<IborIndex>(shortIndex);
            return new TenorBasisSwapPtr(
                new TenorBasisSwap(effectiveDate,
                                   nominal,
                                   swapTenor,
                                   payLongIndex,
                                   lIndex,
                                   longSpread,
                                   sIndex,
                                   shortSpread,
                                   shortPayTenor,
                                   rule,
                                   includeSpread, 
                                   type));
        }
        TenorBasisSwapPtr(QuantLib::Real nominal,
                          bool payLongIndex,
                          const QuantLib::Schedule& longSchedule,
                          const IborIndexPtr& longIndex,
                          QuantLib::Spread longSpread,
                          const QuantLib::Schedule& shortSchedule,
                          const IborIndexPtr& shortIndex,
                          QuantLib::Spread shortSpread,
                          bool includeSpread = false,
                          SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
            boost::shared_ptr<IborIndex> lIndex = boost::dynamic_pointer_cast<IborIndex>(longIndex);
            boost::shared_ptr<IborIndex> sIndex = boost::dynamic_pointer_cast<IborIndex>(shortIndex);
            return new TenorBasisSwapPtr(
                new TenorBasisSwap(nominal,
                                   payLongIndex,
                                   longSchedule,
                                   lIndex,
                                   longSpread,
                                   shortSchedule,
                                   sIndex,
                                   shortSpread,
                                   includeSpread,
                                   type));
        }
        QuantLib::Real nominal() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->nominal(); 
        }
        bool payLongIndex() { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->payLongIndex(); 
        }
        const QuantLib::Schedule& longSchedule() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->longSchedule(); 
        }
        QuantLib::Spread longSpread() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->longSpread(); 
        }
        const QuantLib::Leg& longLeg() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->longLeg(); 
        }
        const QuantLib::Schedule& shortSchedule() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortSchedule(); 
        }
        QuantLib::Spread shortSpread() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortSpread(); 
        }
        const QuantLib::Leg& shortLeg() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortLeg(); 
        }
        SubPeriodsCoupon::Type type() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->type(); 
        }
        const QuantLib::Period& shortPayTenor() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortPayTenor(); 
        }
        bool includeSpread() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->includeSpread(); 
        }
        QuantLib::Real longLegBPS() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->longLegBPS(); 
        }
        QuantLib::Real longLegNPV() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->longLegNPV(); 
        }
        QuantLib::Rate fairLongLegSpread() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->fairLongLegSpread(); 
        }
        QuantLib::Real shortLegBPS() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortLegBPS(); 
        }
        QuantLib::Real shortLegNPV() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->shortLegNPV(); 
        }
        QuantLib::Rate fairShortLegSpread() const { 
            return boost::dynamic_pointer_cast<TenorBasisSwap>(*self)->fairShortLegSpread(); 
        }
    }
};

%rename(SubPeriodsSwap) SubPeriodsSwapPtr;
class SubPeriodsSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        SubPeriodsSwapPtr(const QuantLib::Date& effectiveDate,
                          QuantLib::Real nominal,
                          const QuantLib::Period& swapTenor,
                          bool isPayer,
                          const QuantLib::Period& fixedTenor,
                          QuantLib::Rate fixedRate,
                          const QuantLib::Calendar& fixedCalendar,
                          const QuantLib::DayCounter& fixedDayCount,
                          QuantLib::BusinessDayConvention fixedConvention,
                          const QuantLib::Period& floatPayTenor,
                          const IborIndexPtr& iborIndex,
                          const QuantLib::DayCounter& floatingDayCount,
                          QuantLib::DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
                          SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
            boost::shared_ptr<IborIndex> floatIndex = boost::dynamic_pointer_cast<IborIndex>(iborIndex);
            return new SubPeriodsSwapPtr(
                new SubPeriodsSwap(effectiveDate,
                                   nominal,
                                   swapTenor,
                                   isPayer,
                                   fixedTenor,
                                   fixedRate,
                                   fixedCalendar,
                                   fixedDayCount,
                                   fixedConvention,
                                   floatPayTenor,
                                   floatIndex,
                                   floatingDayCount,
                                   rule,
                                   type));
        }
        QuantLib::Real nominal() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->nominal(); 
        }
        bool isPayer() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->isPayer(); 
        }
        const QuantLib::Schedule& fixedSchedule() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fixedSchedule(); 
        }
        QuantLib::Rate fixedRate() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fixedRate(); 
        }
        const QuantLib::Leg& fixedLeg() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fixedLeg(); 
        }
        const QuantLib::Schedule& floatSchedule() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->floatSchedule(); 
        }
        SubPeriodsCoupon::Type type() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->type(); 
        }
        const QuantLib::Period& floatPayTenor() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->floatPayTenor(); 
        }
        const QuantLib::Leg& floatLeg() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->floatLeg(); 
        }
        QuantLib::Real fairRate() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fairRate(); 
        }
        QuantLib::Real fixedLegBPS() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fixedLegBPS(); 
        }
        QuantLib::Real fixedLegNPV() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->fixedLegNPV(); 
        }
        QuantLib::Real floatLegBPS() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->floatLegBPS(); 
        }
        QuantLib::Real floatLegNPV() const { 
            return boost::dynamic_pointer_cast<SubPeriodsSwap>(*self)->floatLegNPV(); 
        }
    }
};


#endif
