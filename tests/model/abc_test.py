# SPDX-License-Identifier: MPL-2.0
#
# abc.py -- abstract base class tests
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import pytest

from model.abc import (
    ClockedModule,
)


class TestClockedModule:
    class Module(ClockedModule):
        def __init__(self):
            super().__init__()

            self.posedges = 0
            self.negedges = 0

        def _clk_posedge(self):
            self.posedges += 1

        def _clk_negedge(self):
            self.negedges += 1

    @pytest.fixture
    def module(self) -> Module:
        return TestClockedModule.Module()

    def test_assertions(self, module):
        with pytest.raises(AssertionError):
            module.clk = -1

        module.clk = 0
        module.clk = 1

        with pytest.raises(AssertionError):
            module.clk = 2

    def test_edges(self, module):
        assert module.posedges == 0
        assert module.negedges == 0

        module.clk = 1

        assert module.posedges == 1
        assert module.negedges == 0

        module.clk = 0

        assert module.posedges == 1
        assert module.negedges == 1

    def test_instantiate(self):
        with pytest.raises(TypeError):
            _ = ClockedModule()
