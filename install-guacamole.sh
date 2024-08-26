#!/bin/bash

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y build-essential libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev \
    libavcodec-dev libavformat-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
    libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev tomcat9 tomcat9-admin tomcat9-common \
    tomcat9-user libfreerdp2-2 libfreerdp-client2-2 freerdp2-x11

# Download and install Guacamole Server
wget https://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.4.0/source/guacamole-server-1.4.0.tar.gz
tar -xzf guacamole-server-1.4.0.tar.gz
cd guacamole-server-1.4.0
./configure --with-init-dir=/etc/init.d
make
sudo make install
sudo ldconfig
sudo systemctl enable guacd
sudo systemctl start guacd

# Download and install Guacamole Client
cd ..
wget https://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.4.0/binary/guacamole-1.4.0.war
sudo mv guacamole-1.4.0.war /var/lib/tomcat9/webapps/guacamole.war

# Configure Guacamole
sudo mkdir /etc/guacamole
echo "guacd-hostname: localhost" | sudo tee /etc/guacamole/guacamole.properties
echo "guacd-port: 4822" | sudo tee -a /etc/guacamole/guacamole.properties
sudo ln -s /etc/guacamole /usr/share/tomcat9/.guacamole

# Restart Tomcat service
sudo systemctl restart tomcat9

# Retrieve the IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Output the IP address for connecting to Guacamole
echo "Guacamole is installed and configured. Connect to http://$IP_ADDRESS:8080/guacamole in your browser."
