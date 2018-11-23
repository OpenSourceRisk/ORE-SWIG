
# Copyright (C) 2018 Quaternion Risk Manaement Ltd
# All rights reserved.

from OREPlus import *
import xml.etree.ElementTree as ET

# This will retrive a convention of name "id" from Conventions class "container"
## the type() of the retrieved object is checked so that a downcast to the derived class can be performed
def fetchConventionObject(container, id):
    downcastMap = {
        Convention.Zero : ZeroRateConvention.getFullView,
        Convention.Deposit : DepositConvention.getFullView,
        Convention.CDS : CdsConvention.getFullView,
        Convention.Future : FutureConvention.getFullView,
        Convention.FRA : FraConvention.getFullView,
        Convention.SwapIndex : SwapIndexConvention.getFullView,
        Convention.Swap : IRSwapConvention.getFullView,
        Convention.OIS : OisConvention.getFullView,
        Convention.AverageOis : AverageOisConvention.getFullView,
        Convention.TenorBasisSwap : TenorBasisSwapConvention.getFullView,
        Convention.TenorBasisTwoSwap : TenorBasisTwoSwapConvention.getFullView,
        Convention.FX : FXConvention.getFullView,
        Convention.CrossCcyBasis : CrossCcyBasisSwapConvention.getFullView,
        Convention.InflationSwap : InflationSwapConvention.getFullView,
        Convention.SecuritySpread : SecuritySpreadConvention.getFullView
    }
    
    convObj = container.get(id)
    fullViewObj = downcastMap[convObj.type()](convObj)
    return fullViewObj

# This will construct a single convention object from XML. 
## It will be of derived class type, hence exposing the full set of member functions
def buildFullConventionFromXML(xmlElement):
    constructorMap = {
        'Zero' : ZeroRateConvention,
        'Deposit' : DepositConvention,
        'CDS' : CdsConvention,
        'Future' : FutureConvention,
        'FRA' : FraConvention,
        'SwapIndex' : SwapIndexConvention,
        'Swap' : IRSwapConvention,
        'OIS' : OisConvention,
        'AverageOIS' : AverageOisConvention,
        'TenorBasisSwap' : TenorBasisSwapConvention,
        'TenorBasisTwoSwap' : TenorBasisTwoSwapConvention,
        'FX' : FXConvention,
        'CrossCurrencyBasis' : CrossCcyBasisSwapConvention,
        'InflationSwap' : InflationSwapConvention
    }
    if (xmlElement.tag not in constructorMap):
        print("WARNING - " + xmlElement.tag + " not recognised")
        return None
    convObj = constructorMap[xmlElement.tag]()
    convObj.fromXMLString(ET.tostring(xmlElement, encoding="unicode"))
    return convObj
    

# A - Populate the ore::data::Conventions container
## This allows us to retrieve objects of type "Convention"
### This however is merely the base class and hence not all required member functions are exposed.
#### Therefore, we need to downcast the returned object (using the getFullView() functions implemented in SWIG)
conv_container = Conventions()
print("Conventions type is ", type(conv_container))
convFile = "C:\Apps\Dev\ExodusPoint\oreswig\OREPlus-SWIG\Python\examples\Input\conventions.xml"
convXml = ET.parse(convFile).getroot()
convXmlStr = ET.tostring(convXml,encoding="unicode")
conv_container.fromXMLString(convXmlStr)
print("Loaded conventions from string")

convStr = "USD-AVERAGE-OIS-CONVENTIONS"
convObj = fetchConventionObject(conv_container, convStr)
print("convObj is of type ", type(convObj))
print("convObj ID = ", convObj.id())
convType = convObj.type()
print("convObj type() is ", convType)
idx = convObj.index()
print(idx)



# B - Another Idea - Loop through the XML and build each convention individually
## - We can still add these to the Conventions container

"""
for item in convXml:
        
    convObj = buildFullConventionFromXML(item)
    if convObj is None:
        print("skipping " + item.tag + ", " + item.find("Id").text)
        continue
    conv_id = convObj.id()
    print(convObj.id())
    print(type(convObj))
    convStr = convObj.toXMLString()
    print(convStr)
    
    conv_id_new = conv_id + "_2"
    item.find("Id").text = conv_id_new
    convObj_new = buildFullConventionFromXML(item)
    conv_container.add(convObj_new)
    gotConv = conv_container.get(conv_id_new)
    print(type(gotConv))
    
    ### ALTERNATIVE TO DOWNCAST : Use toXMLString() to convert object to XML. Then rebuild object from XML
    #### -- this can give us a copy of the object, which is of derived class type (and hence full member access)
    ##### -- CAVEAT: THIS DEPENDS ON THE toXMLString() FUNCTION RETURNING AN ACCURATE XML. HOW ROBUST IS THIS?
    gotConvStr = gotConv.toXMLString()
    convFullView = buildFullConventionFromXML(ET.fromstring(gotConvStr))
    print(type(convFullView))
    print(convFullView.id())
    if (convFullView.type() == Convention.Deposit):
        print(convFullView.id() + " index = " + convFullView.index())
"""
