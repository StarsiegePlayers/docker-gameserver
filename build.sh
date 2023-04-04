#!/bin/bash

wget -nc "https://download.starsiegeplayers.com/Starsiege%20-%20Server%20(SSP%207-1-2021).zip"
unzip -d app "Starsiege - Server (SSP 7-1-2021).zip"
cp -r games/ app/
cp -r scripts/ app/
rm app/server_templates.zip
docker build . -t starsiege/gameserver:latest