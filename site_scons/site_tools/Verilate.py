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
from SCons.Node.FS import (
    Base,
    Dir,
)
from SCons.Script.SConscript import SConsEnvironment


def Verilate(
    env: SConsEnvironment,
    sources: list[Base],
    *,
    obj_dir: Optional[Dir] = None,
    top_module: Optional[str] = None,
    **kwargs: dict[str, Any],
) -> list[Base]:
    if top_module is None:
        top_module = splitext(basename(str(sources[0])))[0]

    if obj_dir is None:
        obj_dir = env.Dir(dirname(str(sources[0]))).Dir(f"{top_module}.V")

    flags = [
        f"--Mdir {obj_dir.path}",
        f"--top-module {top_module}",
    ]

    if env["VERILATORCOMSTR"]:
        flags += [
            "--quiet",
            # sub-command output isn't supressed with `--quiet`...
            ">/dev/null",
        ]

    action = f"mkdir -p {obj_dir.path} && " + " ".join(
        [
            "$VERILATOR",
            "$_VERILATORINCFLAGS",
            "$VERILATORFLAGS",
            *flags,
            "$SOURCES",
        ]
    )
    target = obj_dir.File(f"V{top_module}.cpp")

    targets = env.Command(
        target=target,
        source=sources,
        action=Action(action, "$VERILATORCOMSTR"),
        **kwargs,
    )
    env.SideEffect(obj_dir.glob("*", exclude=target.name), targets)

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
