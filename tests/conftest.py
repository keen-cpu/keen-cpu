# SPDX-License-Identifier: MPL-2.0
#
# conftest.py -- top-level conftest
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from functools import wraps
from inspect import signature
from typing import Callable


def iterable_fixture(*iterables: list[str]) -> Callable:
    def inner(func):
        sig = signature(func)

        @wraps(func)
        def wrapper(*args, **kwargs):
            bound = sig.bind(*args, **kwargs)
            bound.apply_defaults()

            values = [bound.arguments.pop(iterable) for iterable in iterables]

            for values in zip(*values):
                values = dict(zip(iterables, values))

                func(**bound.arguments, **values)

        return wrapper

    return inner
