# git
sudo apt-add-repository -yn ppa:git-core/ppa
sudo apt-get update && sudo apt-get install --install-recommends -y git

# system76-power
cat << EOF | sudo tee /etc/apt/preferences.d/system76-dev-stable.pref
Package: *
Pin: release o=LP-PPA-system76-dev-stable
Pin-Priority: -9999
EOF
cat << EOF | sudo tee /etc/apt/preferences.d/system76-power.pref
Package: system76-power
Pin: release o=LP-PPA-system76-dev-stable
Pin-Priority: 9999
EOF
sudo apt-add-repository -yn ppa:system76-dev/stable
sudo apt-get update && sudo apt-get install system76-power
sudo groupadd -f adm && sudo usermod -aG adm "${USER}"
sudo system76-power graphics integrated
# reboot
# sudo system76-power graphics power off
# sudo system76-power profile performance
# sudo system76-power profile performance

# razer
sudo apt-add-repository -yn ppa:openrazer/stable
sudo apt-apt-repository -yn ppa:polychromatic/stable
sudo apt-get update
sudo apt-get install openrazer-meta polychromatic
sudo groupadd -f plugdev && sudo usermod -aG plugdev "${USER}"
