#!/bin/bash


FULL_PATH="$(realpath $0)"
FULL_FOLDER="$(dirname $FULL_PATH)"

source "$FULL_FOLDER/../ifsup.conf"

echo -e "Nome Completo:"
read NOME

echo -e "Nome do usuário ou CPF: "
read USUARIO

echo -e "Senha do usuário \"$USUARIO\":"
read -s SENHA

cSENHA=$($FULL_FOLDER/genpasswd.bin "$SENHA")

echo -e "Inserindo usuário no banco de dados..."
sleep 1
mysql -B -N -u "'$ifsupSQLUSER'" -p"$ifsupSQLPASS" -D "$ifsupSQLBASE" -h $ifsupSQLADDR -e "INSERT INTO usuario (nome, usuario, senha, quota, idgrupo, admin) VALUES ('$NOME','$USUARIO','$cSENHA','5','1',false)"
resultado=$?
sleep 1
if [[ "$resultado" == "0" ]];then
echo -e "OK.\n"
else
echo -e "\nOcorreu um erro ao adicionar o usuario \"$USUARIO\"!\n"
fi
