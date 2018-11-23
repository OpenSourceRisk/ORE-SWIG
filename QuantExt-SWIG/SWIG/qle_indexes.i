/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
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

typedef boost::shared_ptr<Index> FxIndexPtr;
typedef boost::shared_ptr<Index> BMAIndexWrapperPtr;

using QuantLib::BMAIndex;
typedef boost::shared_ptr<Index> BMAIndexPtr;
%}

%rename(FxIndex) FxIndexPtr;
class FxIndexPtr : public boost::shared_ptr<Index> {
  public:
    %extend {
        FxIndexPtr(const std::string& familyName, 
                   QuantLib::Natural fixingDays, 
                   const QuantLib::Currency& source, 
                   const QuantLib::Currency& target,
                   const QuantLib::Calendar& fixingCalendar, 
                   const QuantLib::Handle<QuantLib::YieldTermStructure>& sourceYts 
                        = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                   const QuantLib::Handle<QuantLib::YieldTermStructure>& targetYts 
                            = QuantLib::Handle<QuantLib::YieldTermStructure>()) {
            return new FxIndexPtr(
                new FxIndex(familyName,
                            fixingDays,
                            source,
                            target,
                            fixingCalendar,
                            sourceYts,
                            targetYts));
        }
        FxIndexPtr(const std::string& familyName, 
                   QuantLib::Natural fixingDays, 
                   const QuantLib::Currency& source, 
                   const QuantLib::Currency& target,
                   const QuantLib::Calendar& fixingCalendar, 
                   const QuantLib::Handle<QuantLib::Quote> fxQuote,
                   const QuantLib::Handle<QuantLib::YieldTermStructure>& sourceYts 
                        = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                   const QuantLib::Handle<QuantLib::YieldTermStructure>& targetYts 
                        = QuantLib::Handle<QuantLib::YieldTermStructure>()) {
            return new FxIndexPtr(
                new FxIndex(familyName,
                            fixingDays,
                            source,
                            target,
                            fixingCalendar,
                            fxQuote,
                            sourceYts,
                            targetYts));
        }
        std::string familyName() const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->familyName();
        }
        QuantLib::Natural fixingDays() const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->fixingDays();
        }
        QuantLib::Date fixingDate(const QuantLib::Date& valueDate) const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->fixingDate(valueDate);
        }
        const QuantLib::Currency& sourceCurrency() const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->sourceCurrency();
        }
        const QuantLib::Currency& targetCurrency() const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->targetCurrency();
        }
        virtual QuantLib::Date valueDate(const QuantLib::Date& fixingDate) const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->valueDate(fixingDate);
        }
        QuantLib::Real forecastFixing(const QuantLib::Date& fixingDate) const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->forecastFixing(fixingDate);
        }
        QuantLib::Real pastFixing(const QuantLib::Date& fixingDate) const {
            return boost::dynamic_pointer_cast<FxIndex>(*self)->pastFixing(fixingDate);
        }
    }
};

// QuantLib BMA Index (not yet wrapped in QL v1.14)
%rename(BMAIndex) BMAIndexPtr;
class BMAIndexPtr : public InterestRateIndexPtr {
  public:
    %extend {
        BMAIndexPtr(const QuantLib::Handle<QuantLib::YieldTermStructure>& h =
                                                QuantLib::Handle<QuantLib::YieldTermStructure>()) {
            return new BMAIndexPtr(new QuantLib::BMAIndex(h));
        }
        std::string name() const {
            return boost::dynamic_pointer_cast<BMAIndex>(*self)->name();
        }
        bool isValidFixingDate(const Date& fixingDate) const {
            return boost::dynamic_pointer_cast<BMAIndex>(*self)->isValidFixingDate(fixingDate);
        }
        QuantLib::Handle<QuantLib::YieldTermStructure> forwardingTermStructure() const {
            return boost::dynamic_pointer_cast<BMAIndex>(*self)->forwardingTermStructure();
        }
        QuantLib::Date maturityDate(const Date& valueDate) const {
            return boost::dynamic_pointer_cast<BMAIndex>(*self)->maturityDate(valueDate);
        }
        QuantLib::Schedule fixingSchedule(const QuantLib::Date& start, const QuantLib::Date& end) const {
            return boost::dynamic_pointer_cast<BMAIndex>(*self)->fixingSchedule(start, end);
        }
    }
};

%rename(BMAIndexWrapper) BMAIndexWrapperPtr;
class BMAIndexWrapperPtr : public IborIndexPtr {
  public:
    %extend {
        BMAIndexWrapperPtr(const BMAIndexPtr bma) {
            boost::shared_ptr<BMAIndex> bmaCast = boost::dynamic_pointer_cast<BMAIndex>(bma);
            return new BMAIndexWrapperPtr(new BMAIndexWrapper(bmaCast));
        }
        std::string name() const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->name();
        }
        bool isValidFixingDate(const Date& fixingDate) const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->isValidFixingDate(fixingDate);
        }
        QuantLib::Handle<QuantLib::YieldTermStructure> forwardingTermStructure() const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->forwardingTermStructure();
        }
        QuantLib::Date maturityDate(const Date& valueDate) const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->maturityDate(valueDate);
        }
        QuantLib::Schedule fixingSchedule(const QuantLib::Date& start, const QuantLib::Date& end) const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->fixingSchedule(start, end);
        }
        BMAIndexPtr bma() const {
            return boost::dynamic_pointer_cast<BMAIndexWrapper>(*self)->bma();
        }
    }
};


#endif
