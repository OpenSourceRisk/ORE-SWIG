
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_parsers_i
#define ored_parsers_i

%include indexes.i
%include termstructures.i
%include ored_conventions.i

%{
using QuantLib::YieldTermStructure;
using QuantLib::Handle;
using ore::data::parseIborIndex;
%}

IborIndexPtr parseIborIndex(const std::string& s,
    const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>()); 

#endif