# -*- coding: utf-8 -*-

"""
Copyright (C) 2019, Zato Source s.r.o. https://zato.io

Licensed under AGPLv3, see LICENSE.txt for terms and conditions.
"""

from __future__ import absolute_import, division, print_function, unicode_literals

# Zato
from zato.common import exception

# Backward compatibility - in 3.0 these exceptions were moved from here to zato.common.exception

ClientHTTPError = exception.ClientHTTPError
BadRequest = exception.BadRequest
Conflict = exception.Conflict
Forbidden = exception.Forbidden
MethodNotAllowed = exception.MethodNotAllowed
NotFound = exception.NotFound
Unauthorized = exception.Unauthorized
TooManyRequests = exception.TooManyRequests
