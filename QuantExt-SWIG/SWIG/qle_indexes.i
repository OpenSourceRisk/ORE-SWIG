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

#ifndef qle_indexes_i
#define qle_indexes_i

%include instruments.i
%include termstructures.i
%include cashflows.i
%include timebasket.i
%include indexes.i
%include date.i
%include calendars.i
%include daycounters.i
%include currencies.i

%{
using QuantExt::FxIndex;
using QuantExt::BMAIndexWrapper;
using QuantLib::BMAIndex;
using QuantExt::CommodityIndex;
using QuantExt::CommoditySpotIndex;
using QuantExt::CommodityFuturesIndex;
%}

%shared_ptr(FxIndex)
class FxIndex : public Index {
  public:
    FxIndex(const std::string& familyName,
            QuantLib::Natural fixingDays,
            const QuantLib::Currency& source,
            const QuantLib::Currency& target,
            const QuantLib::Calendar& fixingCalendar,
            const QuantLib::Handle<QuantLib::YieldTermStructure>& sourceYts
                = QuantLib::Handle<QuantLib::YieldTermStructure>(),
            const QuantLib::Handle<QuantLib::YieldTermStructure>& targetYts
                = QuantLib::Handle<QuantLib::YieldTermStructure>());
    FxIndex(const std::string& familyName,
            QuantLib::Natural fixingDays,
            const QuantLib::Currency& source,
            const QuantLib::Currency& target,
            const QuantLib::Calendar& fixingCalendar,
            const QuantLib::Handle<QuantLib::Quote> fxQuote,
            const QuantLib::Handle<QuantLib::YieldTermStructure>& sourceYts
                = QuantLib::Handle<QuantLib::YieldTermStructure>(),
            const QuantLib::Handle<QuantLib::YieldTermStructure>& targetYts
                = QuantLib::Handle<QuantLib::YieldTermStructure>());
    std::string familyName() const;
    QuantLib::Natural fixingDays() const;
    QuantLib::Date fixingDate(const QuantLib::Date& valueDate) const;
    const QuantLib::Currency& sourceCurrency() const;
    const QuantLib::Currency& targetCurrency() const;
    virtual QuantLib::Date valueDate(const QuantLib::Date& fixingDate) const;
    QuantLib::Real forecastFixing(const QuantLib::Date& fixingDate) const;
    QuantLib::Real pastFixing(const QuantLib::Date& fixingDate) const;
};

// QuantExt Commodity Index
%shared_ptr(CommodityIndex)
class CommodityIndex : public Index {
  private:
    CommodityIndex();
};

// QuantExt Commodity Spot Index
%shared_ptr(CommoditySpotIndex)
class CommoditySpotIndex : public CommodityIndex {
  public:
    CommoditySpotIndex(const std::string& underlyingName, const Calendar& fixingCalendar,
                   const Handle<QuantExt::PriceTermStructure>& priceCurve = Handle<QuantExt::PriceTermStructure>());
    ext::shared_ptr<CommodityIndex> clone(const QuantLib::Date& expiryDate = QuantLib::Date(),
                                          const boost::optional<QuantLib::Handle<PriceTermStructure>>& ts = boost::none) const;
};

// QuantExt Commodity Futures Index
%shared_ptr(CommodityFuturesIndex)
class CommodityFuturesIndex : public CommodityIndex {
public:
    CommodityFuturesIndex(
        const std::string& underlyingName, const Date& expiryDate, const Calendar& fixingCalendar,
        const Handle<QuantExt::PriceTermStructure>& priceCurve = Handle<QuantExt::PriceTermStructure>());

    CommodityFuturesIndex(
        const std::string& underlyingName, const Date& expiryDate, const Calendar& fixingCalendar, bool keepDays,
        const Handle<QuantExt::PriceTermStructure>& priceCurve = Handle<QuantExt::PriceTermStructure>());

    ext::shared_ptr<CommodityIndex> clone(const QuantLib::Date& expiryDate = QuantLib::Date(),
        const boost::optional<QuantLib::Handle<PriceTermStructure>>& ts = boost::none) const;
};

// QuantLib BMA Index (not yet wrapped in QL v1.14)
%shared_ptr(BMAIndex)
class BMAIndex : public InterestRateIndex {
  public:
    BMAIndex(const QuantLib::Handle<QuantLib::YieldTermStructure>& h =
        QuantLib::Handle<QuantLib::YieldTermStructure>());
    std::string name() const;
    bool isValidFixingDate(const Date& fixingDate) const;
    QuantLib::Handle<QuantLib::YieldTermStructure> forwardingTermStructure() const;
    QuantLib::Date maturityDate(const Date& valueDate) const;
    QuantLib::Schedule fixingSchedule(const QuantLib::Date& start, const QuantLib::Date& end);
};

%shared_ptr(BMAIndexWrapper)
class BMAIndexWrapper : public IborIndex {
  public:
    BMAIndexWrapper(const boost::shared_ptr<BMAIndex> bma);
    std::string name() const;
    bool isValidFixingDate(const Date& fixingDate) const;
    QuantLib::Handle<QuantLib::YieldTermStructure> forwardingTermStructure() const;
    QuantLib::Date maturityDate(const Date& valueDate) const;
    QuantLib::Schedule fixingSchedule(const QuantLib::Date& start, const QuantLib::Date& end);
    boost::shared_ptr<BMAIndex> bma() const;
};


%define qle_export_xibor_instance(Name)
%{
using QuantExt::Name;
%}
%shared_ptr(Name)
class Name : public IborIndex {
  public:
    Name(const Period& tenor,
         const Handle<YieldTermStructure>& h =
                                Handle<YieldTermStructure>()) {
        return new Name(new Name(tenor,h));
    }
};
%enddef

%define qle_export_overnight_instance(Name)
%{
using QuantExt::Name;
%}
%shared_ptr(Name)
class Name : public OvernightIndex {
  public:
    Name(const Handle<YieldTermStructure>& h =
                                Handle<YieldTermStructure>()) {
        return new Name(new Name(h));
    }
};
%enddef

qle_export_xibor_instance(AUDbbsw);
qle_export_xibor_instance(CZKPribor);
qle_export_xibor_instance(DEMLibor);
qle_export_xibor_instance(DKKCibor);
qle_export_xibor_instance(HKDHibor);
qle_export_xibor_instance(HUFBubor);
qle_export_xibor_instance(IDRIdrfix);
qle_export_xibor_instance(INRMifor);
qle_export_xibor_instance(KRWKoribor);
qle_export_xibor_instance(MXNTiie);
qle_export_xibor_instance(MYRKlibor);
qle_export_xibor_instance(NOKNibor);
qle_export_xibor_instance(NZDBKBM);
qle_export_xibor_instance(PHPPhiref);
qle_export_xibor_instance(PLNWibor);
qle_export_xibor_instance(RUBMosprime);
qle_export_xibor_instance(SEKStibor);
qle_export_xibor_instance(SGDSibor);
qle_export_xibor_instance(SGDSor);
qle_export_xibor_instance(SKKBribor);
qle_export_xibor_instance(THBBibor);
qle_export_xibor_instance(TWDTaibor);

qle_export_overnight_instance(BRLCdi);
qle_export_overnight_instance(CHFTois);
qle_export_overnight_instance(CLPCamara);
qle_export_overnight_instance(COPIbr);
qle_export_overnight_instance(CORRA);
qle_export_overnight_instance(DKKOis);
qle_export_overnight_instance(SEKSior);
qle_export_overnight_instance(Tonar);

#endif
