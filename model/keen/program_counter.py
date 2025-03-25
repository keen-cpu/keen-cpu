# SPDX-License-Identifier: MPL-2.0
#
# program_counter.py -- program counter model
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from dataclasses import (
    dataclass,
    replace,
)
from typing import Optional

from ..types import Bint
from ..clocked import (
    Port,
    clocked,
)


@clocked
class ProgramCounter:
    @dataclass(frozen=True)
    class Parameters:
        XLEN: int = 32
        ILEN: int = 32
        RESET_VECTOR: int = 0x8000_0000

    @dataclass(frozen=True)
    class LocalParams:
        IALIGN: Optional[int] = None

    reset: Bint[1]
    branch: Bint[1]
    branch_address: Bint

    pc: Bint = Port(output=True)

    def __parameter_init__(self) -> None:
        XLEN = self.parameters.XLEN

        self.ports.branch_address.bits = XLEN
        self.ports.pc.bits = XLEN

        ILEN = self.parameters.ILEN

        self.localparams = replace(
            self.localparams,
            IALIGN=ILEN // 8,
        )

    def clk_posedge(self) -> None:
        if self.reset == 1:
            self.pc = self.parameters.RESET_VECTOR

            return

        IALIGN = self.localparams.IALIGN

        self.pc = (
            (self.pc + IALIGN) if self.branch == 0 else self.branch_address
        )
