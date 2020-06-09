#!/bin/sh

# Default ENV variables
LOG_FACILITY=${LOG_FACILITY:-daemon}
SERVER_PORT=${SERVER_PORT:-5666}
NRPE_USER=${NRPE_USER:-nagios}
NRPE_GROUP=${NRPE_GROUP:-nagios}
DEBUG=${DEBUG:-0}
COMMAND_TIMEOUT=${COMMAND_TIMEOUT:-90}
CONNECTION_TIMEOUT=${CONNECTION_TIMEOUT:-300}
CONFIG_FILE=/etc/nrpe.cfg

# TODO: create mechanism to auto add files in plugins
echo "> Write config file "
cat  << CFG >$CONFIG_FILE
log_facility=$LOG_FACILITY
pid_file=/var/run/nrpe.pid
server_port=$SERVER_PORT
nrpe_user=$NRPE_USER
nrpe_group=$NRPE_GROUP
allowed_hosts=127.0.0.1, $NAGIOS_SERVER
dont_blame_nrpe=1
debug=$DEBUG
command_timeout=$COMMAND_TIMEOUT
connection_timeout=$CONNECTION_TIMEOUT
allow_weak_random_seed=0
ciphers=ADH-AES256-SHA:ADH-AES128-SHA


CFG

USER_PLUGIN_DIR=/usr/lib/nagios/plugins
PLUGIN_FILES=$(find $USER_PLUGIN_DIR -type f  -exec echo {}  \;)

for plugin in $PLUGIN_FILES

do 
    echo $(basename $plugin) loaded
    echo -e "command[$(basename $plugin)]=$plugin \$ARG\$" >> $CONFIG_FILE
done

echo "> Add user $NRPE_USER to sudoers "
echo "$NRPE_USER ALL=(ALL) NOPASSWD: /usr/lib/nagios/plugins/*" >> /etc/sudoers
echo "Defaults: $NRPE_USER        !requiretty" >> /etc/sudoers

exec "$@"

