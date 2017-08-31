#!/bin/sh

export LIBPROCESS_IP="$(ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/')"
export LIBPROCESS_PORT="${PORT1}"
export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
exec java ${JVM_OPTS} -jar /chronos.jar $@ --http_port ${PORT0}
