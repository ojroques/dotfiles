#!/usr/bin/env python3
"""
Open a file in host Neovim instance from inside the built-in terminal.
"""

from argparse import ArgumentParser
from os import environ, execvp, path
from pynvim import attach

parser = ArgumentParser(description="Neovim remote")
parser.add_argument("file", nargs='+', help="file(s) to open")

files = [path.abspath(f).replace(' ', "\\ ") for f in parser.parse_args().file]
socket = environ.get("NVIM_LISTEN_ADDRESS", None)

if not socket:
    execvp("nvim", ["nvim"] + files)

nvim = attach("socket", path=socket)
nvim.command(f"drop {' '.join(files)}")
