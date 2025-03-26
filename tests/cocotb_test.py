# SPDX-License-Identifier: MPL-2.0
#
# cocotb_test.py -- cocotb test config
# Copyright (C) 2025  Jacob Koziej <jacobkoziej@gmail.com>

from importlib import import_module
from pathlib import Path
from typing import Final

from cocotb.runner import get_runner

PROJECT_ROOT: Final[Path] = (Path(__file__).resolve().parent / "..").resolve()

SIM: Final[str] = "icarus"

BUILD: Final[Path] = PROJECT_ROOT / "build"
INCLUDE: Final[Path] = PROJECT_ROOT / "include"
SRC: Final[Path] = PROJECT_ROOT / "src"
TESTS: Final[Path] = PROJECT_ROOT / "tests"

SOURCES: Final[Path] = list(SRC.glob("**/*.v"))


def runner(module_path: Path, test_module: str, seed: int) -> None:
    runner = get_runner(SIM)

    build_dir = BUILD / "tests" / module_path.with_suffix(".d")
    includes = [INCLUDE]
    hdl_toplevel = module_path.stem

    runner.build(
        always=True,
        build_dir=build_dir,
        hdl_toplevel=hdl_toplevel,
        includes=includes,
        sources=SOURCES,
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        seed=seed,
        test_module=test_module,
    )


_module = import_module(__name__)

for module_path in TESTS.glob("**/keen_*.py"):
    module_path = module_path.relative_to(TESTS)

    test_module = module_path.stem

    def module_runner(seed: int) -> None:
        runner(module_path, test_module, seed)

    setattr(_module, f"test_{test_module}", module_runner)
