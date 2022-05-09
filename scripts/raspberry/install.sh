#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

#launcher="${parent_path}/launcherTV.sh"
service="${parent_path}/tvdashboard.service"

#add_cronjob () { 
#    echo "Adding TV Dashboard as a cronjob"
#    crontab -l > newcron
#    echo "@reboot sleep 30 && sh ${launcher}" >> newcron
#    crontab newcron
#    rm -f newcron
#}

echo "Installing lighttpd..."
apt-get update
apt-get install lighttpd
pip3 install requests
echo "Done."

echo "Updating port..."

sed -i 's/server.port .*/server.port = 58000/g' '/etc/lighttpd/lighttpd.conf'

echo "Done."

echo "Copying files..."

rm -rf /var/www/html
mkdir /var/www/html

chmod -R 755 /var/www/html

cp -R ../build/* /var/www/html
echo "Done."

echo "Creating service..."


if [ -e $service ]
then
   echo "Service already exists"
else
   touch "${service}"
   printf '[Unit]\nDescription=TV dashboard\nAfter=multi-user.target\n[Service]\nType=oneshot\nRemainAfterExit=true\nExecStart=%s/../system/start.sh\nExecStop=%s/../system/stop.sh\n[Install]\nWantedBy=multi-user.target' "${parent_path}" "${parent_path}" > "${service}"
   cp ${service} "/etc/systemd/system"
   systemctl enable tvdashboard.service
   echo "Service created"
fi


#crontab -l | grep "$launcher"
#if [ $? -eq 0 ]
#   then
#       echo "Job already added to crontab"
#    else
#       echo "Adding job to crontab..."
#       touch "${launcher}"
#       printf '#!/bin/sh\n\nsudo python3 %s/../system/start.py' "${parent_path}" > "${launcher}"
#       add_cronjob
#fi

service lighttpd reload
systemctl start tvdashboard.service

#python3 "${parent_path}/../system/start.py"

echo "Done."
