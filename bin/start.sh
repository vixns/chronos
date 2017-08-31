#!/bin/sh

LIBPROCESS_IP="$(ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/')" \
LIBPROCESS_PORT="${PORT1}" \
MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so \
MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so \
exec java $JVM_OPTS -jar /chronos.jar $@
