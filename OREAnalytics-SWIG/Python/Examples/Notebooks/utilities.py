import sys

def checkErrorsAndRunTime(app):
    errors = app.getErrors()
    print ("Completed with", len(errors), "errors/warnings")
    if len(errors) > 0:
        for e in errors:
            print(e)        
    print ("Run time: %.4f sec" % app.getRunTime())       

def writeList(lst):
    print()
    for r in lst:
        print("-", r)
        
def checkReportStructure(name, report):
    # These are the column types values and meaning, see PlainInMemoryReport definition 
    columnTypes = { 0: "Size",
                    1: "Real",
                    2: "string",
                    3: "Date",
                    4: "Period" }

    print("Report: ", name)
    print("columns:", report.columns())
    print("rows:   ", report.rows())
    print()
    print ("%-6s %-20s %-8s %-10s" % ("Column", "Header", "Type", "TypeString"))
    for i in range(0, report.columns()):
        print("%-6d %-20s %-8s %-10s" % (i,
                                         report.header(i),
                                         report.columnType(i),
                                         columnTypes[report.columnType(i)]))
        sys.stdout.flush()

# example: writeReport(report, [0, 1, 3, 5]);
def writeReport(report, columnNumbers):
    column = [None] * report.columns()
    for c in range(0, report.columns() - 1):
        typ = report.columnType(c)
        if typ == 0:
            column[c] = report.dataAsSize(c);
        elif typ == 1:
            column[c] = report.dataAsReal(c);
        elif typ == 2:
            column[c] = report.dataAsString(c);
        elif typ == 3:
            column[c] = report.dataAsDate(c);
        elif typ == 4:
            column[c] = report.dataAsPeriod(c);

    print()
    
    for i in range(0, report.rows()):
        if i == 0:
            for c in columnNumbers:
                if c == columnNumbers[-1]:
                    eol = "\n"
                else:
                    eol = ""
                print ("%-17s  " % report.header(c), end=eol)

        for c in columnNumbers:
            typ = report.columnType(c)
            if c == columnNumbers[-1]:
                eol = "\n"
            else:
                eol = ""
            if typ == 0:
                print ("%-17d  " % column[c][i], end=eol)
            elif typ == 1:
                print ("%-17.2f  " % column[c][i], end=eol)
            elif typ == 2:
                print ("%-17s  " % column[c][i], end=eol)
            elif typ == 3:
                print ("%-17s  " % column[c][i].ISO(), end=eol)
            elif typ == 4:
                print ("%-17s  " % column[c][i], end=eol)       
