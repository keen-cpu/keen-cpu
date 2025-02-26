# SPDX-License-Identifier: MPL-2.0
#
# abc.py -- abstract base classes
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from abc import (
    ABC,
    abstractmethod,
)


class ClockedModule(ABC):
    def __init__(self) -> None:
        self._clk = 0

    @abstractmethod
    def _clk_posedge(self) -> None:
        pass

    @abstractmethod
    def _clk_negedge(self) -> None:
        pass

    @property
    def clk(self) -> int:
        return self._clk

    @clk.setter
    def clk(self, x: int) -> None:
        assert x <= 1
        assert x >= 0

        delta = x - self._clk

        if not delta:
            return

        posedge = delta > 0

        self._clk = x

        _clk = self._clk_posedge if posedge else self._clk_negedge

        _clk()

    @clk.deleter
    def clk(self) -> None:
        del self._clk
