/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_ratehelpers_i
#define qle_ratehelpers_i

%include ratehelpers.i
%include swap.i
%include qle_instruments.i
%include qle_tenorbasisswap.i
%include qle_oiccbasisswap.i

%{
using QuantExt::CrossCcyBasisSwapHelper;
using QuantExt::TenorBasisSwapHelper;
using QuantExt::SubPeriodsSwapHelper;
using QuantExt::OICCBSHelper;
using QuantExt::OIBSHelper;
using QuantExt::BasisTwoSwapHelper;
using QuantExt::ImmFraRateHelper;
//using QuantExt::CrossCcyFixFloatSwapHelper;

typedef boost::shared_ptr<RateHelper> CrossCcyBasisSwapHelperPtr;
typedef boost::shared_ptr<RateHelper> TenorBasisSwapHelperPtr;
typedef boost::shared_ptr<RateHelper> SubPeriodsSwapHelperPtr;
typedef boost::shared_ptr<RateHelper> OICCBSHelperPtr;
typedef boost::shared_ptr<RateHelper> OIBSHelperPtr;
typedef boost::shared_ptr<RateHelper> BasisTwoSwapHelperPtr;
typedef boost::shared_ptr<RateHelper> ImmFraRateHelperPtr;
//typedef boost::shared_ptr<RateHelper> CrossCcyFixFloatSwapHelperPtr;
%}

%rename(CrossCcyBasisSwapHelper) CrossCcyBasisSwapHelperPtr;
class CrossCcyBasisSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    CrossCcyBasisSwapHelperPtr(const Handle<Quote>& spreadQuote,
                               const Handle<Quote>& spotFX,
                               Natural settlementDays,
                               const Calendar& settlementCalendar,
                               const Period& swapTenor,
                               BusinessDayConvention rollConvention,
                               const IborIndexPtr& flatIndex,
                               const IborIndexPtr& spreadIndex,
                               const Handle<YieldTermStructure>& flatDiscountCurve,
                               const Handle<YieldTermStructure>& spreadDiscountCurve, 
                               bool eom = false,
                               bool flatIsDomestic = true) {
        boost::shared_ptr<IborIndex> flatIbor = boost::dynamic_pointer_cast<IborIndex>(flatIndex);
        boost::shared_ptr<IborIndex> spreadIbor = boost::dynamic_pointer_cast<IborIndex>(spreadIndex);
        return new CrossCcyBasisSwapHelperPtr(
            new CrossCcyBasisSwapHelper(spreadQuote, 
                                        spotFX, 
                                        settlementDays, 
                                        settlementCalendar, 
                                        swapTenor, 
                                        rollConvention, 
                                        flatIbor, 
                                        spreadIbor, 
                                        flatDiscountCurve, 
                                        spreadDiscountCurve, 
                                        eom, 
                                        flatIsDomestic));
    }
    CrossCcyBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<CrossCcyBasisSwapHelper>(*self)->swap();
    }
  }
};

%rename(TenorBasisSwapHelper) TenorBasisSwapHelperPtr;
class TenorBasisSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    TenorBasisSwapHelperPtr(QuantLib::Handle<QuantLib::Quote> spread,
                            const QuantLib::Period& swapTenor,
                            const IborIndexPtr longIndex,
                            const IborIndexPtr shortIndex,
                            const QuantLib::Period& shortPayTenor = QuantLib::Period(),
                            const QuantLib::Handle<QuantLib::YieldTermStructure>& discountingCurve 
                                = QuantLib::Handle<QuantLib::YieldTermStructure>(),
                            bool spreadOnShort = true, 
                            bool includeSpread = false,
                            SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
        boost::shared_ptr<IborIndex> longIbor = boost::dynamic_pointer_cast<IborIndex>(longIndex);
        boost::shared_ptr<IborIndex> shortIbor = boost::dynamic_pointer_cast<IborIndex>(shortIndex);
        return new TenorBasisSwapHelperPtr(
            new TenorBasisSwapHelper(spread,
                                     swapTenor,
                                     longIbor,
                                     shortIbor,
                                     shortPayTenor,
                                     discountingCurve,
                                     spreadOnShort,
                                     includeSpread,
                                     type));
    }
    TenorBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<TenorBasisSwapHelper>(*self)->swap();
    }
  }
};

