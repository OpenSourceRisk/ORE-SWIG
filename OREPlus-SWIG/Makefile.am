
#SUBDIRS = Java Python
SUBDIRS = Python

EXTRA_DIST = \
	autogen.sh


dist-hook:
	mkdir -p $(distdir)/SWIG
	cp -p ./SWIG/*.i $(distdir)/SWIG

