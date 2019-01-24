#!/bin/sh
set -e

chown mosquitto:mosquitto -R /var/lib/mosquitto

if [ "$1" = 'mosquitto' ]; then
    exec /usr/local/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
fi

exec "$@"
