#!/bin/sh
echo "> Starting NRPE "
/usr/bin/nrpe -c /etc/nrpe.cfg -d

#Wait for NRPE Daemon to exit

PID=$(pidof nrpe)
if [ ! "$PID" ]; then
  echo "> Error: Unable to start nrpe daemon..."
  exit 1 # This makes sure a new container will start
fi
echo "> Started NRPE pid $PID"
while [ -d /proc/$PID ] && [ -z `grep zombie /proc/$PID/status` ]; do
    # echo "NRPE: $PID (running)..."
    sleep 60s
done
echo "> NRPE daemon exited. Quitting.."
