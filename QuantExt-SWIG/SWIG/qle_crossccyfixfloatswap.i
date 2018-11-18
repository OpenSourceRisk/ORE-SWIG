/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_crossccyfixfloatswap_i
#define qle_crossccyfixfloatswap_i

%include instruments.i
%include scheduler.i
%include indexes.i

%{
using QuantExt::CrossCcyFixFloatSwap;
typedef boost::shared_ptr<Instrument> CrossCcyFixFloatSwapPtr;
%}

%ignore CrossCcyFixFloatSwap;
class CrossCcyFixFloatSwap {
  public:
    enum Type { Receiver = -1, Payer = 1 };
};

%rename(CrossCcyFixFloatSwap) CrossCcyFixFloatSwapPtr;
class CrossCcyFixFloatSwapPtr : public boost::shared_ptr<Instrument> {
  public:
    %extend {
        static const CrossCcyFixFloatSwap::Type Receiver = CrossCcyFixFloatSwap::Receiver;
        static const CrossCcyFixFloatSwap::Type Payer = CrossCcyFixFloatSwap::Payer;
        CrossCcyFixFloatSwapPtr(CrossCcyFixFloatSwap::Type type, 
                                QuantLib::Real fixedNominal,
                                const QuantLib::Currency& fixedCurrency,
                                const QuantLib::Schedule& fixedSchedule,
                                QuantLib::Rate fixedRate,
                                const QuantLib::DayCounter& fixedDayCount,
                                QuantLib::BusinessDayConvention fixedPaymentBdc,
                                QuantLib::Natural fixedPaymentLag,
                                const QuantLib::Calendar& fixedPaymentCalendar,
                                QuantLib::Real floatNominal,
                                const QuantLib::Currency& floatCurrency,
                                const QuantLib::Schedule& floatSchedule,
                                const IborIndexPtr& floatIndex,
                                QuantLib::Spread floatSpread,
                                QuantLib::BusinessDayConvention floatPaymentBdc,
                                QuantLib::Natural floatPaymentLag,
                                const QuantLib::Calendar& floatPaymentCalendar) {
            boost::shared_ptr<IborIndex> flIndex = boost::dynamic_pointer_cast<IborIndex>(floatIndex);
            return new CrossCcyFixFloatSwapPtr(
                new CrossCcyFixFloatSwap(type,
                                         fixedNominal,
                                         fixedCurrency,
                                         fixedSchedule,
                                         fixedRate,
                                         fixedDayCount,
                                         fixedPaymentBdc,
                                         fixedPaymentLag,
                                         fixedPaymentCalendar,
                                         floatNominal,
                                         floatCurrency,
                                         floatSchedule,
                                         flIndex,
                                         floatSpread,
                                         floatPaymentBdc,
                                         floatPaymentLag,
                                         floatPaymentCalendar));
        }
        CrossCcyFixFloatSwap::Type type() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->type();
        }
        QuantLib::Real fixedNominal() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedNominal();
        }
        const QuantLib::Currency& fixedCurrency() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedCurrency();
        }
        const QuantLib::Schedule& fixedSchedule() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedSchedule();
        }
        QuantLib::Rate fixedRate() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedRate();
        }
        const QuantLib::DayCounter& fixedDayCount() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedDayCount();
        }
        QuantLib::BusinessDayConvention fixedPaymentBdc() {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedPaymentBdc();
        }
        QuantLib::Natural fixedPaymentLag() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedPaymentLag();
        }
        const QuantLib::Calendar& fixedPaymentCalendar() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fixedPaymentCalendar();
        }
        QuantLib::Real floatNominal() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatNominal();
        }
        const QuantLib::Currency& floatCurrency() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatCurrency();
        }
        const QuantLib::Schedule& floatSchedule() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatSchedule();
        }
        QuantLib::Rate floatSpread() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatSpread();
        }
        QuantLib::BusinessDayConvention floatPaymentBdc() {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatPaymentBdc();
        }
        QuantLib::Natural floatPaymentLag() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatPaymentLag();
        }
        const QuantLib::Calendar& floatPaymentCalendar() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->floatPaymentCalendar();
        }
        QuantLib::Rate fairFixedRate() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fairFixedRate();
        }
        QuantLib::Spread fairSpread() const {
            return boost::dynamic_pointer_cast<CrossCcyFixFloatSwap>(*self)->fairSpread();
        }
    }
};

#endif
