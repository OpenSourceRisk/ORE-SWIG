
CLEANFILES = OREPlus/oreplus_wrap.cpp OREPlus/OREPlus.py .build-stamp

BUILT_SOURCES = OREPlus/oreplus_wrap.cpp OREPlus/OREPlus.py

if HAVE_PYTHON
if BUILD_PYTHON

all-local: .build-stamp

.build-stamp: OREPlus/oreplus_wrap.cpp OREPlus/OREPlus.py
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

OREPlus/oreplus_wrap.cpp OREPlus/OREPlus.py: ../SWIG/*.i
	$(SWIG) -python -c++ -modern -outdir OREPlus \
            -o OREPlus/oreplus_wrap.cpp -I../../QuantLib-SWIG/SWIG -I../../QuantExt-SWIG/SWIG -I../../OREData-SWIG/SWIG -I../../OREAnalytics-SWIG/SWIG ../SWIG/oreplus.i 

dist-hook:
	mkdir -p $(distdir)/examples
	cp ./examples/*.py $(distdir)/examples
	mkdir -p $(distdir)/test
	cp ./test/*.py $(distdir)/test

EXTRA_DIST = README.txt setup.py OREPlus/__init__.py $(BUILT_SOURCES)

