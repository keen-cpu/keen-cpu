# SPDX-License-Identifier: MPL-2.0
#
# SConscript.py
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

# ruff: noqa: F821

from SCons.Script import (
    Import,
    Return,
)


Import("env")

keen_register_file = env.Verilate([env.File("keen_register_file.v")])

src = [
    keen_register_file,
]

Return("src")
