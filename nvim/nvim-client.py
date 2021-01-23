#!/usr/bin/env python3
"""
Open a file from inside a Neovim terminal in parent Neovim instance.
"""

from argparse import ArgumentParser
from os import environ, execvp, path
from pynvim import attach

parser = ArgumentParser(description="Neovim client")
parser.add_argument("file", nargs='+', help="file(s) to open")

files = [path.abspath(f).replace(' ', "\\ ") for f in parser.parse_args().file]
socket = environ.get("NVIM_LISTEN_ADDRESS", None)

if socket:
    nvim = attach("socket", path=socket)
    nvim.command(f"drop {' '.join(files)}")
else:
    execvp("nvim", ["nvim"] + files)
