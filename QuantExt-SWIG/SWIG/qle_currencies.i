/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
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

#ifndef qle_currencies_i
#define qle_currencies_i

%include currencies.i

%{
using QuantLib::Currency;
%}

namespace QuantExt {
	//African currencies
	class EGPCurrency: public Currency {};
	class MADCurrency: public Currency {};
	
	//Asian currencies
	class KZTCurrency: public Currency {};
	class QARCurrency: public Currency {};
	class BHDCurrency: public Currency {};
	class OMRCurrency: public Currency {};
	class AEDCurrency: public Currency {};
	class PHPCurrency: public Currency {};
	class CNHCurrency: public Currency {};	
	
	//American currencies
	class MXVCurrency: public Currency {};
	class CLFCurrency: public Currency {};

	//Metals
	class XAUCurrency : public Currency {};
	class XAGCurrency : public Currency {};
	class XPTCurrency : public Currency {};
	class XPDCurrency : public Currency {};

}

#endif
