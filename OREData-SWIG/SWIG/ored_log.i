
/*
 Copyright (C) 2019 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_log_i
#define ored_log_i

//          accumulated 'filter' for 'external' DEBUG_MASK
#define ORE_ALERT 1    // 00000001   1 = 2^1-1
#define ORE_CRITICAL 2 // 00000010   3 = 2^2-1
#define ORE_ERROR 4    // 00000100   7
#define ORE_WARNING 8  // 00001000  15
#define ORE_NOTICE 16  // 00010000  31
#define ORE_DEBUG 32   // 00100000  63 = 2^6-1
#define ORE_DATA 64    // 01000000  127

%{
using ore::data::Log;
using ore::data::Logger;
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
        boost::shared_ptr<Logger>& logger(const std::string& name) {
            return self->logger(name);
        }
        void removeLogger(const std::string& name) {
            self->removeLogger(name);
        }
        void removeAllLoggers() {
            self->removeAllLoggers();
        }
        /*
        void header(unsigned m, const char* filename, int lineNo) {
            self->header(m, filename, lineNo);
        }
        void std::ostream& logStream() {
            return self->logStream();
        }
        void log(unsigned m) {
            self->log(m);
        }*/
        bool filter(unsigned mask) {
            return self->filter(mask);
        }
        unsigned mask() {
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
        FileLoggerPtr(const std::string& filename) {
            return new FileLoggerPtr(new FileLogger(filename));
        }
  }
};

%{
using ore::data::BufferLogger;
typedef boost::shared_ptr<Logger> BufferLoggerPtr;
%}

%rename(BufferLogger) BufferLoggerPtr;
class BufferLoggerPtr : public boost::shared_ptr<Logger> {
public:
  %extend {
        BufferLoggerPtr(unsigned minLevel = ORE_DATA) {
            return new BufferLoggerPtr(new BufferLogger(minLevel));
        }
        bool hasNext() {
            return boost::dynamic_pointer_cast<BufferLogger>(*self)->hasNext();
        }
        std::string next() {
            return boost::dynamic_pointer_cast<BufferLogger>(*self)->next();
        }
  }
};

%rename(MLOG) MLOGSWIG;
%inline %{
static void MLOGSWIG(unsigned mask, const std::string& text, const char* filename, int lineNo) {
    QL_REQUIRE(lineNo > 0, "lineNo must be greater than 0");
    if (ore::data::Log::instance().enabled() && ore::data::Log::instance().filter(mask)) {
        ore::data::Log::instance().header(mask, filename, lineNo);
        ore::data::Log::instance().logStream() << text;
        ore::data::Log::instance().log(mask);
    }
}
%}

%define export_log(Name,Mask)

#if defined(SWIGPYTHON)
%pythoncode %{
def Name##(text):
    import inspect
    current_frame = inspect.currentframe()
    call_frame = inspect.getouterframes(current_frame, 2)[-1]
    MLOG(Mask##, text, call_frame.filename, call_frame.lineno)
%}
#endif

%enddef

export_log(ALOG, ORE_ALERT);
export_log(CLOG, ORE_CRITICAL);
export_log(ELOG, ORE_ERROR);
export_log(WLOG, ORE_WARNING);
export_log(LOG, ORE_NOTICE);
export_log(DLOG, ORE_DEBUG);
export_log(TLOG, ORE_DATA);

#endif