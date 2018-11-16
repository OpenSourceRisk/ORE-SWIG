/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_cashflows_i
#define qle_cashflows_i

%include date.i
%include types.i
%include calendars.i
%include daycounters.i
%include indexes.i
%include termstructures.i
%include scheduler.i
%include vectors.i
%include cashflows.i
%include qle_indexes.i

%{
using QuantExt::FXLinkedCashFlow;

typedef boost::shared_ptr<CashFlow> FXLinkedCashFlowPtr;
%}

%rename(FXLinkedCashFlow) FXLinkedCashFlowPtr;
class FXLinkedCashFlowPtr : public boost::shared_ptr<CashFlow> {
public:
    %extend{
        FXLinkedCashFlowPtr(const QuantLib::Date& cashFlowDate, 
                            const QuantLib::Date& fixingDate, 
                            QuantLib::Real foreignAmount,
                            FxIndexPtr fxIndex, 
                            bool invertIndex = false) {
            boost::shared_ptr<FxIndex> FXIndex = boost::dynamic_pointer_cast<FxIndex>(fxIndex);
            return new FXLinkedCashFlowPtr(
                new FXLinkedCashFlow(cashFlowDate,
                                     fixingDate,
                                     foreignAmount,
                                     FXIndex,
                                     invertIndex));
        }
        QuantLib::Date fxFixingDate() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->fxFixingDate();
        }
        const FxIndexPtr index() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->index();
        }
        bool invertIndex() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->invertIndex();
        }
        QuantLib::Real fxRate() const {
            return boost::dynamic_pointer_cast<FXLinkedCashFlow>(*self)->fxRate();
        }
    }
};

#endif
