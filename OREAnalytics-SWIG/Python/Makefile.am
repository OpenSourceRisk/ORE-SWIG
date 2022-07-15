
CLEANFILES = OREAnalytics/oreanalytics_wrap.cpp OREAnalytics/OREAnalytics.py .build-stamp

BUILT_SOURCES = OREAnalytics/oreanalytics_wrap.cpp OREAnalytics/OREAnalytics.py

if HAVE_PYTHON
if BUILD_PYTHON

all-local: .build-stamp

.build-stamp: OREAnalytics/oreanalytics_wrap.cpp OREAnalytics/OREAnalytics.py
	CXXFLAGS="$(CXXFLAGS) $(CXXWARNINGFLAGS)" CC="$(CC)" CXX="$(CXX)" LDFLAGS="$(LDFLAGS)" $(PYTHON) setup.py build
	touch .build-stamp

check-local: .build-stamp
	$(PYTHON) setup.py test

install-exec-local: .build-stamp
	$(PYTHON) setup.py install

clean-local:
	rm -rf build

endif
endif

OREAnalytics/oreanalytics_wrap.cpp OREAnalytics/OREAnalytics.py: ../SWIG/*.i
	$(SWIG) -python -c++ -modern -outdir OREAnalytics \
            -o OREAnalytics/oreanalytics_wrap.cpp -I../../QuantLib-SWIG/SWIG -I../../QuantExt-SWIG/SWIG -I../../OREData-SWIG/SWIG ../SWIG/oreanalytics.i 

dist-hook:
	mkdir -p $(distdir)/examples
	cp ./examples/*.py $(distdir)/examples
	mkdir -p $(distdir)/test
	cp ./test/*.py $(distdir)/test

EXTRA_DIST = README.txt setup.py OREAnalytics/__init__.py $(BUILT_SOURCES)

