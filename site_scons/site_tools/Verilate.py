from os.path import (
    basename,
    dirname,
    splitext,
)
from typing import (
    Any,
    Optional,
)

from SCons.Action import Action
from SCons.Node.FS import Base
from SCons.Script.SConscript import SConsEnvironment


def Verilate(
    env: SConsEnvironment,
    sources: list[Base],
    *,
    top_module: Optional[str] = None,
    **kwargs: dict[str, Any],
) -> list[Base]:
    if top_module is None:
        top_module = splitext(basename(str(sources[0])))[0]

    obj_dir = env.Dir(dirname(str(sources[0])) + f"{top_module}.V")

    flags = [
        f"--Mdir {obj_dir}",
        f"--top-module {top_module}",
    ]

    if env["VERILATORCOMSTR"]:
        flags += ["--quiet"]

    action = " ".join(
        [
            "$VERILATOR",
            "$_VERILATORINCFLAGS",
            "$VERILATORFLAGS",
            *flags,
            "$SOURCES",
        ]
    )
    target = f"V{top_module}.cpp"

    targets = env.Command(
        target=env.File(f"{obj_dir}/{target}"),
        source=sources,
        action=Action(action, "$VERILATORCOMSTR"),
        **kwargs,
    )
    env.SideEffect(obj_dir.glob("*", exclude=target), targets)

    return targets


def generate(env: SConsEnvironment):
    if exists(env):
        return

    env["VERILATOR"] = env.get("VERILATOR", "verilator")
    env["VERILATORCOMSTR"] = env.get("VERILATORCOMSTR", "")
    env["VERILATORPATH"] = env.get("VERILATORPATH", "")
    env["_VERILATORINCFLAGS"] = (
        "${_concat(INCPREFIX, VERILATORPATH, INCSUFFIX, __env__, RDirs, TARGET, SOURCE, affect_signature=False)}"
    )

    env.AddMethod(Verilate, "Verilate")


def exists(env: SConsEnvironment):
    return env.Detect("Verilate")
