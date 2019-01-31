
/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_log_i
#define ored_log_i

%{
using ore::data::Log;
%}

class Log {
  private:
    Log();
  public:
    static Log& instance();
    %extend {
        void registerLogger(const boost::shared_ptr<Logger>& logger) {
            self->registerLogger(logger);
        }
        boost::shared_ptr<Logger>& logger(const string& name) {
            return self->logger(name);
        }
        void removeLogger(const string& name) {
            self->removeLogger(name);
        }
        void removeAllLoggers() {
            self->removeAllLoggers();
        }
        bool filter(unsigned mask) {
            return self->filter(mask);
        }
        bool mask() {
            return self->mask();
        }
        void setMask(unsigned mask) {
            self->setMask(mask);
        }
        bool enabled() {
            return self->enabled();
        }
        void switchOn() {
            self->switchOn();
        }
        void switchOff() {
            self->switchOff();
        }
    }
};

%{
using ore::data::Log;
%}

%ignore Logger;
class Logger {
public:
};
%template(Logger) boost::shared_ptr<Logger>;

%{
using ore::data::FileLogger;
typedef boost::shared_ptr<Logger> FileLoggerPtr;
%}

%rename(FileLogger) FileLoggerPtr;
class FileLoggerPtr : public boost::shared_ptr<Logger> {
public:
  %extend {
        FileLoggerPtr(const string& filename) {
            return new FileLoggerPtr(new FileLogger(filename));
    }
  }  
};



#endif