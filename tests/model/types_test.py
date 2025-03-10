# SPDX-License-Identifier: MPL-2.0
#
# types_test.py -- types tests
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import pytest

from typing import Final
from random import Random

from conftest import iterable_fixture

from model.types import (
    Bint,
    BintDescriptor,
)

BITS_MAX: Final[int] = 128
VALUE_MAX: Final[int] = (1 << BITS_MAX) - 1


@pytest.fixture(scope="module")
def bits(seed, random_count) -> list[int]:
    rng = Random(seed)

    return [rng.randint(1, BITS_MAX) for _ in range(random_count)]


@pytest.fixture(scope="module")
def mask(bits) -> list[int]:
    return [(1 << bits) - 1 for bits in bits]


@pytest.fixture(scope="module")
def value(seed, random_count) -> list[int]:
    rng = Random(seed)

    return [rng.randint(0, VALUE_MAX) for _ in range(random_count)]


@pytest.fixture(scope="module")
def a(seed, random_count) -> list[int]:
    rng = Random(seed + 1)

    return [rng.randint(0, VALUE_MAX) for _ in range(random_count)]


@pytest.fixture(scope="module")
def b(seed, random_count) -> list[int]:
    rng = Random(seed + 2)

    return [rng.randint(0, VALUE_MAX) for _ in range(random_count)]


class TestBint:
    @iterable_fixture("bits", "a", "b")
    def test_add(self, bits: int, a: int, b: int) -> None:
        a = Bint(bits, a)

        result = a + b

        assert isinstance(result, Bint)
        assert result.value == (a.value + b) & result.mask

        b = Bint(bits, b)

        result = a + b

        assert isinstance(result, Bint)
        assert result.value == (a.value + b.value) & result.mask

    @iterable_fixture("bits", "a", "b")
    def test_and(self, bits: int, a: int, b: int) -> None:
        a = Bint(bits, a)

        result = a & b

        assert isinstance(result, Bint)
        assert result.value == (a.value & b) & result.mask

        b = Bint(bits, b)

        result = a & b

        assert isinstance(result, Bint)
        assert result.value == (a.value & b.value) & result.mask

    @iterable_fixture("bits")
    def test_class_getitem(self, bits: int) -> None:
        if not bits % 2:
            with pytest.raises(AssertionError):
                _ = Bint[None]

            return

        b = Bint[bits]

        assert b.__args__[0] == bits

    @iterable_fixture("bits", "value")
    def test_eq(self, bits: int, value: int) -> None:
        a = Bint(bits, value)
        b = Bint(bits, value)

        assert a == b

    @iterable_fixture("bits", "value")
    def test_getitem(self, bits: int, value: int) -> None:
        b = Bint(bits, value)

        for i in range(bits):
            assert b[i] == (1 if (b.value & (1 << i)) else 0)

    @iterable_fixture("bits", "value")
    def test_init_assert(self, bits: int, value: int) -> None:
        bit_offset = BITS_MAX // 2
        value_offset = ((1 << BITS_MAX) - 1) // 2

        bits -= bit_offset
        value -= value_offset

        if (bits > 0) and (value >= 0):
            _ = Bint(bits, value)
            return

        with pytest.raises(AssertionError):
            _ = Bint(bits, value)

    @iterable_fixture("bits", "value")
    def test_repr(self, bits: int, value: int) -> None:
        b = Bint(bits, value)

        original = repr(b)

        b.value = value - 1

        assert original != repr(b)

    @iterable_fixture("value")
    def test_clog2(self, value: int) -> None:
        assert Bint.clog2(value) == len(bin(abs(value))[2:])

    @iterable_fixture("bits")
    def test_bits(self, bits: int) -> None:
        b = Bint(bits)

        assert b.bits == bits

        with pytest.raises(AttributeError):
            b.bits = 0

    @iterable_fixture("bits", "mask")
    def test_mask(self, bits: int, mask: int) -> None:
        b = Bint(bits)

        assert b.mask == mask

        with pytest.raises(AttributeError):
            b.mask = 0

    @iterable_fixture("bits", "mask", "value")
    def test_value(self, bits: int, mask: int, value: int) -> None:
        b = Bint(bits, value)

        assert b.value == (value & mask)

        value -= 17

        b.value = value

        assert b.value == (value & mask)

        with pytest.raises(AssertionError):
            b.value = -1


class TestBintDescriptor:
    class Module:
        x = BintDescriptor()

        def __init__(self) -> None:
            self._x = Bint(bits=2)

    @pytest.fixture
    def module(self) -> Module:
        return self.Module()

    def test_get(self, module: Module) -> None:
        x = module.x

        assert id(x) != module._x

    def test_set(self, module: Module) -> None:
        x = module.x

        module.x += 1

        assert module.x == x + 1
