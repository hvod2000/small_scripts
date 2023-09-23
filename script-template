#!/usr/bin/env python3
"""
Aboba about aboba.

Usage: {script} [options] [PATH]

Arguments:
    PATH - Path to the file or directory with files.
           If not specified, use current directory.

Options:
    -h, --help
        Show this screen and exit.

    --verbose
        Raise verbosity level.

    -z, --zero-terminated
        Output is terminated by NUL rather than EOL.
"""
import sys
from contextlib import suppress
from pathlib import Path


def process(file: Path):
    lines = list(file.read_text().removesuffix("\n").split("\n"))
    for line in lines:
        println(line)


def main(script_name: str, *script_args: str):
    doc = __doc__.format(script=Path(script_name).name)
    args = __import__("docopt").docopt(doc, script_args)
    setattr(debug, "enabled", args["--verbose"])
    setattr(println, "eol", "\x00" if args["--zero-terminated"] else "\n")
    debug(f"Running with arguments {dict(args)!r}")
    paths = [Path(args["PATH"] or ".")]
    for path in paths:
        if path.is_dir():
            paths.extend(path.joinpath(f) for f in path.iterdir())
        elif path.is_file():
            process(path)


def println(line: object):
    print(str(line), end=getattr(println, "eol", "\n"))


def debug(msg: str):
    if getattr(debug, "enabled", False):
        print(msg)


if __name__ == "__main__":
    with suppress(KeyboardInterrupt):
        main(*sys.argv)
