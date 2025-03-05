# SPDX-License-Identifier: MPL-2.0
#
# types.py -- types
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from math import ceil
from typing import (
    Optional,
    Union,
)
from types import GenericAlias

BintType = Union["Bint", int]


class Bint:
    def __add__(self, x: BintType) -> "Bint":
        x = self._toBint(x)

        value = self.value + x.value

        return Bint(self._popcount(value), value)

    def __class_getitem__(cls, item: int) -> GenericAlias:
        assert isinstance(item, int)

        return GenericAlias(cls, item)

    def __eq__(self, x: BintType) -> "Bint":
        x = self._toBint(x)

        return self.value == x.value

    def __getitem__(self, item: int | slice) -> int:
        bits = f"{self.value:0{self.bits}b}"[::-1]

        return int(bits[item], 2)

    def __init__(
        self,
        bits: int,
        value: Optional[int] = None,
    ) -> None:
        assert bits > 0

        if value is None:
            value = 0

        assert value >= 0

        self._bits = bits
        self._mask = (1 << bits) - 1
        self._value = value & self._mask

    def __repr__(self) -> str:
        return f"Bint(bits={self.bits}, value=0x{self.value:0{ceil(self.bits / 4)}x})"

    def _popcount(self, x: int) -> int:
        bits = len(bin(abs(x))[2:])

        return bits

    def _toBint(self, x: BintType) -> int:
        if isinstance(x, int):
            x = Bint(self._popcount(x), x)

        return x

    @property
    def bits(self) -> int:
        return self._bits

    @property
    def mask(self) -> int:
        return self._mask

    @property
    def value(self) -> int:
        return self._value

    @value.setter
    def value(self, x: Union["Bint", int]) -> None:
        if isinstance(x, Bint):
            x = x.value

        assert x >= 0

        self._value = x & self.mask
