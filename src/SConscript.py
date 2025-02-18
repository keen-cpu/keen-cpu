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

keen_program_counter = env.Verilate([env.File("keen_program_counter.v")])
keen_register_file = env.Verilate([env.File("keen_register_file.v")])
keen_sign_extender = env.Verilate([env.File("keen_sign_extender.v")])

src = [
    keen_program_counter,
    keen_register_file,
    keen_sign_extender,
]

Return("src")
