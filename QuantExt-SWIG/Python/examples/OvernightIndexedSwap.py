# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from QuantExt import *

def formatPrice(p,digits=2):
    format = '%%.%df' % digits
    return format % p

# global data
calendar = UnitedStates()
todays_date = Date(4, October, 2018)
Settings.instance().evaluationDate = todays_date
settlement_date = Date(6, October, 2018)

# instrument
length = 5
nominal = 1000000.0
maturity_date = calendar.advance(settlement_date, 5, Years)
ois_leg_tenor = Period(1, Years)
libor_leg_tenor = Period(3, Months)
ois_spread = 0.02
libor_spread = 0.0

# term structures
libor_term_structure = RelinkableYieldTermStructureHandle()
ois_term_structure = RelinkableYieldTermStructureHandle()
libor_index = USDLibor(Period(3, Months), libor_term_structure)
ois_index = FedFunds(ois_term_structure)

# schedules
bus_day_convention = Following
date_generation = DateGeneration.Forward
end_of_month = False

ois_schedule = Schedule(settlement_date,
                        maturity_date,
                        ois_leg_tenor,
                        calendar,
                        bus_day_convention,
                        bus_day_convention,
                        date_generation,
                        end_of_month)

libor_schedule = Schedule(settlement_date,
                          maturity_date,
                          libor_leg_tenor,
                          calendar,
                          bus_day_convention,
                          bus_day_convention,
                          date_generation,
                          end_of_month)

# make overnight indexed basis swap 
instrument = OvernightIndexedBasisSwap(OvernightIndexedBasisSwap.Payer, 
                                       nominal,
                                       ois_schedule,
                                       ois_index,
                                       libor_schedule,
                                       libor_index,
                                       ois_spread, 
                                       libor_spread)
                                       
# curves
ois_rate = 0.01
libor_rate = 0.03
ois_flat_forward = FlatForward(todays_date, ois_rate, ois_index.dayCounter())
libor_flat_forward = FlatForward(todays_date, libor_rate, libor_index.dayCounter())
ois_term_structure.linkTo(ois_flat_forward)
libor_term_structure.linkTo(libor_flat_forward)

engine = DiscountingSwapEngine(ois_term_structure)
instrument.setPricingEngine(engine)

print(libor_index.name() + " vs " + ois_index.name(),
      "Basis Swap, NPV = " + formatPrice(instrument.NPV()))
      







