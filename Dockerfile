FROM debian:jessie

MAINTAINER ozzyfant

ENV TS_VERSION LATEST
ENV LANG C.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install bzip2 wget ca-certificates supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -M -s /bin/false --uid 9987 teamspeak3 \
    && mkdir /data \
    && chown teamspeak3:teamspeak3 /data

RUN mkdir -p /var/log/supervisord
RUN mkdir -p /var/run/supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY get-version.sh /get-version
COPY start-teamspeak3.sh /start-teamspeak3
COPY run-teamspeak3.sh /run-teamspeak3
COPY run-tsdns.sh /run-tsdns

EXPOSE 9987/udp 10011 30033 41144

USER root
VOLUME /data
WORKDIR /data
CMD ["/start-teamspeak3"]
