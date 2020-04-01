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
rm -v /hdd/tmp.zip >/dev/null 2>&1
rm -rv /hdd/ivacyvpn >/dev/null 2>&1
rm -rv /hdd/OpenVPN-Configs >/dev/null 2>&1
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
cd /hdd/
wget "https://support.ivacy.com/wp-content/uploads/2018/09/OpenVPN-Configs.zip" -O /hdd/tmp.zip; unzip /hdd/tmp.zip; rm /hdd/tmp.zip &> /dev/null 2>&1
rm -f /hdd/OpenVPN-Configs/"ca - Copy.crt" &> /dev/null 2>&1
mv /hdd/OpenVPN-Configs/ca.crt /tmp/ca.crt &> /dev/null 2>&1
mv /hdd/OpenVPN-Configs/secure-client.crt /tmp/secure-client.crt &> /dev/null 2>&1
mv /hdd/OpenVPN-Configs/secure-client.key /tmp/secure-client.key &> /dev/null 2>&1
mv /hdd/OpenVPN-Configs/Wdc.key /tmp/Wdc.key &> /dev/null 2>&1
mv /hdd/OpenVPN-Configs /hdd/ivacyvpn &> /dev/null 2>&1
cd /hdd/ivacyvpn


# rename .ovpn to .conf
for x in *.ovpn; do mv "$x" "${x%.ovpn}.conf"; done

# Move all files into sub folders
for file in *; do
  if [[ -f "$file" ]]; then
    mkdir "${file%.*}"
    mv "$file" "${file%.*}"
  fi
done

cd

# Copy crt and key files to ivacyvpn sub folders
find /hdd/ivacyvpn -type d -exec cp /tmp/ca.crt {} \;
find /hdd/ivacyvpn -type d -exec cp /tmp/secure-client.crt {} \;
find /hdd/ivacyvpn -type d -exec cp /tmp/secure-client.key {} \;
find /hdd/ivacyvpn -type d -exec cp /tmp/Wdc.key {} \;

# Config VPN Manager
cd .
init 4
sleep 3
sed -i '$i config.vpnmanager.directory=/hdd/ivacyvpn/' /etc/enigma2/settings
sed -i '$i config.vpnmanager.username=USERNAME' /etc/enigma2/settings
sed -i '$i config.vpnmanager.password=PASSWORD' /etc/enigma2/settings
sed -i -e "s/USERNAME/$USERNAME/g" /etc/enigma2/settings;sed -i -e "s/PASSWORD/$PASSWORD/g" /etc/enigma2/settings &> /dev/null 2>&1
echo $LINE

# Delete uneeded files
rm -f /hdd/ivacyvpn/ca.crt  &> /dev/null 2>&1
rm -f /hdd/ivacyvpn/secure-client.crt &> /dev/null 2>&1
rm -f /hdd/ivacyvpn/secure-client.key &> /dev/null 2>&1
rm -f /hdd/ivacyvpn/Wdc.key &> /dev/null 2>&1
rm -f /tmp/auth.txt &> /dev/null 2>&1
rm -f /tmp/ca.crt &> /dev/null 2>&1
rm -f /tmp/secure-client.crt &> /dev/null 2>&1
rm -f /tmp/secure-client.key &> /dev/null 2>&1
rm -f /tmp/Wdc.key &> /dev/null 2>&1
rm -f /home/root/ivacyvpn.sh &> /dev/null 2>&1
init 3
echo "OpenVPN Configs Downloaded Please Start OpenVPN"
exit
fi
