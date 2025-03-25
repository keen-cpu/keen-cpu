# SPDX-License-Identifier: MPL-2.0
#
# keen_program_counter.py -- program counter test
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import cocotb

from cocotb.clock import Clock
from cocotb.handle import HierarchyObject

from model.keen.program_counter import ProgramCounter


@cocotb.test
async def foo(dut: HierarchyObject) -> None:
    # from remote_pdb import RemotePdb; rpdb = RemotePdb("127.0.0.1", 4000)
    # rpdb.set_trace()
    assert True
