# Run Juyper Notebook examples using the ORE Python wheels

This tutorial is aimed at the user who wants to install the ORE
Python module and use it to execute example Jupyter notebooks provided on
https://github.com/OpenSourceRisk/ORE-SWIG.  No compilation is necessary.

[Back to tutorials index](tutorials.00.index.md)

**Please note** that (as of October 2023) the published ORE Python wheels are
available for Python versions 3.8 up to 3.11 for Windows, Linux and macOS arm64,
and Python versions up to 3.10 for Intel Mac users.

We assume below that the python executable points to a permissible Python 3 version.

Create a virtual environemnt
    python -m venv venv

Activate the virtual environment (Windows)
    CALL .\venv\Scripts\activate.bat

Activate the virtual environment (Linux, Mac)
    source "$(pwd)/venv/bin/activate"

Upgrade pip
    python -m pip install --upgrade pip

Install required Python modules
    python -m pip install open-source-risk-engine pytest matplotlib pandas plotly jupyter_server==2.8.0 jupyter

Launch Jupyter with reference to the Notebooks directory 
    python -m jupyterlab --notebook-dir=/path/to/OREAnalytics-SWIG/Python/Examples/Notebooks

Exit the virtual environment
    deactivate


