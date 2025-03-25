# SPDX-License-Identifier: MPL-2.0
#
# program_counter_test.py -- program counter model test
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import pytest

from conftest import iterable_fixture
from model.keen.program_counter import ProgramCounter


class TestProgramCounter:
    @pytest.fixture(scope="class")
    def branch_address(self) -> list[int]:
        pass

    @pytest.fixture
    def dut(self) -> ProgramCounter:
        return ProgramCounter()

    @pytest.fixture(autouse=True)
    def reset(self, dut) -> None:
        dut.reset = 1
        dut.branch = 0

        dut.clk = 1
        dut.clk = 0

        dut.reset = 0

    def test_nominal(self, dut: ProgramCounter) -> None:
        past_pc = dut.pc

        dut.clk = 1
        dut.clk = 0

        assert dut.pc == (past_pc + dut.localparams.IALIGN) & dut.pc.mask

    @iterable_fixture("branch_address")
    def test_branch(self, dut: ProgramCounter, branch_address: int) -> None:
        dut.branch_address = 0x1738 & ~(dut.localparams.IALIGN - 1)

        # dut.bran

    def test_reset(self, dut: ProgramCounter) -> None:
        assert dut.pc == dut.parameters.RESET_VECTOR
