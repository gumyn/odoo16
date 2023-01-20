#!/bin/bash
DESTINATION=$1
PORT=$2
CHAT=$3
# clone Odoo directory
git clone --depth=1 https://github.com/gumyn/odoo16 $DESTINATION
rm -rf $DESTINATION/.git
# set permission
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION
sudo chmod -R 777 $DESTINATION/addons
sudo chmod -R 777 $DESTINATION/etc
sudo chmod -R 777 $DESTINATION/postgresql

# config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
sudo sysctl -p
sed -i 's/10016/'$PORT'/g' $DESTINATION/docker-compose.yml
sed -i 's/20016/'$CHAT'/g' $DESTINATION/docker-compose.yml
# run Odoo
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo 'Started Odoo @ http://localhost:'$PORT' | Master Password: gumy.love | Live chat port: '$CHAT
