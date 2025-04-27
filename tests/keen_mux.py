# SPDX-License-Identifier: MPL-2.0
#
# keen_mux.py -- two-to-one multiplexer test
# Copyright (C) 2025  Andy Jaku <andyjaku13@gmail.com>

import cocotb

from random import Random
from typing import Final

from cocotb.clock import Timer
from cocotb.handle import HierarchyObject
from cocotb.regression import TestFactory

from model.keen import Mux

from conftest import RANDOM_COUNT

SEED: Final[int] = cocotb.RANDOM_SEED
XLEN: Final[int] = cocotb.top.XLEN.value


def random_values() -> list[tuple[int, int]]:
    rng = Random(SEED)
    limit = 1 << XLEN

    def value():
        return rng.randrange(limit), rng.randrange(limit)

    return [value() for _ in range(RANDOM_COUNT)]


async def test_selection(
    dut: HierarchyObject,
    a: int,
    b: int,
    sel: int,
) -> None:
    model = Mux(XLEN)

    dut.a.value = a
    dut.b.value = b
    dut.sel.value = sel

    await Timer(10, units="ns")

    out = model(a, b, sel)

    assert dut.out.value == out


tf: TestFactory = TestFactory(test_selection)
tf.add_option(("a", "b"), random_values())
tf.add_option("sel", [0, 1])
tf.generate_tests()
