# docker-nrpe

This is the nagios agent wrapped as a docker image. Based on [mikenowak/nrpe](https://github.com/mikenowak/docker-nrpe) image.


## Run

```
docker run -d --restart unless-stopped \
            -v /:/rootfs:ro \
            -v /var/run:/var/run:rw \
            -v /sys:/sys:ro \
            -v /var/lib/docker/:/var/lib/docker:ro \
            -v path/to/my/plugins:/usr/lib/nagios/plugins/user
            --privileged \
            --net=host \
            --ipc=host \
            --pid=host \
            -e NAGIOS_SERVER="1.2.3.4" \
            aviyam/nrpe:1.0
```


### ENV variables

|Variable           |default value |Description|
|--------           |------------- |-----------|
|LOG_FACILITY       |daemon|       |
|SERVER_PORT        |5666|         |
|NRPE_USER          |nagios|       |
|NRPE_GROUP         |nagios|       |
|NAGIOS_SERVER      |*| ip address of your monitoring server. Must be added            |
|DEBUG              |0|            |
|COMMAND_TIMEOUT    |90|           |
|CONNECTION_TIMEOUT |300|          |



### Plugins
You can add plugins without rebuilding the image. Mount alocal directory with
plugins to /usr/lib/nagios/plugins/user and restart the container. The
nrpe.cfg file will be created automatically.


