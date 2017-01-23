#!/bin/sh

LIBPROCESS_IP="$(ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/')" \
LIBPROCESS_PORT="${PORT1}" \
exec java $JVM_OPTS -jar /chronos/chronos.jar $@
