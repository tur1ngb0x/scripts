curl -fsSL 'https://download.sublimetext.com/sublimehq-pub.gpg' | sudo gpg --dearmor -o /usr/share/keyrings/sublime.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/sublime.list
deb [arch=amd64 signed-by=/usr/share/keyrings/sublime.gpg] https://download.sublimetext.com/ apt/stable/
EOF
sudo apt-get update && sudo apt-get install --install-recommends -y sublime-text
