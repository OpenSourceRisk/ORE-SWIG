
/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_loader_i
#define ored_loader_i

%include ored_marketdatum.i

%{
using ore::data::Loader;
using ore::data::Fixing;
%}

%ignore Loader;
class Loader {
public:
    const std::vector<boost::shared_ptr<MarketDatum>>& loadQuotes(const QuantLib::Date&) const;
    const boost::shared_ptr<MarketDatum>& get(const std::string& name, const QuantLib::Date&) const;
    bool has(const std::string& name, const QuantLib::Date& d) const;
    boost::shared_ptr<MarketDatum> get(const std::pair<std::string, bool>& name, const QuantLib::Date& d) const;
    //const std::vector<Fixing>& loadFixings() const;
    //const std::vector<Fixing>& loadDividends() const;
};
%template(Loader) boost::shared_ptr<Loader>;

%{
using ore::data::CSVLoader;
typedef boost::shared_ptr<Loader> CSVLoaderPtr;
%}

%rename(CSVLoader) CSVLoaderPtr;
class CSVLoaderPtr : public boost::shared_ptr<Loader> {
public:
  %extend {
        CSVLoaderPtr(const std::string& marketFilename, const std::string& fixingFilename,
                     bool implyTodaysFixings = false) {
            return new CSVLoaderPtr(new CSVLoader(marketFilename, fixingFilename, implyTodaysFixings));
        }
        CSVLoaderPtr(const std::vector<std::string>& marketFiles, const std::vector<std::string>& fixingFiles,
                     bool implyTodaysFixings = false) {
            return new CSVLoaderPtr(new CSVLoader(marketFiles, fixingFiles, implyTodaysFixings));
        }
  }
};

%{
using ore::data::InMemoryLoader;
typedef boost::shared_ptr<Loader> InMemoryLoaderPtr;
%}

%rename(InMemoryLoader) InMemoryLoaderPtr;
class InMemoryLoaderPtr : public boost::shared_ptr<Loader> {
public:
  %extend {
        InMemoryLoaderPtr() {
            return new InMemoryLoaderPtr(new InMemoryLoader());
        }
        void add(QuantLib::Date date, const std::string& name, QuantLib::Real value) {
            return boost::dynamic_pointer_cast<InMemoryLoader>(*self)->add(date, name, value);
        }
        void addFixing(QuantLib::Date date, const std::string& name, QuantLib::Real value) {
            return boost::dynamic_pointer_cast<InMemoryLoader>(*self)->addFixing(date, name, value);
        }
  }
};

/*struct Fixing {
    QuantLib::Date date;
    std::string name;
    QuantLib::Real fixing;
    Fixing(const QuantLib::Date& d, const std::string& s, const QuantLib::Real f);
};*/

%template(StringBoolPair) std::pair<std::string, bool>;
%template(MarketDatumVector) std::vector<boost::shared_ptr<MarketDatum>>;
//%template(FixingVector) std::vector<ore::data::Fixing>;


#endif