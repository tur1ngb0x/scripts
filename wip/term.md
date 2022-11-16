Terminal Emulator
- It is called "emulator" as it emulates the legacy mechanical terminals.
- It is a program/application window that is loaded on the screen.
- Official apps: gnome-terminal, xfce4-terminal, konsole, xterm, uxterm, etc.
- Third party apps: alacritty, kitty, terminator, tilix, st, etc.
- You can install and use different terminal apps on the same OS.

Shell
- Program which interprets commands typed by the user and shows the result.
- Type "echo $0" "echo $SHELL" in terminal to check your current shell.
- You can install and use different shell programs on the same OS.
- Type "builtin" and press tab in terminal to view builtin commands into the bash shell.
- Every shell has system-wide and user-specific configuration files which can be customized.
- Standard Shells: sh, bash.
- Custom Shells: zsh, fish, oil.
- A shell can be either login or non-login.
- Login shell is started when a user logs into the system.
- Non-login shell is started when a application/program launches a shell.
- A shell can be either interactive or non-interacrive.
- Interactive shell is where user interacts directly eg. typing commands in TTY or terminal.
- Non-interactive shell is where user interacts indirectly eg. a script containing commands.

Command Line Interface (CLI)
- Interface where you interact with computers using lines of text instead of using GUI.
- It is generally done using a TTY interface or via terminal app.
- Updating system using CLI: $ sudo apt-get update && sudo apt-get dist-upgrade
- Launch nemo file manager using CLI: $ nemo

Prompt
- The text that you see when you open terminal.
- By default it should show [username]@[hostname][directory][:][prompt sign]
- Username : The name of the current user logged in.
- Hostname : The name of the computer user logged into.
- Directory : The path the user is currently in. "~" is the home directory of the current user.
- Prompt Sign : It shows "$" for non-root user and "#" for root user.
- Example: galileo@physics:~$
- User "galileo" is current logged into machine "physics" and is currently inside "home" directory
- Example: antoine@chemistry:/home/Downloads$
- User "antoine" is current logged into machine "chemistry" and is currently inside "/home/Downloads" directory
- Example: root@linux:/usr/bin#
- User "root" is current logged into machine "linux" and is currently inside "/usr/bin." directory
- You can customize your prompt to add features such as date, time, git status, exit status, newline, custom prompt sign, etc.
