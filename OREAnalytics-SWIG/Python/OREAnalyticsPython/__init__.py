# -*- coding: iso-8859-1 -*-
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

import sys
if sys.version_info.major >= 3:
    from .OREAnalyticsPython import *
    from .OREAnalyticsPython import _OREAnalyticsPython
else:
    from OREAnalyticsPython import *
    from OREAnalyticsPython import _OREAnalyticsPython
del sys

__author__ = 'Quaternion Risk Management'
__email__ = 'ino@quaternion.com'

if hasattr(_OREAnalyticsPython,'__version__'):
    __version__ = _OREAnalyticsPython.__version__
elif hasattr(_OREAnalyticsPython.cvar,'__version__'):
    __version__ = _OREAnalyticsPython.cvar.__version__
else:
    print('Could not find __version__ attribute')

if hasattr(_OREAnalyticsPython,'__hexversion__'):
    __hexversion__ = _OREAnalyticsPython.__hexversion__
elif hasattr(_OREAnalyticsPython.cvar,'__hexversion__'):
    __hexversion__ = _OREAnalyticsPython.cvar.__hexversion__
else:
    print('Could not find __hexversion__ attribute')

__license__ = """
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2018 Quaternion Risk Management Ltd
All rights reserved.
"""
