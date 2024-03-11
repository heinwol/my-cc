#!/usr/bin/env python

from functools import reduce
import json
from typing import Annotated
from yaml import safe_load  # type: ignore
from pathlib import Path
import subprocess
from pydantic import BaseModel
import shutil
import warnings
import typer


class World(BaseModel):
    name: str
    programs_computers: dict[str, list[int | str]]


class Instance(BaseModel):
    name: str
    minecraft_folder: Path
    worlds: list[World]


class Instances(BaseModel):
    instances: list[Instance]


def assert_path_exists(path: Path | str) -> None:
    p = Path(path)
    if not p.exists():
        raise ValueError(f"path doesn't exist: {p}")


def compile_program(name: str) -> Path:
    program_path = Path("./src/programs").joinpath(name)
    assert_path_exists(program_path)
    config = Path("build.hxml").read_text().split("\n")
    config = filter(lambda s: not (s.startswith("--lua") or len(s) == 0), config)
    config = reduce(lambda acc, s: acc + s.split(), config, [])
    subprocess.run(
        ["haxe"]
        + config
        + [
            "-cp",
            f"{program_path}",
            "--lua",
            f"./target/{program_path.name}/main.lua",
        ],
        check=True,
    )
    return program_path


def deploy_by_schema(spec: Instances):
    for instance in spec.instances:
        minecraft_folder = instance.minecraft_folder.expanduser().resolve()
        if not minecraft_folder.exists():
            warnings.warn(
                f"Skipping instance `{instance.name}` as path `{minecraft_folder}` doesn't exist",
            )
        else:
            for world in instance.worlds:
                worldpath = minecraft_folder.joinpath("saves", world.name)
                if not worldpath.exists():
                    warnings.warn(
                        f"Skipping world `{world.name}`: doesn't exist",
                    )
                    print("lala")
                else:
                    for program_name, computers in world.programs_computers.items():
                        compile_program(program_name)
                        for computer in computers:
                            computer_path = worldpath.joinpath(
                                "computercraft", "computer", str(computer)
                            )
                            computer_path.mkdir(parents=True, exist_ok=True)
                            shutil.copy(
                                f"./target/{program_name}/main.lua",
                                f"{computer_path}/startup.lua",
                            )


def main(
    deploy_spec: Annotated[
        Path,
        typer.Argument(help="specification file to use"),
    ] = Path("deploy.mhsc.yaml"),
    generate_schema: Annotated[
        bool, typer.Option(help="don't compile anything; generate the schema instead")
    ] = False,
) -> None:
    if not generate_schema:
        spec = Instances.model_validate(safe_load(deploy_spec.read_text()))
        deploy_by_schema(spec)
    else:
        Path("mhsc.json").write_text(
            json.dumps(Instances.model_json_schema(), indent=2) + "\n"
        )


if __name__ == "__main__":
    typer.run(main)
