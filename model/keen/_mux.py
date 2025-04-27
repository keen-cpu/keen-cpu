# SPDX-License-Identifier: MPL-2.0
#
# _mux.py -- two-to-one multiplexer model
# Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>


class Mux:
    def __call__(self, a: int, b: int, sel: int) -> int:
        assert a >= 0
        assert b >= 0
        assert sel >= 0
        assert sel <= 1

        out = b if sel == 1 else a

        return out

    def __init__(self, xlen: int) -> None:
        assert xlen > 0
