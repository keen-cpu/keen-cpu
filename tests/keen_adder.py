# SPDX-License-Identifier: MPL-2.0
#
# keen_adder.py -- carry-lookahead adder test
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import cocotb

from random import Random
from typing import Final

from cocotb.clock import Timer
from cocotb.handle import HierarchyObject
from cocotb.regression import TestFactory

from model.keen import Adder

from conftest import RANDOM_COUNT

SEED: Final[int] = cocotb.RANDOM_SEED
XLEN: Final[int] = cocotb.top.XLEN.value


def random_values() -> list[tuple[int, int]]:
    rng = Random(SEED)
    limit = 1 << XLEN

    def value():
        return rng.randrange(limit), rng.randrange(limit)

    return [value() for _ in range(RANDOM_COUNT)]


async def test_addition(
    dut: HierarchyObject,
    a: int,
    b: int,
    c_in: int,
) -> None:
    model = Adder(XLEN)

    dut.a.value = a
    dut.b.value = b
    dut.c_in.value = c_in

    await Timer(10, units="ns")

    sum, c_out = model(a, b, c_in)

    assert dut.sum.value == sum
    assert dut.c_out.value == c_out


tf: TestFactory = TestFactory(test_addition)
tf.add_option(("a", "b"), random_values())
tf.add_option("c_in", [0, 1])
tf.generate_tests()
