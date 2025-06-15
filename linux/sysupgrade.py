#!/usr/bin/env python3
import os
import sys
import subprocess
import shutil
import datetime
import re

def header(text):
    print(f"\033[7m # {datetime.datetime.now().strftime('%H:%M:%S')} - {text} \033[0m")

def text(msg):
    print(msg)

def show(*args):
    # Print command in reverse video and run it
    cmd_str = ' '.join(args)
    print(f"\033[7m # {cmd_str} \033[0m")
    subprocess.run(args, check=False)

def usage():
    # Use tput equivalent sequences for formatting
    TREVERSE = "\033[7m"
    TBOLD = "\033[1m"
    TRESET = "\033[0m"
    print(f"""{TREVERSE}{TBOLD} DESCRIPTION {TRESET}
Upgrade packages on the system

{TREVERSE}{TBOLD} SYNTAX {TRESET}
$ {os.path.basename(sys.argv[0])} <option>

{TREVERSE}{TBOLD} OPTIONS {TRESET}
1p      update apk, apt, dnf, pacman, pamac
3p      update code, docker, flatpak, pipx, snap
all     update everything
user    create user
help    show help

{TREVERSE}{TBOLD} USAGE {TRESET}
$ {os.path.basename(sys.argv[0])} all
$ {os.path.basename(sys.argv[0])} apt code docker pipx
$ {os.path.basename(sys.argv[0])} help
""")

def prompt_user(msg):
    print(msg)
    answer = input("Input: ").strip()
    if not re.match(r'^[Yy]$', answer):
        return False
    return True

def elevate_user():
    if os.geteuid() == 0:
        return ""
    for cmd in ["sudo", "sudo-rs", "doas"]:
        if shutil.which(cmd):
            return cmd
    text('no tool found for user elevation')
    text('install any one - sudo, sudo-rs, doas')
    sys.exit(1)

def run_cmd(cmd, elevate=""):
    if elevate:
        full_cmd = [elevate] + cmd
    else:
        full_cmd = cmd
    show(*full_cmd)

