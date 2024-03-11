#!/usr/bin/env python

from yaml import safe_load  # type: ignore
from pathlib import Path
import subprocess
from pydantic import BaseModel
import shutil
import warnings


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
    subprocess.run(
        [
            "haxe",
            "build.hxml",
            "-cp",
            f"{program_path}",
            "--lua",
            f"./target/{program_path.name}/main.lua",
        ],
        check=True,
    )
    return program_path


def deploy_by_schema(schema: Instances):
    for instance in schema.instances:
        minecraft_folder = instance.minecraft_folder.expanduser().resolve()
        if not minecraft_folder.exists():
            warnings.warn(
                f"Skipping instance `{instance.name}` as path `{minecraft_folder}` doesn't exist"
            )
        else:
            for world in instance.worlds:
                worldpath = minecraft_folder.joinpath("saves", world.name)
                if not worldpath.exists():
                    warnings.warn(f"Skipping world `{world.name}`: doesn't exist")
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


def main() -> None:
    schema = Instances.model_validate(safe_load(Path("deploy_spec.yaml").read_text()))
    deploy_by_schema(schema)


if __name__ == "__main__":
    main()
