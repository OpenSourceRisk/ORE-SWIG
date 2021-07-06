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
//using QuantExt::SubPeriodsCoupon;
//using QuantExt::SubPeriodsCouponPricer;
using QuantExt::SubPeriodsSwap;
%}

// SubPeriodsCoupon is exported in QuantLib-SWIG now, so we have commmented out the following.
// TODO: Merge QuantExt's SubPeriodsCoupon into QuantLib's
/*
%shared_ptr(SubPeriodsCoupon)
class SubPeriodsCoupon : public FloatingRateCoupon {
  public:
    enum Type { Averaging, Compounding };
    SubPeriodsCoupon(const QuantLib::Date& paymentDate,
                     QuantLib::Real nominal,
                     const QuantLib::Date& startDate,
                     const QuantLib::Date& endDate,
                     const boost::shared_ptr<InterestRateIndex>& index,
                     QuantExt::SubPeriodsCoupon::Type type,
                     QuantLib::BusinessDayConvention convention,
                     QuantLib::Spread spread = 0.0,
                     const QuantLib::DayCounter& dayCounter = QuantLib::DayCounter(),
                     bool includeSpread = false,
                     QuantLib::Real gearing = 1.0);
    const std::vector<QuantLib::Date>& fixingDates() const;
    const std::vector<QuantLib::Time>& accrualFractions() const;
    const std::vector<QuantLib::Rate>& indexFixings() const;
    const std::vector<QuantLib::Date>& valueDates() const;
    bool includeSpread() const;
    QuantLib::Spread spread();
};

%shared_ptr(SubPeriodsCouponPricer)
    class SubPeriodsCouponPricer : public QuantLib::FloatingRateCouponPricer {
  private:
    SubPeriodsCouponPricer();
  public:
    QuantLib::Rate swapletRate() const;
};
*/

%shared_ptr(TenorBasisSwap)
class TenorBasisSwap : public Swap {
  public:
    TenorBasisSwap(const QuantLib::Date& effectiveDate,
                   QuantLib::Real nominal,
                   const QuantLib::Period& swapTenor,
                   bool payLongIndex,
                   const boost::shared_ptr<IborIndex>& longIndex,
                   QuantLib::Spread longSpread,
                   const boost::shared_ptr<IborIndex>& shortIndex,
                   QuantLib::Spread shortSpread,
                   const QuantLib::Period& shortPayTenor,
                   QuantLib::DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
                   bool includeSpread = false,
                   QuantExt::SubPeriodsCoupon::Type type = QuantExt::SubPeriodsCoupon::Compounding);
    TenorBasisSwap(QuantLib::Real nominal,
                   bool payLongIndex,
                   const QuantLib::Schedule& longSchedule,
                   const boost::shared_ptr<IborIndex>& longIndex,
                   QuantLib::Spread longSpread,
                   const QuantLib::Schedule& shortSchedule,
                   const boost::shared_ptr<IborIndex>& shortIndex,
                   QuantLib::Spread shortSpread,
                   bool includeSpread = false,
                   QuantExt::SubPeriodsCoupon::Type type = QuantExt::SubPeriodsCoupon::Compounding);
    QuantLib::Real nominal() const;
    bool payLongIndex();
    const QuantLib::Schedule& longSchedule() const;
    const boost::shared_ptr<IborIndex> longIndex() const;
    QuantLib::Spread longSpread() const;
    const QuantLib::Leg& longLeg() const;
    const QuantLib::Schedule& shortSchedule() const;
    const boost::shared_ptr<IborIndex> shortIndex() const;
    QuantLib::Spread shortSpread() const;
    const QuantLib::Leg& shortLeg() const;
    QuantExt::SubPeriodsCoupon::Type type() const;
    const QuantLib::Period& shortPayTenor() const;
    bool includeSpread() const;
    QuantLib::Real longLegBPS() const;
    QuantLib::Real longLegNPV() const;
    QuantLib::Rate fairLongLegSpread() const;
    QuantLib::Real shortLegBPS() const;
    QuantLib::Real shortLegNPV() const;
    QuantLib::Rate fairShortLegSpread() const;
};

%shared_ptr(SubPeriodsSwap)
class SubPeriodsSwap : public Swap {
  public:
    SubPeriodsSwap(const QuantLib::Date& effectiveDate,
                   QuantLib::Real nominal,
                   const QuantLib::Period& swapTenor,
                   bool isPayer,
                   const QuantLib::Period& fixedTenor,
                   QuantLib::Rate fixedRate,
                   const QuantLib::Calendar& fixedCalendar,
                   const QuantLib::DayCounter& fixedDayCount,
                   QuantLib::BusinessDayConvention fixedConvention,
                   const QuantLib::Period& floatPayTenor,
                   const boost::shared_ptr<IborIndex>& iborIndex,
                   const QuantLib::DayCounter& floatingDayCount,
                   QuantLib::DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
                   QuantExt::SubPeriodsCoupon::Type type = QuantExt::SubPeriodsCoupon::Compounding);
    QuantLib::Real nominal() const;
    bool isPayer() const;
    const QuantLib::Schedule& fixedSchedule() const;
    QuantLib::Rate fixedRate() const;
    const QuantLib::Leg& fixedLeg() const;
    const QuantLib::Schedule& floatSchedule() const;
    QuantExt::SubPeriodsCoupon::Type type() const;
    const QuantLib::Period& floatPayTenor() const;
    const QuantLib::Leg& floatLeg() const;
    QuantLib::Real fairRate() const;
    QuantLib::Real fixedLegBPS() const;
    QuantLib::Real fixedLegNPV() const;
    QuantLib::Real floatLegBPS() const;
    QuantLib::Real floatLegNPV() const;
};

#endif