%rename(SubPeriodsSwapHelper) SubPeriodsSwapHelperPtr;
class SubPeriodsSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    SubPeriodsSwapHelperPtr(QuantLib::Handle<QuantLib::Quote> spread,
                            const QuantLib::Period& swapTenor,
                            const QuantLib::Period& fixedTenor,
                            const QuantLib::Calendar& fixedCalendar,
                            const QuantLib::DayCounter& fixedDayCount,
                            QuantLib::BusinessDayConvention fixedConvention,
                            const QuantLib::Period& floatPayTenor,
                            const IborIndexPtr& iborIndex,
                            const QuantLib::DayCounter& floatDayCount,
                            const QuantLib::Handle<QuantLib::YieldTermStructure>& discountingCurve = 
                                QuantLib::Handle<QuantLib::YieldTermStructure>(),
                            SubPeriodsCoupon::Type type = SubPeriodsCoupon::Compounding) {
        boost::shared_ptr<IborIndex> floatIndex = boost::dynamic_pointer_cast<IborIndex>(iborIndex);
        return new SubPeriodsSwapHelperPtr(
            new SubPeriodsSwapHelper(spread,
                                     swapTenor,
                                     fixedTenor,
                                     fixedCalendar,
                                     fixedDayCount,
                                     fixedConvention,
                                     floatPayTenor,
                                     floatIndex,
                                     floatDayCount,
                                     discountingCurve,
                                     type));
    }
    SubPeriodsSwapPtr swap() {
        return boost::dynamic_pointer_cast<SubPeriodsSwapHelper>(*self)->swap();
    }
  }
};

%rename(OIBSHelper) OIBSHelperPtr;
class OIBSHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    OIBSHelperPtr(QuantLib::Natural settlementDays,
                  const QuantLib::Period& tenor, 
                  const QuantLib::Handle<QuantLib::Quote>& oisSpread, 
                  const OvernightIndexPtr& overnightIndex,
                  const IborIndexPtr& iborIndex,
                  const QuantLib::Handle<QuantLib::YieldTermStructure>& discount 
                        = QuantLib::Handle<QuantLib::YieldTermStructure>()) {
        boost::shared_ptr<OvernightIndex> overnightFloat = boost::dynamic_pointer_cast<OvernightIndex>(overnightIndex);
        boost::shared_ptr<IborIndex> iborFloat = boost::dynamic_pointer_cast<IborIndex>(iborIndex);
        return new OIBSHelperPtr(
            new OIBSHelper(settlementDays,
                           tenor,
                           oisSpread,
                           overnightFloat,
                           iborFloat,
                           discount));
    }
    OvernightIndexedBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<OIBSHelper>(*self)->swap();
    }
  }
};

%rename(BasisTwoSwapHelper) BasisTwoSwapHelperPtr;
class BasisTwoSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    BasisTwoSwapHelperPtr(const QuantLib::Handle<QuantLib::Quote>& spread, 
                          const QuantLib::Period& swapTenor, 
                          const QuantLib::Calendar& calendar,
                          QuantLib::Frequency longFixedFrequency, 
                          QuantLib::BusinessDayConvention longFixedConvention,
                          const QuantLib::DayCounter& longFixedDayCount, 
                          const IborIndexPtr& longIndex,
                          QuantLib::Frequency shortFixedFrequency, 
                          QuantLib::BusinessDayConvention shortFixedConvention,
                          const QuantLib::DayCounter& shortFixedDayCount, 
                          const IborIndexPtr& shortIndex,
                          bool longMinusShort = true,
                          const QuantLib::Handle<QuantLib::YieldTermStructure>& discountingCurve 
                                = QuantLib::Handle<QuantLib::YieldTermStructure>()) {
        boost::shared_ptr<IborIndex> longFloat = boost::dynamic_pointer_cast<IborIndex>(longIndex);
        boost::shared_ptr<IborIndex> shortFloat = boost::dynamic_pointer_cast<IborIndex>(shortIndex);
        return new BasisTwoSwapHelperPtr(
            new BasisTwoSwapHelper(spread,
                                   swapTenor,
                                   calendar,
                                   longFixedFrequency,
                                   longFixedConvention,
                                   longFixedDayCount,
                                   longFloat,
                                   shortFixedFrequency,
                                   shortFixedConvention,
                                   shortFixedDayCount,
                                   shortFloat,
                                   longMinusShort,
                                   discountingCurve));
    }
    VanillaSwapPtr longSwap() {
        return boost::dynamic_pointer_cast<BasisTwoSwapHelper>(*self)->longSwap();
    }
    VanillaSwapPtr shortSwap() {
        return boost::dynamic_pointer_cast<BasisTwoSwapHelper>(*self)->shortSwap();
    }
  }
};

