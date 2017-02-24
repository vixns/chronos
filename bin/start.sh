#!/bin/sh

LIBPROCESS_IP="$(/sbin/ifconfig eth0 | /bin/egrep -o 'addr:([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | /bin/egrep -o '[[:digit:]].*')" \
LIBPROCESS_PORT="${PORT1}" \
exec java $JVM_OPTS -jar /chronos/chronos.jar $@
