#!/bin/sh

######################################
##  Starsiege Server Launch Script  ##
##  Authors: Jen, Alyssa,& Sydney   ##
##  ------------------------------  ##
##  Last Modified: 04/02/2023       ##
##                                  ##
##  Restructured for Docker usage   ##
######################################

if [ -x $1 ]; then
	exec $1
fi

UID=`id -u`
GID=`id -g`

if [ ${UID} -eq 0 ]; then
	if [ -z ${USER} ]; then
		echo "User not specified defaulting to 1000:1000"
		USER="1000:1000"
	fi
	
	case ${USER} in
	  (*:*)  _UID=${USER%:*} _GID=${USER##*:};;
	  (*)    _UID=${USER}    _GID=${USER};;
	esac
	
	mkdir /wineprefix /home
	chown ${_UID}:${_GID} /wineprefix /home
	export HOME=/home
	exec /usr/bin/setpriv --reuid=${_UID} --regid=${_GID} --clear-groups --inh-caps=-all /entrypoint.sh $@
fi

if [ ${UID} -ne 0 ]; then 
	echo "Starting wine..."
	wineboot -i
	sleep 1

	echo "Kill useless wine services"
	pkill -9 winedevice.exe
	pkill -9 plugplay.exe
	pkill -9 explorer.exe
	pkill -9 services.exe

	if [ -z "${STARTUP_SCRIPT}" ]; then
		echo "ERROR: a startup script is REQUIRED"
		exit 1
	fi

	if [ ! -f "/app/games/${STARTUP_SCRIPT}" ]; then
		echo "ERROR: startup script not found. Exiting..."
		exit 1
	fi

	OPTIONS="-s games\\${STARTUP_SCRIPT}"

	if [ ! -z "${COUNTRY_CODE}" ]; then
		OPTIONS="${OPTIONS} -c ${COUNTRY_CODE}"
	fi

	if [ -z "${SERVER_NAME}" ]; then
		SERVER_NAME="${HOSTNAME}"
	fi

	wine starsiege.exe ${OPTIONS} -- ${SERVER_NAME}

	echo "Server down"
fi
