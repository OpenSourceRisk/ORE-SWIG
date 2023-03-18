/*
 Copyright (C) 2018, 2020 Quaternion Risk Management Ltd
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

#ifndef oreap_app_i
#define oreap_app_i

%include orea_app.i

%{
using ore::analytics::Parameters;
using ore::analytics::OREApp;
using oreplus::analytics::OREAppPlus;
%}

%shared_ptr(OREAppPlus)
class OREAppPlus : public OREApp {
  public:
    OREAppPlus(ext::shared_ptr<Parameters>& p);
    void run(bool useAnalytics = true);
};

#endif
