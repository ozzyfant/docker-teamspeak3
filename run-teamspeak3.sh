#!/bin/bash
export LD_LIBRARY_PATH=/data

TS3ARGS=""
if [ -e /data/ts3server.ini ]; then
  TS3ARGS="inifile=/data/ts3server.ini"
else
  TS3ARGS="createinifile=1"
fi

exec /data/ts3server $TS3ARGS
