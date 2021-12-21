#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")/.." ; pwd -P )

launcher="${parent_path}/launcherTV.sh"

remove_cronjob () { 
    echo "Removing TV Dashboard cronjob"
    crontab -l > newcron
    sed -e '/\@reboot.*launcherTV.sh.*$/d' newcron
    crontab newcron
   crontab -l | grep -i "@reboot sleep 30 && sh ${launcher}" | crontab -r
   if [ $? -eq 0 ]
      then
         echo "Cronjob removed!"
      else
         echo "Failed to remove cronjob!"
   fi
    rm -f newcron
}

apt-get remove lighttpd

rm -rf /var/www/html

remove_cronjob

python3 ./stop.py

rm -R "${parent_path}"  2>&1 > /dev/null

echo "Done."
