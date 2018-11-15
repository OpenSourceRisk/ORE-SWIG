/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_currencies_i
#define qle_currencies_i

%include currencies.i

%{
using QuantLib::Currency;
%}

namespace QuantExt {
	//African currencies
	class TNDCurrency: public Currency {};
	class EGPCurrency: public Currency {};
	class NGNCurrency: public Currency {};
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
}

#endif