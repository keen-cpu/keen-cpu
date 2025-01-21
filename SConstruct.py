# SPDX-License-Identifier: MPL-2.0
#
# SConstruct.py
# Copyright (C) 2024  Jacob Koziej <jacobkoziej@gmail.com>

from SCons.Script import (
    EnsurePythonVersion,
    EnsureSConsVersion,
)

EnsureSConsVersion(4, 7, 0)
EnsurePythonVersion(3, 12)
