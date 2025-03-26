# SPDX-License-Identifier: MPL-2.0
#
# _adder.py -- carry-lookahead adder model
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>


class Adder:
    def __call__(self, a: int, b: int, c_in: int) -> tuple[int, int]:
        assert a >= 0
        assert b >= 0
        assert c_in >= 0
        assert c_in <= 1

        c = a + b + c_in

        sum = c & self.mask
        c_out = 1 if c & self.c_out else 0

        return sum, c_out

    def __init__(self, xlen: int) -> None:
        assert xlen > 0

        self.c_out = 1 << xlen
        self.mask = self.c_out - 1
