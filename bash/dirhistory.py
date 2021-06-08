#!/usr/bin/env python3

from os import environ
from pathlib import Path

DIR_HISTORY_FILE = Path(environ.get("DIR_HISTORY_FILE",
                                    "~/.dir_history")).expanduser()
DIR_HISTORY_MAX = environ.get("DIR_HISTORY_MAX", 100)


def log_dir(dir):
    if not Path.is_dir(Path(dir).expanduser()):
        return

    Path.touch(DIR_HISTORY_FILE, exist_ok=True)

    with open(DIR_HISTORY_FILE, "r+") as f:
        history = f.readlines()

        # If directory has not changed, return early
        if history and history[-1].strip() == dir:
            return

        f.seek(0)
        start = 1 - DIR_HISTORY_MAX if len(history) >= DIR_HISTORY_MAX else 0

        for d in history[start:]:
            if d.strip() != dir:
                f.write(d)

        f.write(f"{dir}\n")
        f.truncate()


def show_history():
    if not Path.is_file(DIR_HISTORY_FILE):
        return

    with open(DIR_HISTORY_FILE, "r") as f:
        for d in reversed(f.readlines()):
            print(d, end="")


if __name__ == "__main__":
    import sys

    def usage():
        print(f"Usage: {sys.argv[0]} <help|log|show> [dir]")

    def main():
        if len(sys.argv) < 2 or len(sys.argv) > 3 or sys.argv[1] == "help":
            usage()
            return

        if sys.argv[1] == "log":
            if len(sys.argv) != 3:
                usage()
            else:
                log_dir(sys.argv[2])
            return

        if sys.argv[1] == "show":
            show_history()
            return

        usage()

    main()
