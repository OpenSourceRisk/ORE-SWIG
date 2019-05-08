# -*- coding: iso-8859-1 -*-
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

import sys
if sys.version_info.major >= 3:
    from .OREPlus import *
    from .OREPlus import _OREPlus
else:
    from OREPlus import *
    from OREPlus import _OREPlus
del sys

__author__ = 'Quaternion Risk Management'
__email__ = 'ino@quaternion.com'

if hasattr(_OREPlus,'__version__'):
    __version__ = _OREPlus.__version__
elif hasattr(_OREPlus.cvar,'__version__'):
    __version__ = _OREPlus.cvar.__version__
else:
    print('Could not find __version__ attribute')

if hasattr(_OREPlus,'__hexversion__'):
    __hexversion__ = _OREPlus.__hexversion__
elif hasattr(_OREPlus.cvar,'__hexversion__'):
    __hexversion__ = _OREPlus.cvar.__hexversion__
else:
    print('Could not find __hexversion__ attribute')

import datetime
now = datetime.datetime.now()
expiry = datetime.datetime(2019, 3, 15)
if now > expiry:
    raise Exception("Evaluation license expired. Please contact info@quaternion.com to renew license")

__license__ = """
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2018 Quaternion Risk Management Ltd
All rights reserved.
"""
