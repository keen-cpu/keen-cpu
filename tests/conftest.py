# SPDX-License-Identifier: MPL-2.0
#
# conftest.py -- top-level pytest configuration
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

import pytest

from pytest import FixtureRequest


def _seed_id(param: int):
    return f"seed=0x{param:08x}"


@pytest.fixture(
    ids=_seed_id,
    params=[
        0x626F6272,
    ],
    scope="session",
)
def seed(request: FixtureRequest) -> int:
    return request.param
