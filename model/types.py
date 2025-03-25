# SPDX-License-Identifier: MPL-2.0
#
# types.py -- types
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from copy import deepcopy
from math import ceil
from typing import (
    Optional,
    Union,
)
from types import GenericAlias

BintType = Union["Bint", int]


class Bint:
    def __add__(self, x: BintType) -> "Bint":
        return self._operator(x, "__add__")

    def __and__(self, x: BintType) -> "Bint":
        return self._operator(x, "__and__")

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

    def _operator(self, x: BintType, operator: str) -> "Bint":
        x = self._toBint(x)

        operator = getattr(int, operator)

        value = operator(self.value, x.value)

        bits = max(Bint.clog2(value), self.bits, x.bits)

        return Bint(bits, value)

    def _toBint(self, x: BintType) -> int:
        if isinstance(x, int):
            x = Bint(Bint.clog2(x), x)

        return x

    @staticmethod
    def clog2(x: BintType) -> int:
        if isinstance(x, Bint):
            x = x.value

        if not x:
            return 1

        return x.bit_length()

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


class BintDescriptor:
    def __set_name__(self, owner: Bint, name: str) -> None:
        self.name = "_" + name

    def __get__(self, instance: Bint, owner: Optional[Bint] = None) -> Bint:
        value = getattr(instance, self.name)

        return deepcopy(value)

    def __set__(self, instance: Bint, value: BintType) -> None:
        bint = getattr(instance, self.name)

        bint.value = value
