set PYTHONPATH=%PYTHONPATH%;C:\dev\ORE-SWIG\install

cd OREAnalytics-SWIG\Python\Test
python OREAnalyticsTestSuite.py

cd ..\..\..\OREData-SWIG\Python\test
python OREDataTestSuite.py

cd ..\..\..\QuantExt-SWIG\Python\test
python QuantExtTestSuite.py

cd ..\..\..\QuantLib-SWIG\Python\test
python QuantLibTestSuite.py

pause
