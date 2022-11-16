# add repository
cat << EOF | sudo tee /etc/apt/sources.list.d/oracle-virtualbox.list
deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib
EOF

# add key
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

# refresh apt
sudo apt-get update

# install virtualbox
sudo apt-get install virtualbox-7.0
