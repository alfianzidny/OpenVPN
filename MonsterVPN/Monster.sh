#!/bin/sh
echo "check_certificate = off" >> ~/.wgetrc
USERNAME='uuuu'
PASSWORD='pppp'
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
###############################################################
# Standard Config
# If you change anything below this line, it probably wont 
# be able to connect to your VPN.
################################################################
rm -rv /etc/openvpn >/dev/null 2>&1
rm -v /hdd/MonsterVPN/MonsterVPN.zip >/dev/null 2>&1
rm -rv /hdd/MonsterVPN >/dev/null 2>&1
mkdir -p /hdd/MonsterVPN
mkdir -p /etc/openvpn

# download and install VPN Changer
echo "downloading VPN Changer"
echo $LINE
cd /var && cd /var/volatile && cd /var/volatile/tmp && wget -O /var/volatile/tmp/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk "https://github.com/davesayers2014/OpenVPN/blob/test/enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk?raw=true" &> /dev/null 2>&1
echo "Installing VPN Changer"
echo $LINE
opkg --force-reinstall --force-overwrite install enigma2-plugin-extensions-vpnmanager_1.1.3_all.ipk &> /dev/null 2>&1
cd
echo "Installing OpenVPN"
echo $LINE

# Install OpenVPN
opkg update &> /dev/null 2>&1
opkg --force-reinstall --force-overwrite install openvpn &> /dev/null 2>&1

# Download VPN Configs
echo "Downloading OpenVPN Configs"
echo $LINE
wget -O /hdd/MonsterVPN/MonsterVPN.zip "http://www.monstervpn.tech/ovpn_configuration.zip" &> /dev/null 2>&1

# Configure VPN
echo "Configuring OpenVPN"
cd /hdd/MonsterVPN
unzip -o MonsterVPN.zip &> /dev/null 2>&1
rm -v /hdd/MonsterVPN/MonsterVPN.zip &> /dev/null 2>&1
rm -rv /hdd/MonsterVPN/__MACOSX >/dev/null 2>&1


# rename .ovpn to .conf
for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Move all files into sub folders
for file in *; do
  if [[ -f "$file" ]]; then
    mkdir "${file%.*}"
    mv "$file" "${file%.*}"
  fi
done

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.directory=/hdd/MonsterVPN/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete uneeded files 
rm -f /home/root/MonsterVPN.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi