# SPDX-License-Identifier: MPL-2.0
#
# clocked_test.py -- clocked classes test
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

# ruff: noqa: F811

import pytest

from random import Random

from model.clocked import (
    Port,
    clocked,
)
from model.types import Bint


class TestClockedAssert:
    def test_missing_bits(self) -> None:
        with pytest.raises(AssertionError):

            @clocked
            class Module:
                x: Bint

    def test_port_disagreement(self) -> None:
        with pytest.raises(AssertionError):

            @clocked
            class Module:
                x: Bint[1] = Port(bits=2)

    def test_valid_bits(self) -> None:
        @clocked
        class Module:
            x: Bint[1]

        @clocked
        class Module:
            x: Bint = Port(bits=1)

        @clocked
        class Module:
            x: Bint[1] = Port(bits=1)


class TestClockedParameters:
    def test_init(self) -> None:
        @clocked
        class Module:
            pass

        assert "__init__" in Module.__dict__

        @clocked(init=False)
        class Module:
            pass

        assert "__init__" not in Module.__dict__

    def test_no_parameters(self) -> None:
        @clocked
        class Module:
            pass

        @clocked()
        class Module:
            pass

    def test_post_init(self) -> None:
        @clocked
        class Module:
            def __post_init__(self, x: bool = 1) -> None:
                self.x = x

        m = Module(x=2)

        assert m.x == 2

        m = Module(y=2)

        assert m.x == 1

    def test_repr(self) -> None:
        @clocked
        class Module:
            pass

        assert "__repr__" in Module.__dict__

        @clocked(repr=False)
        class Module:
            pass

        assert "__repr__" not in Module.__dict__

    def test_seed(self, seed) -> None:
        bits = 128

        @clocked(seed=seed)
        class Module:
            x: Bint[bits]

        rng = Random(seed)

        value = rng.randint(0, (1 << bits) - 1)

        m = Module()

        m.x == value


class TestClockedVariables:
    @clocked
    class Module:
        x: Bint[4]
        y: Bint[8] = Port(output=True)

        def clk_posedge(self) -> None:
            self.x += 1

        def clk_negedge(self) -> None:
            self.y += 1

    @pytest.fixture
    def module(self) -> Module:
        return self.Module()

    def test_clock(self, module: Module) -> None:
        x = module.x
        y = module.y

        module.clk = 0

        assert module.x == x
        assert module.y == y

        module.clk = 1

        assert module.x == (x + 1) & module.x.mask
        assert module.y == y

        module.clk = 0

        assert module.x == (x + 1) & module.x.mask
        assert module.y == (y + 1) & module.y.mask

    def test_read(self, module: Module) -> None:
        x = module.x
        y = module.y

        assert module.x == x
        assert module.y == y

        assert id(module.x) != id(x)
        assert id(module.y) != id(y)

    def test_write(self, module: Module) -> None:
        x = module.x

        module.x = x + 1

        assert module.x != x

        with pytest.raises(AssertionError):
            module.y = 1
