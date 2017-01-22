#!/bin/sh

LIBPROCESS_IP="$(ifconfig eth0 | egrep -o 'addr:([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | egrep -o '[[:digit:]].*')" \
LIBPROCESS_PORT="${PORT1}" \
java $JVM_OPTS -jar /chronos/chronos.jar $@
