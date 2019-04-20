# -*- coding: iso-8859-1 -*-
"""
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
"""

import sys
if sys.version_info.major >= 3:
    from .QuantExt import *
    from .QuantExt import _QuantExt
else:
    from QuantExt import *
    from QuantExt import _QuantExt
del sys

__author__ = 'Quaternion Risk Management'
__email__ = 'ino@quaternion.com'

if hasattr(_QuantExt,'__version__'):
    __version__ = _QuantExt.__version__
elif hasattr(_QuantExt.cvar,'__version__'):
    __version__ = _QuantExt.cvar.__version__
else:
    print('Could not find __version__ attribute')

if hasattr(_QuantExt,'__hexversion__'):
    __hexversion__ = _QuantExt.__hexversion__
elif hasattr(_QuantExt.cvar,'__hexversion__'):
    __hexversion__ = _QuantExt.cvar.__hexversion__
else:
    print('Could not find __hexversion__ attribute')

__license__ = """
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2018 Quaternion Risk Management Ltd
All rights reserved.
"""
