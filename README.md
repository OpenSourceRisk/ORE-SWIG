
ORE-SWIG: Language bindings for ORE
===================================

The [Open Source Risk](http://opensourcerisk.org) project aims at
estblishing a transparent peer-reviewed framework for pricing and risk
analysis. Open Source Risk Engine (ORE) is based on QuantLib
(<http://quantlib.org>) and consists of three libraries written in
C++.

Similar to QuantLib-SWIG, ORE-SWIG intends to provide the means
to use the ORE libraries side by side with QuantLib from a
number of languages including Python, Ruby, Perl, Java and C#. 

Download and usage
------------------

ORE and ORE-SWIG can be downloaded from the
[OpenSourceRisk](http://opensourcerisk.org) project site which points
to the Open Source Risk repositories on [GitHub](http://github.com/OpenSourceRisk).

The ORE-SWIG project directory contains QuantExt-SWIG, OREData-SWIG and
OREAnalytics-SWIG folders. Within the ORE-SWIG project directory, pull
in the QuantLib-SWIG project by running

	git submodule init
	git submodule update

Prerequisite for building the wrappers is building ORE (upcoming
release 1.14) following the steps outlined in ORE's user guide, e.g. using CMake.

To build ORE-SWIG on Windows, macOS or Linux using CMake and
Ninja: Edit the top level CMakeLists.txt to select/deselect
specific library/language folders, create a subdirectory "build",
change to the build directory, and run

	cmake \
		-G Ninja \
		-D ORE=<ORE Root Directory> \
		[-D BOOST_ROOT=<Top level boost include directory> ] \
		[-D BOOST_LIBRARYDIR=<Location of the compiled boost libraries> ] \ 
		[-D PYTHON_LIBRARY=<Full name including path to the 'libpython*' library> ]	\
		[-D PYTHON_INCLUDE_DIR=<Directory that contains Python.h> ] \
		..

	ninja

Alternatively, change to a specific library/language subdirectory and follow
the instructions in its README file.

To try e.g. an OREAnalytics Python example, update your PYTHONPATH so
that it includes the directory that contains the newly built python module and
associated native library (both in
ORE-SWIG/build/OREAnalytics-SWIG/Python), change to
ORE-SWIG/OREAnalytics-SWIG/Python/Examples and run

	python ore.py

To try a simple OREAnalytics Java example, change to
ORE-SWIG/OREAnalytics-SWIG/Java/Examples and run 

	java -Djava.library.path=../../../build/OREAnalytics-SWIG/Java \
		-jar ../../../build/OREAnalytics-SWIG/Java/ORERunner.jar \
		Input/ore.xml

Contributing
------------

ORE-SWIG initially contains the framework for building the wrappers
including QuantLib wrappers and a limited number of wrapped classes in
each of the three ORE libraries to demonstrate the principle. Overall, ORE
contains more than 500 classes that could be added to ORE-SWIG over
time.

The easiest way to contribute additional interface files is through
pull requests on GitHub.  Get a GitHub account if you don't have it
already and clone the repository at
<https://github.com/OpenSourceRisk/ORE-SWIG> with the "Fork" button
in the top right corner of the page. Check out your clone to your
machine, code away, push your changes to your clone and submit a pull
request; instructions are available at
<https://help.github.com/articles/fork-a-repo>.  (In case you need
them, more detailed instructions for creating pull requests are at
<https://help.github.com/articles/using-pull-requests>, and a basic
guide to GitHub is at
<https://guides.github.com/activities/hello-world/>.

We're looking forward to your contributions.
