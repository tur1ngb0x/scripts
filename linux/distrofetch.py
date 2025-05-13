#!/usr/bin/env python3

import os
import platform
import subprocess
import sys


def usage():
    print(
        """
DESCRIPTION
    Show distribution information using pure Python
SYNTAX
    script.py <option>
OPTIONS
    --long, -long, long, --l, -l, l       use long format (default)
    --short, -short, short, --s, -s, s    use short format
    --help, -help, help, --h, -h, h       show help
USAGE
    script.py
    script.py -s
"""
    )


def run_command(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except Exception:
        return "-"


def row(name, value):
    print(f"{name:>9} : {value}")


def separator():
    print(f"*" * 60)


def get_user():
    return run_command("id -un")


def get_host():
    return run_command("hostname -f")


def get_now():
    return run_command("date +'%Y %B %-d %A %H:%M:%S %Z'")


def get_hardware():
    vendor = run_command("cat /sys/devices/virtual/dmi/id/sys_vendor")
    product = run_command("cat /sys/devices/virtual/dmi/id/product_name")
    return f"{vendor} {product}" if vendor != "-" and product != "-" else "-"


def get_distro():
    try:
        with open("/etc/os-release") as f:
            for line in f:
                if line.startswith("PRETTY_NAME="):
                    return line.strip().split("=")[1].strip('"')
    except:
        return "-"
    return "-"


def get_kernel():
    return platform.release()


def get_display():
    tty = run_command("tty")
    if "tty" in tty:
        return "-"
    xrandr = run_command(
        "xrandr | awk '/connected primary/{getline; print $1\"@\"$2}' | sed 's/\\..*//'"
    )
    return xrandr if xrandr else "-"


def get_desktop():
    return (
        f"{os.environ.get('XDG_CURRENT_DESKTOP', '-')}"
        + "@"
        + f"{os.environ.get('XDG_SESSION_TYPE', '-')}"
    )


def get_ram():
    return run_command('free --mebi | awk \'FNR == 2 {print $3"MiB / "$2"MiB"}\'')


def get_swap():
    return run_command('free --mebi | awk \'FNR == 3 {print $3"MiB / "$2"MiB"}\'')


def get_uptime():
    return run_command(
        "uptime -p | sed 's/up //g; s/,//g; s/ hours/hr/g; s/ hour/hr/g; s/ minutes/min/g'"
    )


def get_packages():
    counts = []
    pkg_managers = {
        "dpkg": "dpkg --list | grep -c '^ii'",
        "dnf": "dnf list --installed | grep -c ''",
        "pacman": "pacman -Qq | wc -l",
        "flatpak": "flatpak list --all | wc -l",
        "snap": "snap list --all | wc -l",
        "docker": "docker images --format '{{.Repository}}' | wc -l",
        "pipx": "pipx list --short | wc -l",
    }
    for pm, cmd in pkg_managers.items():
        if run_command(f"command -v {pm}") != "-":
            count = run_command(cmd)
            counts.append(f"{count}({pm})")
    return " ".join(counts)


def get_shell():
    return os.environ.get("SHELL", "-")


def get_colors():
    for i in range(16):
        print(f"\033[48;5;{i}m    \033[0m", end=" ")
    print(f"")


def fetch_short():
    print(f" distro : ", get_distro().lower())
    print(f" kernel : ", get_kernel().lower())
    print(f" memory : ", run_command("free --mebi | awk 'FNR == 2 {print $3\"MiB\"}'").lower())
    print(f" uptime : ", get_uptime().lower())


def fetch_long():
    get_colors()
    row("Hardware", get_hardware())
    row("Distro", get_distro())
    row("Kernel", get_kernel())
    row("Display", get_display())
    row("Desktop", get_desktop())
    row("RAM", get_ram())
    row("Swap", get_swap())
    row("Uptime", get_uptime())
    row("Shell", get_shell())
    row("Packages", get_packages())
    get_colors()


def main():
    if len(sys.argv) < 2:
        fetch_long()
        return

    option = sys.argv[1].lower()
    if option in ["--help", "-help", "help", "--h", "-h", "h"]:
        usage()
    elif option in ["--short", "-short", "short", "--s", "-s", "s"]:
        fetch_short()
    else:
        fetch_long()


if __name__ == "__main__":
    main()
