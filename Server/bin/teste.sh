#!/bin/bash

FULL_PATH="$(realpath $0)"
FULL_FOLDER="$(dirname $FULL_PATH)"

source "$FULL_FOLDER/../ifsup.conf"

echo "[$MYPORT]"
echo "[$AUTH_TIMEOUT]"
echo -n "auth|$MYIPv4|$MYPORT|$AUTH_TIMEOUT" | ncat -n -w$AUTH_TIMEOUT 10.0.0.11 8888 --send-only
#mysql -B -N -u "'$ifsupSQLUSER'" -p"$ifsupSQLPASS" -D "$ifsupSQLBASE" -h $ifsupSQLADDR -e "INSERT INTO usuario (usuario, senha, quota, idgrupo, admin) VALUES ('SS','bankai','5','1',false)"

#CLIENTIP="200.100.13.21"

#sed -i -n "/$CLIENTIP/!p" waitlist

#while [[ "$(cat waitlist | grep "2001")" != "" ]];do
#sleep 1
#done