def create_user(elevate):
    header('create user')
    virt = ""
    if shutil.which("systemd-detect-virt"):
        virt = subprocess.getoutput("systemd-detect-virt")
    elif shutil.which("virt-what"):
        virt = subprocess.getoutput("virt-what")
    else:
        virt = ""

    if virt == "none":
        text('user setup not needed')
        return

    DKRUSER = input('Enter name: ').strip()
    try:
        with open("/etc/passwd") as f:
            if any(line.startswith(DKRUSER + ":") for line in f):
                show("getent", "passwd", DKRUSER)
                text(f"User '{DKRUSER}' already exists on this system.")
                return
    except Exception:
        pass

    # Create groups
    run_cmd(["groupadd", "--force", "--gid", "27", "sudo"], elevate)
    run_cmd(["groupadd", "--force", "--gid", "28", "wheel"], elevate)
    run_cmd(["groupadd", "--force", "--gid", "29", "adm"], elevate)

    # Create user with home and bash shell
    run_cmd(["useradd", "--create-home", "--shell", "/bin/bash", DKRUSER], elevate)
    run_cmd(["passwd", DKRUSER], elevate)

    # Add user to groups
    run_cmd(["usermod", "--append", "--groups", "sudo", DKRUSER], elevate)
    run_cmd(["usermod", "--append", "--groups", "wheel", DKRUSER], elevate)
    run_cmd(["usermod", "--append", "--groups", "adm", DKRUSER], elevate)

    # Setup sudoers file
    sudoers_content = f"""%wheel ALL=(ALL:ALL) ALL
%sudo ALL=(ALL:ALL) ALL
{DKRUSER} ALL=(ALL:ALL) ALL
"""
    run_cmd(["mkdir", "-p", "/etc/sudoers.d/"], elevate)
    proc = subprocess.run([elevate, "tee", "/etc/sudoers.d/custom"], input=sudoers_content.encode(), stdout=subprocess.DEVNULL)

    # root user shell config
    root_profile = "source /root/.bashrc\n"
    proc = subprocess.run([elevate, "tee", "/root/.profile"], input=root_profile.encode(), stdout=subprocess.DEVNULL)

    root_bashrc = """[[ "${-}" != *i* ]] && return
[[ -z "${BASH_COMPLETION_VERSINFO}" ]] && source /usr/share/bash-completion/bash_completion
PS1="\\u@\\h \\w\\n\\$ "
"""
    proc = subprocess.run([elevate, "tee", "/root/.bashrc"], input=root_bashrc.encode(), stdout=subprocess.DEVNULL)

    # user shell config
    user_profile = f"source /home/{DKRUSER}/.bashrc\n"
    proc = subprocess.run([elevate, "tee", f"/home/{DKRUSER}/.profile"], input=user_profile.encode(), stdout=subprocess.DEVNULL)

    proc = subprocess.run([elevate, "tee", f"/home/{DKRUSER}/.bashrc"], input=root_bashrc.encode(), stdout=subprocess.DEVNULL)

    # Change ownership of user shell files
    run_cmd(["chown", f"{DKRUSER}:{DKRUSER}", f"/home/{DKRUSER}/.profile"], elevate)
    run_cmd(["chown", f"{DKRUSER}:{DKRUSER}", f"/home/{DKRUSER}/.bashrc"], elevate)

    header('current users')
    run_cmd(["bash", "-c", f"{elevate} cat /etc/passwd | awk -F: '$3 == 0 || $3 >= 1000' | sort"], elevate)

    header('user details')
    # Get users with uid 0 or >= 1000
    try:
        with open("/etc/passwd") as f:
            users = [line.split(":")[0] for line in f if int(line.split(":")[2]) == 0 or int(line.split(":")[2]) >= 1000]
        for u in users:
            run_cmd(["id", u], elevate)
    except Exception:
        pass

    text(f" > sudo --user {DKRUSER} --login")

def pause_script(head, msg, prompt):
    header(head)
    print(msg)
    input(prompt)

def upgrade_apt(elevate):
    header('apt')
    if shutil.which("apt"):
        os.environ["DEBIAN_FRONTEND"] = "noninteractive"
        run_cmd(["apt", "clean"], elevate)
        run_cmd(["apt", "update"], elevate)
        run_cmd(["apt", "full-upgrade"], elevate)
        run_cmd(["apt", "install", "--assume-yes", "bash", "bash-completion", "curl", "dialog", "git", "nano", "sudo", "vim", "wget"], elevate)
        run_cmd(["apt", "purge", "--autoremove"], elevate)
    else:
        text('apt not found in PATH')

def upgrade_apk(elevate):
    header('apk')
    if shutil.which("apk"):
        run_cmd(["apk", "cache", "clean"], elevate)
        run_cmd(["apk", "update"], elevate)
        run_cmd(["apk", "upgrade", "--progress"], elevate)
        run_cmd(["apk", "add", "bash", "bash-completion", "curl", "wget", "ncurses", "git", "nano", "sudo", "shadow", "vim", "virt-what"], elevate)
    else:
        text('apk not found in PATH')

def upgrade_dnf(elevate):
    header('dnf')
    if shutil.which("dnf"):
        run_cmd(["dnf", "clean", "all"], elevate)
        run_cmd(["dnf", "upgrade", "--refresh", "--assumeyes"], elevate)
        run_cmd(["dnf", "install", "--assumeyes", "bash", "bash-completion", "curl", "wget", "ncurses", "git", "nano", "procps-ng", "vim", "xclip"], elevate)
        run_cmd(["dnf", "autoremove"], elevate)
    else:
        text('dnf not found in PATH')

