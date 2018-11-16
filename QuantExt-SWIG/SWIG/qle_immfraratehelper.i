/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_immfraratehelper.i
#define qle_immfraratehelper.i

%include ratehelpers.i
%include qle_instruments.i

%{
using QuantExt::ImmFraRateHelper;
typedef boost::shared_ptr<RateHelper> ImmFraRateHelperPtr;
%}

%rename(ImmFraRateHelper) ImmFraRateHelperPtr;
class ImmFraRateHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    ImmFraRateHelperPtr(const QuantLib::Handle<QuantLib::Quote>& rate,
					    const QuantLib::Size imm1,
					    const QuantLib::Size imm2,
					    const IborIndexPtr& iborIndex,
					    QuantLib::Pillar::Choice pillar = QuantLib::Pillar::LastRelevantDate,
					    QuantLib::Date customPillarDate = QuantLib::Date()) {
				  boost::shared_ptr<IborIndex> ibrIndex = boost::dynamic_pointer_cast<IborIndex>(iborIndex);
			return new ImmFraRateHelperPtr(new ImmFraRateHelper(rate,
																imm1,
																imm2,
																ibrIndex,
																pillar,
																customPillarDate));
    }
	QuantLib::Real impliedQuote() const {
      return boost::dynamic_pointer_cast<ImmFraRateHelper>(*self)->impliedQuote();
    }
  }
};

#endif
