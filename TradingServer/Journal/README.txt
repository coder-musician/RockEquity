INSTALLATION STEPS (as root)


[------------------------- Upload Application files --------------------]

# mdkir JornalServer

Upload the following files:

images
node_modules
package.json
package-lock.json
public
server.js


[-------------------------  Install Node,js --------------------]

# npm install express


[-------------------------Initialize npm --------------------]

npm init -y


[------------------------- install Express --------------------]

# npm install express

This creates the node_modules directory and adds Express to your project.


[------------------------- Disable firewall permanently --------------------]

# systemctl stop firewalld

[------------------------- Launch Application at Startup --------------------]

# vi /usr/local/sbin/journal-startup.sh

""""
#/bin/bash
/root/JournalServer/node server.js
echo "JournaServer started at $(date)" >> /var/log/JournalServer.log

"""""

# chmod +x /usr/local/sbin/my-startup.sh


[------------------------- Launch Application at Startup --------------------]


# vi /etc/systemd/system/JournalServer.service

""""
[Unit]
Description=Run custom command at startup
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/sbin/journal-startup.sh
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target

""""


[------------------------- Enable and test the service --------------------]


sudo systemctl daemon-reload
sudo systemctl enable JournalServer.service
sudo systemctl start JournalServer.service


[------------------------- Open the application --------------------]

Open your browser and go to:
http://localhost:3000