def upgrade_pacman(elevate):
    header('pacman')
    if shutil.which("pacman"):
        text('pacman found in PATH')
        header('pacman.conf')
        try:
            mtime = os.path.getmtime("/etc/pacman.conf")
            if (datetime.datetime.now() - datetime.datetime.fromtimestamp(mtime)).total_seconds() > 3600:
                text('/etc/pacman.conf was modified more than 60 minutes ago.')
                pacman_conf = """[options]
Architecture = x86_64
HoldPkg = pacman glibc
ParallelDownloads = 8
LocalFileSigLevel = Optional
SigLevel = Required DatabaseOptional
#DownloadUser = alpm
DisableSandbox
#CheckSpace
Color
ILoveCandy
VerbosePkgLists

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

#[endeavouros]
#Include = /etc/pacman.d/endeavouros-mirrorlist
#SigLevel = PackageRequired

#[chaotic-aur]
#Include = /etc/pacman.d/chaotic-mirrorlist
"""
                proc = subprocess.run([elevate, "tee", "/etc/pacman.conf"], input=pacman_conf.encode(), stdout=subprocess.DEVNULL)
            else:
                text('/etc/pacman.conf was modified less than 60 minutes ago.')
                text('using existing pacman.conf')
        except Exception:
            text('/etc/pacman.conf not found or error reading.')

        header('pacman cache')
        run_cmd(["find", "/var/cache/pacman/pkg/", "-mindepth", "1", "-exec", "rm", "-f", "{}", ";"], elevate)
        run_cmd(["find", "/var/lib/pacman/sync/", "-mindepth", "1", "-exec", "rm", "-f", "{}", ";"], elevate)

        header('pacman update')
        run_cmd(["pacman", "-Syyu", "--needed", "--noconfirm"], elevate)

        header('reflector')
        if shutil.which("reflector"):
            try:
                mtime = os.path.getmtime("/etc/pacman.d/mirrorlist")
                if (datetime.datetime.now() - datetime.datetime.fromtimestamp(mtime)).total_seconds() > 3600:
                    text('/etc/pacman.d/mirrorlist was modified more than 60 minutes ago.')
                    run_cmd(["reflector", "--verbose", "--ipv4", "--latest", "5", "--sort", "rate", "--save", "/etc/pacman.d/mirrorlist"], elevate)
                else:
                    text('/etc/pacman.d/mirrorlist was modified less than 60 minutes ago.')
                    text('using existing /etc/pacman.d/mirrorlist')
            except Exception:
                text('Could not check /etc/pacman.d/mirrorlist modification time.')
        else:
            text('reflector is not available for this distribution')

        header('pacman packages')
        run_cmd(["pacman", "-Syu", "--needed", "--noconfirm", "base-devel", "bash", "bash-completion", "curl", "git", "micro", "pacman-contrib", "sudo", "wget"], elevate)

        header('yay')
        if shutil.which("yay"):
            text('yay is already installed.')
        else:
            run_cmd(["rm", "-fr", "/tmp/yay-bin"])
            run_cmd(["git", "clone", "--depth=1", "https://aur.archlinux.org/yay-bin.git", "/tmp/yay-bin"])
            run_cmd(["cp", "-f", "/etc/makepkg.conf", "/etc/makepkg.conf.bak"])
            subprocess.run(["sed", "-i", "/^OPTIONS=(/s/ *debug//", "/etc/makepkg.conf"])
            run_cmd(["cp", "-f", "/usr/sbin/makepkg", "/usr/sbin/makepkg.bak"])
            subprocess.run(["sed", "-i", "/exit \\$E_ROOT/ s/^/#/g", "/usr/sbin/makepkg"])
            run_cmd(["makepkg", "--dir", "/tmp/yay-bin", "--syncdeps", "--install", "--needed", "--noconfirm"])

        header('pacman *.pacnew *.pacsave')
        run_cmd(["find", "/etc", "-name", "*.pacnew"], elevate)
        run_cmd(["find", "/etc", "-name", "*.pacsave"], elevate)
    else:
        text('pacman not found in PATH')