%rename(OICCBSHelper) OICCBSHelperPtr;
class OICCBSHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    OICCBSHelperPtr(QuantLib::Natural settlementDays,
                    const QuantLib::Period& term,
                    const OvernightIndexPtr& payIndex,
                    const QuantLib::Period& payTenor,
                    const OvernightIndexPtr& recIndex, 
                    const QuantLib::Period& recTenor,
                    const QuantLib::Handle<QuantLib::Quote>& spreadQuote, 
                    const QuantLib::Handle<QuantLib::YieldTermStructure>& fixedDiscountCurve,
                    bool spreadQuoteOnPayLeg, 
                    bool fixedDiscountOnPayLeg) {
        boost::shared_ptr<OvernightIndex> payFloat = boost::dynamic_pointer_cast<OvernightIndex>(payIndex);
        boost::shared_ptr<OvernightIndex> recFloat = boost::dynamic_pointer_cast<OvernightIndex>(recIndex);
        return new OICCBSHelperPtr(
            new OICCBSHelper(settlementDays,
                             term,
                             payFloat,
                             payTenor,
                             recFloat,
                             recTenor,
                             spreadQuote,
                             fixedDiscountCurve,
                             spreadQuoteOnPayLeg,
                             fixedDiscountOnPayLeg));
    }
    OvernightIndexedCrossCcyBasisSwapPtr swap() {
        return boost::dynamic_pointer_cast<OICCBSHelper>(*self)->swap();
    }
  }
};


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
            return new ImmFraRateHelperPtr(
                new ImmFraRateHelper(rate,
                                     imm1,
                                     imm2,
                                     ibrIndex,
                                     pillar,
                                     customPillarDate));
        }
    }
};

/*
%rename(CrossCcyFixFloatSwapHelper) CrossCcyFixFloatSwapHelperPtr;
class CrossCcyFixFloatSwapHelperPtr : public boost::shared_ptr<RateHelper> {
  public:
    %extend {
    CrossCcyFixFloatSwapHelperPtr(const QuantLib::Handle<QuantLib::Quote>& rate, 
								const QuantLib::Handle<QuantLib::Quote>& spotFx, 
								QuantLib::Natural settlementDays, 
								const QuantLib::Calendar& paymentCalendar, 
								QuantLib::BusinessDayConvention paymentConvention, 
								const QuantLib::Period& tenor, 
								const QuantLib::Currency& fixedCurrency,
								QuantLib::Frequency fixedFrequency, 
								QuantLib::BusinessDayConvention fixedConvention, 
								const QuantLib::DayCounter& fixedDayCount, 
								const IborIndexPtr& index, 
								const QuantLib::Handle<QuantLib::YieldTermStructure>& floatDiscount, 
								const QuantLib::Handle<QuantLib::Quote>& spread = QuantLib::Handle<QuantLib::Quote>(), 
								bool endOfMonth = false) {
				  boost::shared_ptr<IborIndex> indexSwap = boost::dynamic_pointer_cast<IborIndex>(index);
return new CrossCcyFixFloatSwapHelperPtr(new CrossCcyFixFloatSwapHelper(rate,
																		spotFx,
																		settlementDays,
																		paymentCalendar,
																		paymentConvention,
																		tenor,
																		fixedCurrency,
																		fixedFrequency,
																		fixedConvention,
																		fixedDayCount,
																		indexSwap,
																		floatDiscount,
																		spread));
    }

    CrossCcyFixFloatSwapPtr swap() {
      return boost::dynamic_pointer_cast<CrossCcyFixFloatSwapHelper>(*self)->swap();
    }
  }
};
*/
#endif
