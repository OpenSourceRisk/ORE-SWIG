
The C++ wrappers for the ORE Python extension modules are created
by means of SWIG (Simplified Wrapper and Interface Generator)
available from <http://www.swig.org/>; the latest version is suggested.
Both Python 2.7 and 3.x are supported.

Generating the wrappers is not required if you are using a distributed
tarball. If you're building from a Git checkout, instead, use the
command:

    python setup.py wrap

The commands to be issued for building, testing and installing the
wrappers are:

    python setup.py build
    python setup.py test
    python setup.py install

respectively.

The build step requires that the Boost, Python, QuantLib and ORE
headers and libraries can be found by the compiler.
On Unix-like platforms, this requires that an `quantext-config` script
(an extended version of quantlib-config) is in your path.
On the Windows platform, instead, it requires you to define the
`ORE_DIR`, `BOOST_ROOT`, `BOOST_LIBRARYDIR`, `PYTHON_INCLUDE` and `PYTHON_LIB`
environment variables pointing to your ORE root directory
(e.g. `C:\Dev\ORE`) etc.

The install step might require superuser privileges.
An alternate install location can be specified with the command:

    python setup.py install --prefix=/home/johndoe

The test suite is implemented on top of the PyUnit framework, which is
included in the Python standard library.
