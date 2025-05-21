#!/usr/bin/env bash



# set screenshot tool
ss_tools=("gnome-screenshot" "xfce4-screenshooter" "spectacle" "scrot")
ss_tool=""
for tool in "${ss_tools[@]}"; do
    if command -v "${tool}" &> /dev/null; then
        ss_tool="${tool}"
        break  # if tool is found, exit loop
    fi
done



# exit if no screenshot tool found
if [[ -z "${ss_tool}" ]]; then
    printf '%s\n%s\n' "No screenshot tool found." "Install any one from these: ${ss_tools[*]}"
    exit 1
fi



# set screenshot command
ss_dir="${HOME}/Pictures/screenshot.sh"
ss_timestamp="$(date +'%Y%m%d-%H%M%S')"
ss_filestamp="ss-${ss_timestamp}"
ss_file="${ss_dir}/${ss_filestamp}.png"
ss_log="/tmp/${ss_filestamp}.log"
case "${ss_tool}" in
    "gnome-screenshot")		ss_cmd="gnome-screenshot --area --clipboard --file ${ss_file}" ;;
    "xfce4-screenshooter")	ss_cmd="xfce4-screenshooter --region --clipboard --save ${ss_file}" ;;
    "spectacle")			ss_cmd="spectacle --background --nonotify --region --copy-image --output ${ss_file}" ;;
    "scrot")				ss_cmd="scrot --compression 0 --quality 100 --select --freeze --file ${ss_file}" ;;
esac



# create screenshot directory
if [[ ! -d "${ss_dir}" ]]; then
    mkdir -pv "${ss_dir}"
fi



# capture screenshot
printf '%s\n' "${ss_cmd}"
(eval "${ss_cmd}") &> "${ss_log}"
printf 'file\t%s\nlog\t%s\n' "${ss_file}" "${ss_log}"



# set keybinding
function set_ss_gnome () {
	# register keybinding
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
		"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

	# set keybinding
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
		name 'screenshot.sh'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
		command "bash -c '$(command -p which screenshot.sh)'"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
		binding '<Shift><Super>s'
}
