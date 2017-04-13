#!/bin/bash
#ejemplo de url
#ssh://<a class="project" href="/td3/r5054-Gaggino-Marcelo-Eduardo"><div class="dash-project-avatar">
#URL: url de la base del gitlab
#GRUPO: grupo del cual descargar repositorios
#CURSO: filtro que se la aplica a la la url
#GITLAB_TOKEN: token privado de gitlab

URL="gitlab.frba.utn.edu.ar"
GRUPO="/td3/"
CURSO="r5051"
DEBUG=0

if [ -z $GITLAB_TOKEN ]; then
	echo "Falta definir el token privado \$GITLAB_TOKEN"
	exit 1;
fi

while read -r line
do
	if [ $DEBUG -eq 1 ]; then
		echo "$line"
	fi
	if [ -d "$line" ]; then
		if [ $DEBUG -eq 1 ]; then
			echo "Ya existe => PULL"
		fi
		cd $line
		git pull
		cd - 1>&- 2>&-
	else
		#clono usando ssh
		if [ $DEBUG -eq 1 ]; then
			echo "ssh://git@$URL$GRUPO$line"
		fi
		git clone "ssh://git@$URL$GRUPO$line"
	fi
done <<< $(curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" https://$URL 2>&- | grep $CURSO | grep -v class)

exit 0