def upgrade_pamac(elevate):
    header('pamac')
    if shutil.which("pamac"):
        text('pamac found in PATH')
        header('pacman.conf')
        try:
            mtime = os.path.getmtime("/etc/pamac.conf")
            if (datetime.datetime.now() - datetime.datetime.fromtimestamp(mtime)).total_seconds() > 3600:
                text('/etc/pamac.conf was modified more than 60 minutes ago.')
                pamac_conf = """#CheckAURUpdates
#CheckAURVCSUpdates
#CheckFlatpakUpdates
#DownloadUpdates
#EnableFlatpak
#EnableSnap
#KeepBuiltPkgs
#OfflineUpgrade
#OnlyRmUninstalled
#SimpleInstall
BuildDirectory = /var/tmp
EnableAUR
EnableDowngrade
KeepNumPackages = 1
MaxParallelDownloads = 8
NoUpdateHideIcon
RefreshPeriod = 0
RemoveUnrequiredDeps
"""
                proc = subprocess.run([elevate, "tee", "/etc/pamac.conf"], input=pamac_conf.encode(), stdout=subprocess.DEVNULL)
            else:
                text('/etc/pamac.conf was modified less than 60 minutes ago.')
                text('using existing /etc/pamac.conf')
        except Exception:
            text('/etc/pamac.conf not found or error reading.')

        header('pamac cache')
        run_cmd(["pamac", "clean", "--no-confirm", "--keep", "0", "--verbose"])

        header('pamac mirrors')
        try:
            mtime = os.path.getmtime("/etc/pacman.d/mirrorlist")
            if (datetime.datetime.now() - datetime.datetime.fromtimestamp(mtime)).total_seconds() > 3600:
                text('/etc/pacman.d/mirrorlist was modified more than 60 minutes ago.')
                mirrorlist = """Server = https://mirrors.manjaro.org/repo/stable/$repo/$arch
Server = https://mirrors2.manjaro.org/stable/$repo/$arch
Server = http://mirror.xeonbd.com/manjaro/$repo/$arch
"""
                proc = subprocess.run([elevate, "tee", "/etc/pacman.d/mirrorlist"], input=mirrorlist.encode(), stdout=subprocess.DEVNULL)
            else:
                text('/etc/pacman.d/mirrorlist was modified less than 60 minutes ago.')
                text('using existing /etc/pacman.d/mirrorlist')
        except Exception:
            text('Could not check /etc/pacman.d/mirrorlist modification time.')

        header('pamac update')
        run_cmd(["pamac", "upgrade", "--force-refresh", "--no-confirm", "--no-aur"])

        header('pacman packages')
        run_cmd(["pamac", "install", "--no-confirm", "base-devel", "bash", "bash-completion", "curl", "git", "micro", "pacman-contrib", "sudo", "wget"])

        header('yay')
        if shutil.which("yay"):
            text('yay is already installed.')
        else:
            run_cmd(["pamac", "install", "yay"])

        header('pacman *.pacnew *.pacsave')
        run_cmd(["find", "/etc", "-name", "*.pacnew"], elevate)
        run_cmd(["find", "/etc", "-name", "*.pacsave"], elevate)
    else:
        text('pacman not found in PATH')

def upgrade_snap(elevate):
    if shutil.which("snap"):
        header('snap')
        run_cmd(["snap", "refresh"], elevate)
        run_cmd(["snap", "refresh", "--hold"], elevate)
        run_cmd(["snap", "set", "system", "snapshots.automatic.retention=no"], elevate)
        # Remove disabled snaps
        proc = subprocess.Popen([elevate, "snap", "list", "--all", "--unicode=never", "--color=never"], stdout=subprocess.PIPE, text=True)
        for line in proc.stdout:
            parts = line.strip().split()
            if len(parts) >= 6:
                name, version, revision, tracking, publisher, notes = parts[:6]
                if "disabled" in notes:
                    print(f"{name} {version} {tracking} {publisher} {notes}")
                    run_cmd(["snap", "remove", "--purge", name, f"--revision={revision}"], elevate)
        proc.stdout.close()
        proc.wait()

