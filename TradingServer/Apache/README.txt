APACHE INSTALL

[---- Update the System Packages ----]
dnf update -y

[---- Install Apache ----]
dnf install httpd httpd-tools -y

[---- Start and Enable Apache ----]
systemctl enable --now httpd

[---- Check Apache Status ----]
systemctl status httpd

[---- Verify the installation - Get Public IP ----]
curl -4 icanhazip.com

