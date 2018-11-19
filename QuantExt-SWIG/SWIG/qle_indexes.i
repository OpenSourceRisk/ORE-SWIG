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

typedef boost::shared_ptr<Index> FxIndexPtr;
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


#endif