def upgrade_flatpak(elevate):
    if shutil.which("flatpak"):
        header('flatpak')
        run_cmd(["flatpak", "--user", "update", "--appstream", "--assumeyes"])
        run_cmd(["flatpak", "--user", "update", "--assumeyes"])
        run_cmd(["flatpak", "--user", "uninstall", "--unused", "--delete-data", "--assumeyes"])
        run_cmd(["flatpak", "--system", "update", "--appstream", "--assumeyes"])
        run_cmd(["flatpak", "--system", "update", "--assumeyes"])
        run_cmd(["flatpak", "--system", "uninstall", "--unused", "--delete-data", "--assumeyes"])

def upgrade_code(elevate):
    if shutil.which("code"):
        header('code')
        run_cmd(["code", "--list-extensions"])
        run_cmd(["code", "--update-extensions"])

def upgrade_docker(elevate):
    if shutil.which("docker"):
        header('docker')
        run_cmd(["docker", "images", "--format", "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"])
        os.environ["DOCKER_CLI_HINTS"] = "false"
        proc = subprocess.Popen(["docker", "images", "--format", "{{.Repository}}:{{.Tag}}"], stdout=subprocess.PIPE, text=True)
        for img in proc.stdout:
            img = img.strip()
            if img:
                run_cmd(["docker", "pull", img], elevate)
        proc.stdout.close()
        proc.wait()

def upgrade_pipx(elevate):
    if shutil.which("pipx"):
        header('pipx')
        run_cmd(["pipx", "list", "--short"])
        run_cmd(["pipx", "upgrade-all"])

def set_shell():
    virt = ""
    if shutil.which("systemd-detect-virt"):
        virt = subprocess.getoutput("systemd-detect-virt")
    elif shutil.which("virt-what"):
        virt = subprocess.getoutput("virt-what")
    else:
        virt = ""

    header('bash')
    if virt == "none":
        text('shell setup not needed')
    else:
        text('bash; source /usr/share/bash-completion/bash_completion; PS1="\\u@\\h \\w\\n\\$ "')

def upgrade_1p(elevate):
    upgrade_apk(elevate)
    upgrade_apt(elevate)
    upgrade_dnf(elevate)
    upgrade_pacman(elevate)
    upgrade_pamac(elevate)

def upgrade_3p(elevate):
    upgrade_snap(elevate)
    upgrade_flatpak(elevate)
    upgrade_code(elevate)
    upgrade_docker(elevate)
    upgrade_pipx(elevate)

def upgrade_all(elevate):
    upgrade_1p(elevate)
    upgrade_3p(elevate)

def handle_arguments(args, elevate):
    if len(args) == 0:
        usage()
        sys.exit(1)

    unique_args = []
    for arg in args:
        if arg not in unique_args:
            unique_args.append(arg)

    upgrade_all_executed = False

    for arg in unique_args:
        if arg == "all":
            if not upgrade_all_executed:
                upgrade_all(elevate)
                upgrade_all_executed = True
        elif arg == "1p":
            upgrade_1p(elevate)
        elif arg == "3p":
            upgrade_3p(elevate)
        elif arg == "apk":
            upgrade_apk(elevate)
        elif arg == "apt":
            upgrade_apt(elevate)
        elif arg == "code":
            upgrade_code(elevate)
        elif arg == "dnf":
            upgrade_dnf(elevate)
        elif arg == "docker":
            upgrade_docker(elevate)
        elif arg == "flatpak":
            upgrade_flatpak(elevate)
        elif arg == "pacman":
            upgrade_pacman(elevate)
        elif arg == "pamac":
            upgrade_pamac(elevate)
        elif arg == "pipx":
            upgrade_pipx(elevate)
        elif arg == "snap":
            upgrade_snap(elevate)
        elif arg == "user":
            create_user(elevate)
        elif arg == "help":
            usage()
            sys.exit(0)
        else:
            usage()
            sys.exit(1)

def main():
    elevate = elevate_user()
    handle_arguments(sys.argv[1:], elevate)

if __name__ == "__main__":
    main()
