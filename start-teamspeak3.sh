#!/bin/bash

case $TS_VERSION in
  LATEST)
    export TS_VERSION=`/get-version`
    ;;
esac

cd /data

TARFILE=teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2

download=0
if [ ! -e version ]; then
  download=1
else
  read version <version
  if [ "$version" != "$TS_VERSION" ]; then
    download=1
  fi
fi

if [ "$download" -eq 1 ]; then
  echo "Downloading ${TARFILE} ..."
  wget -q http://dl.4players.de/ts/releases/${TS_VERSION}/${TARFILE} \
  && tar -j -x -f ${TARFILE} --strip-components=1 \
  && rm -f ${TARFILE} \
  && echo $TS_VERSION >version \
  && chown -R teamspeak3:teamspeak3 /data
fi

# supervisord handles running and probing TS3 server and TSDNS
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
