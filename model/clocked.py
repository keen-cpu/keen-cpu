# SPDX-License-Identifier: MPL-2.0
#
# clocked.py -- clocked classes
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from dataclasses import (
    dataclass,
    field,
)
from inspect import (
    get_annotations,
    signature,
)
from operator import itemgetter
from random import Random
from textwrap import indent
from types import (
    FunctionType,
    GenericAlias,
)
from typing import (
    Any,
    Callable,
    Final,
    Optional,
    TypeAlias,
    get_args,
    get_origin,
)

from .types import (
    Bint,
    BintDescriptor,
)

_PREFIX: Final[str] = "_"
_CLK: Final[str] = "clk"
_CLK_EDGE_ACTIVE: Final[str] = "_clk_edge_active"
_CLOCKED_PREFIX: Final[str] = "_clocked_"
_INDENT: Final[str] = "    "


class _Clock:
    def __set_name__[T](self, owner: T, name: str) -> None:
        self.name = "_" + name

    def __get__[T](self, instance: T, owner: Optional[T] = None) -> int:
        value = getattr(instance, self.name)

        return value

    def __set__[T](self, instance: T, value: int) -> None:
        assert value <= 1
        assert value >= 0

        delta = value - getattr(instance, self.name)

        if not delta:
            return

        posedge = delta > 0

        setattr(instance, self.name, value)

        clk_edge = "posedge" if posedge else "negedge"
        clk_edge = getattr(instance, "clk_" + clk_edge, None)

        if clk_edge is None:
            return

        setattr(instance, _CLK_EDGE_ACTIVE, True)
        clk_edge()
        setattr(instance, _CLK_EDGE_ACTIVE, False)


class _ClockedOutputVariable:
    def __set_name__[T](self, owner: T, name: str) -> None:
        self.name = _CLOCKED_PREFIX + name

    def __get__[T](self, instance: T, owner: Optional[T] = None) -> Any:
        value = getattr(instance, self.name)

        return value

    def __set__[T](self, instance: T, value: Any) -> None:
        clk_edge_active = getattr(instance, _CLK_EDGE_ACTIVE)

        assert clk_edge_active

        setattr(instance, self.name, value)


class _ClockedInputVariable(_ClockedOutputVariable):
    def __set__[T](self, instance: T, value: Any) -> None:
        setattr(instance, self.name, value)


@dataclass
class Port:
    bits: Optional[int] = field(default=None, kw_only=True)
    output: bool = field(default=False, kw_only=True)


_PortDict: TypeAlias = dict[str, Port]


def _add_clk[T](cls: T) -> None:
    clk = _Clock()
    clk.__set_name__(cls, _CLK)

    setattr(cls, "clk", clk)


def _add_descriptors[T](cls: T, /, *, ports: _PortDict) -> None:
    for name, port in ports.items():
        output = port.output

        bint_descriptor = BintDescriptor()
        bint_descriptor.__set_name__(cls, name)

        clocked_descriptor = (
            _ClockedOutputVariable() if output else _ClockedInputVariable()
        )
        clocked_descriptor.__set_name__(cls, name)

        setattr(cls, clocked_descriptor.name, bint_descriptor)
        setattr(cls, name, clocked_descriptor)


def _clocked[
    T
](cls: T, /, *, init: bool, repr: bool, seed: Optional[int]) -> T:
    ports = _filter_bint(cls)

    _add_clk(cls)
    _add_descriptors(cls, ports=ports)

    if init:
        _init = _init_fn(cls, ports=ports, seed=seed)
        _set_new_attribute(cls, "__init__", _init)

    if repr:
        _repr = _repr_fn(cls, ports=ports)
        _set_new_attribute(cls, "__repr__", _repr)

    return cls


def _filter_bint[T](cls: T) -> _PortDict:
    annotations = get_annotations(cls)

    ports = {}

    for name, type in annotations.items():
        bits = None

        if isinstance(type, GenericAlias):
            if get_origin(type) is not Bint:
                continue

            bits = get_args(type)[0]

        elif type is not Bint:
            continue

        port = getattr(cls, name, Port(bits=bits))

        if bits is None:
            bits = port.bits

        elif port.bits is None:
            port.bits = bits

        assert bits is not None
        assert port.bits is not None

        assert port.bits == bits

        ports[name] = port

    return ports


def _filter_kwargs(func: Callable, kwargs: dict[str, Any]) -> dict[str, Any]:
    sig = signature(func)

    keys = sig.parameters.keys() & kwargs.keys()

    if not bool(keys):
        return {}

    vals = itemgetter(*keys)(kwargs)

    if not isinstance(vals, tuple):
        vals = (vals,)

    return dict(zip(keys, vals))


def _init_fn[
    T
](
    cls: T,
    /,
    *,
    ports: _PortDict,
    seed: Optional[int] = None,
) -> Callable[
    [T], None
]:
    def _init[T](self: T, /, **kwargs: dict[str, Any]) -> None:
        super(cls, self).__init__()

        rng = Random(seed)

        for name, port in ports.items():
            bits = port.bits
            max_value = (1 << bits) - 1

            value = rng.randint(0, max_value)

            setattr(self, _PREFIX + name, Bint(bits=bits, value=value))
            setattr(self, _PREFIX + _CLK, 0)
            setattr(self, _CLK_EDGE_ACTIVE, False)

        post_init = getattr(self, "__post_init__", None)

        if post_init is not None:
            post_init(**_filter_kwargs(post_init, kwargs))

    return _init


def _repr_fn[T](cls: T, ports: _PortDict) -> str:
    def _repr[T](self: T) -> str:
        vars = [f"clk={self.clk}"] + [
            f"{name}={repr(getattr(self, name))}" for name in ports
        ]

        vars = "\n".join([indent(var + ",", _INDENT) for var in vars])

        return f"{cls.__name__}(\n" + vars + "\n)"

    return _repr


def _set_new_attribute[T](cls: T, name: str, value: Any) -> bool:
    if name in cls.__dict__:
        return True

    _set_qualname(cls, value)
    setattr(cls, name, value)

    return False


def _set_qualname[T, U](cls: T, value: U) -> U:
    if isinstance(value, FunctionType):
        value.__qualname__ = f"{cls.__qualname__}.{value.__name__}"

    return value


def clocked[
    T
](
    cls: T = None,
    /,
    *,
    init: bool = True,
    repr: bool = True,
    seed: Optional[int] = None,
) -> T:
    def wrap(cls):
        return _clocked(cls, init=init, repr=repr, seed=seed)

    if cls is None:
        return wrap

    return wrap(cls)
