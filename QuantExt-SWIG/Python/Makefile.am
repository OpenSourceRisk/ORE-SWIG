
CLEANFILES = QuantExt/quantext_wrap.cpp QuantExt/QuantExt.py .build-stamp

BUILT_SOURCES = QuantExt/quantext_wrap.cpp QuantExt/QuantExt.py

if HAVE_PYTHON
if BUILD_PYTHON

all-local: .build-stamp

.build-stamp: QuantExt/quantext_wrap.cpp QuantExt/QuantExt.py
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

QuantExt/quantext_wrap.cpp QuantExt/QuantExt.py: ../SWIG/*.i
	$(SWIG) -python -c++ -modern -outdir QuantExt \
            -o QuantExt/quantext_wrap.cpp -I../../QuantLib-SWIG/SWIG ../SWIG/quantext.i 

dist-hook:
	mkdir -p $(distdir)/examples
	cp ./examples/*.py $(distdir)/examples
	mkdir -p $(distdir)/test
	cp ./test/*.py $(distdir)/test

EXTRA_DIST = README.txt setup.py QuantExt/__init__.py $(BUILT_SOURCES)

