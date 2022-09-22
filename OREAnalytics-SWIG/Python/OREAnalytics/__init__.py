# -*- coding: iso-8859-1 -*-
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

import sys
if sys.version_info.major >= 3:
    from .OREAnalytics import *
    from .OREAnalytics import _OREAnalytics
else:
    from OREAnalytics import *
    from OREAnalytics import _OREAnalytics
del sys

__author__ = 'Quaternion Risk Management'
__email__ = 'ino@quaternion.com'

if hasattr(_OREAnalytics,'__version__'):
    __version__ = _OREAnalytics.__version__
elif hasattr(_OREAnalytics.cvar,'__version__'):
    __version__ = _OREAnalytics.cvar.__version__
else:
    print('Could not find __version__ attribute')

if hasattr(_OREAnalytics,'__hexversion__'):
    __hexversion__ = _OREAnalytics.__hexversion__
elif hasattr(_OREAnalytics.cvar,'__hexversion__'):
    __hexversion__ = _OREAnalytics.cvar.__hexversion__
else:
    print('Could not find __hexversion__ attribute')

__license__ = """
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2018 Quaternion Risk Management Ltd
All rights reserved.
"""
