# SPDX-License-Identifier: MPL-2.0
#
# SConstruct.py
# Copyright (C) 2024  Jacob Koziej <jacobkoziej@gmail.com>

import os

from SCons.Environment import Environment
from SCons.Script import (
    EnsurePythonVersion,
    EnsureSConsVersion,
)

EnsureSConsVersion(4, 7, 0)
EnsurePythonVersion(3, 12)


env = Environment(
    ENV={
        "PATH": os.environ["PATH"],
        "PYTHONPATH": os.environ.get("PYTHONPATH"),
        "TERM": os.environ.get("TERM"),
    },
    tools=[
        "default",
        "Verilate",
    ],
)
