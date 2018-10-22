
CLEANFILES = OREData/oredata_wrap.cpp OREData/OREData.py .build-stamp

BUILT_SOURCES = OREData/oredata_wrap.cpp OREData/OREData.py

if HAVE_PYTHON
if BUILD_PYTHON

all-local: .build-stamp

.build-stamp: OREData/oredata_wrap.cpp OREData/OREData.py
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

OREData/oredata_wrap.cpp OREData/OREData.py: ../SWIG/*.i
	$(SWIG) -python -c++ -modern -outdir OREData \
            -o OREData/oredata_wrap.cpp -I../../QuantLib-SWIG/SWIG -I../../QuantExt-SWIG/SWIG ../SWIG/oredata.i 

dist-hook:
	mkdir -p $(distdir)/examples
	cp ./examples/*.py $(distdir)/examples
	mkdir -p $(distdir)/test
	cp ./test/*.py $(distdir)/test

EXTRA_DIST = README.txt setup.py OREData/__init__.py $(BUILT_SOURCES)

