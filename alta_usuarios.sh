#!/bin/bash

echo
echo "Para ejecutar:   ./1_for_lista.sh  2_for_cmd_lista.txt"
echo

LISTA=$1
USUARIO_PASS=$2


echo "archivo=$LISTA"
echo "usuario=$USUARIO_PASS"

get_pass()
{
	CLAVE=$(sudo grep $USUARIO_PASS /etc/shadow | awk -F ":" '{print $2}')
	echo $CLAVE
}

ANT_IFS=$IFS
IFS=$'\n'
for i in `cat $LISTA | awk -F ',' '{print $1" "$2" "$3}'| grep -v ^#`
do
	USUARIO=$(echo  $i |awk '{print $1}')
	GRUPO=$(echo  $i |awk '{print $2}')
	PATH_HOME=$(echo  $i |awk '{print $3}')
	HASH=$(get_pass)

	FLAG_GRUPO_EXISTE=$(grep -i -c $GRUPO /etc/group)
	if [[ $FLAG_GRUPO_EXISTE == 0 ]]; then
		echo "NO existe el grupo"
	else
		echo "Grupo ya existe"
	fi
	echo "sudo useradd -m -d $PATH_HOME -s /bin/bash -p '$HASH' -g $GRUPO $USUARIO"
done

IFS=$ANT_IFS

