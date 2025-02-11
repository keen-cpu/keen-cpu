# SPDX-License-Identifier: MPL-2.0
#
# SConstruct.py
# Copyright (C) 2024--2025  Jacob Koziej <jacobkoziej@gmail.com>

import os

from SCons.Environment import Environment
from SCons.Script import (
    ARGUMENTS,
    EnsurePythonVersion,
    EnsureSConsVersion,
    SConscript,
)
from SCons.Variables import (
    BoolVariable,
    Variables,
)

EnsureSConsVersion(4, 7, 0)
EnsurePythonVersion(3, 12)


vars = Variables("overrides.py", ARGUMENTS)

vars.AddVariables(
    BoolVariable(
        "verbose",
        help="enable verbose output",
        default=False,
    ),
)

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
    variables=vars,
)

env.AppendUnique(
    VERILATORFLAGS=" ".join(
        [
            "--cc",
            "--language 1364-2005",
            "--main",
            "--stats",
            "--stats-vars",
            "--trace",
            "-Wall",
            "-Wpedantic",
        ]
    ),
)

if not env["verbose"]:
    env.AppendUnique(
        VERILATORCOMSTR="verilator $TARGET",
    )


build = "build"

src = SConscript(
    "src/SConscript.py",
    exports=[
        "env",
    ],
    variant_dir=f"{build}/src",
)
