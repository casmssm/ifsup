#!/bin/bash

FULL_PATH="$(realpath $0)"
FULL_FOLDER="$(dirname $FULL_PATH)"
LOG_PATH="$FULL_FOLDER/logs"

#Creating Table
echo -e "\nCreating database 'ifsup' on MySQL..."
mysql -e "CREATE DATABASE ifsup;" 2>/dev/null
mysql ifsup < $FULL_FOLDER/dependencies/ifsup.sql 2>/dev/null
echo -e "Done."
echo -e "Creating Users and privileges on database..."
SENHA=$(cat $FULL_FOLDER/ifsup.conf | grep 'ifsupSQLPASS=' | cut -f2 -d'=' | cut -f2 -d"'")
mysql -e "DROP USER 'ifsupadmin'@'localhost';" 2>/dev/null
mysql -e "CREATE USER 'ifsupadmin'@'localhost' IDENTIFIED BY '$SENHA';" 2>/dev/null
mysql -e "GRANT ALL PRIVILEGES ON ifsup.* TO 'ifsupadmin'@'localhost';" 2>/dev/null
sleep 2
echo -e "Done."

#Fix CONFIG TABLE on MySQL
echo -e "Setting DEFAULT SQL configurations..."
mysql -D "ifsup" -e "INSERT INTO configuracao (idconfiguracao,LOG_PATH,ROOT_PATH,SPOOL_PATH) VALUES(1,'$LOG_PATH','$FULL_FOLDER','$FULL_FOLDER/bin/spool') ON DUPLICATE KEY UPDATE  LOG_PATH='$LOG_PATH', ROOT_PATH='$FULL_FOLDER', SPOOL_PATH='$FULL_FOLDER/bin/spool'"
sleep 2
echo -e "Done.\n"


echo -e "Instalando os pacotes necessários..."
#apt install pkpgcounter cups cups-tea4cups cups-ipp-utils cups-filters ghostscript hplip libcupsfilters1 firewalld -y
apt install cups cups-tea4cups cups-ipp-utils cups-filters ghostscript hplip libcupsfilters1 firewalld -y
sleep 2
echo -e "Done\n"

echo -e "Aplicando regras de firewall"
firewall-cmd --permanent --add-port=22/tcp 2>/dev/null
firewall-cmd --permanent --add-port=80/tcp 2>/dev/null
firewall-cmd --permanent --add-port=631/tcp 2>/dev/null
firewall-cmd --reload
sleep 2
echo -e "Done\n"

echo -e "Configuring other resources..."
if [[ "$(cat /etc/cups/tea4cups.conf | grep 'ifsup-capture-job')" == "" ]];then
TEA_CONFIG='prehook_0 : '$FULL_FOLDER'/bin/ifsup-capture-job "$TEAPRINTERNAME" "$TEACLIENTHOST" "$TEAUSERNAME" "$TEACOPIES" "$TEAOPTIONS" "$TEAJOBID" "$TEADATAFILE" "$TEAJOBSIZE" "$TEATITLE" &'
echo "$TEA_CONFIG" >> /etc/cups/tea4cups.conf
fi

sed -i 's/# keepfiles : yes/keepfiles : yes/g' /etc/cups/tea4cups.conf
sed -i 's/#debug : yes/debug : yes/g' /etc/cups/tea4cups.conf
sed -i 's/directory : \/var\/spool\/cups/directory : \/var\/spool\/tea4cups/g' /etc/cups/tea4cups.conf

if [[ ! -d "/var/spool/tea4cups" ]];then
mkdir -p /var/spool/tea4cups
chmod -R 775 /var/spool/cups && chown -R lp.lp /var/spool/cups
chmod -R 775 /var/spool/tea4cups && chown -R lp.lp /var/spool/tea4cups
fi

if [[ "$(cat /etc/cups/cupsd.conf | grep 'Listen 0.0.0.0:631')" == "" ]];then
ADICIONAR="Listen 0.0.0.0:631"
CUPS_CONF=$(cat /etc/cups/cupsd.conf)
CUPS_CONF=$(echo -e "$ADICIONAR\n$CUPS_CONF")
echo "$CUPS_CONF" > /etc/cups/cupsd.conf
fi

if [[ "$(cat /etc/cups/cupsd.conf | grep 'PreserveJobFiles No')" == "" ]];then
ADICIONAR="PreserveJobFiles No"
CUPS_CONF=$(cat /etc/cups/cupsd.conf)
CUPS_CONF=$(echo -e "$ADICIONAR\n$CUPS_CONF")
echo "$CUPS_CONF" > /etc/cups/cupsd.conf
fi

if [[ "$(cat /etc/cups/cupsd.conf | grep 'DefaultEncryption IfRequested')" == "" ]];then
ADICIONAR="DefaultEncryption IfRequested"
CUPS_CONF=$(cat /etc/cups/cupsd.conf)
CUPS_CONF=$(echo -e "$ADICIONAR\n$CUPS_CONF")
echo "$CUPS_CONF" > /etc/cups/cupsd.conf
fi

chmod +x -R $FULL_FOLDER

sleep 2
echo -e "Done\n"


echo -e "Reloading services..."
service cups restart
service apache2 restart
sleep 2
echo -e "Done\n"
