FROM alpine:3.11

RUN apk update \
   && apk add --no-cache  perl python3 nrpe nagios-plugins-procs nagios-plugins-time nagios-plugins-load nagios-plugins-swap nagios-plugins-disk sudo \
   && pip3 install requests requests_unixsocket docker hurry.filesize  

COPY scripts /

RUN chmod  +x /*.sh

EXPOSE 5666

ENTRYPOINT [ "/entrypoint.sh" ] 

CMD [ "/run_nrpe.sh" ]
