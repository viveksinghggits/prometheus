FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

ARG PROM_VERSION
RUN echo ${PROM_VERSION}
COPY --from=prom/prometheus:v2.23.0 /bin/prometheus                             /bin/prometheus
COPY --from=prom/prometheus:v2.23.0 /bin/promtool                               /bin/promtool
COPY --from=prom/prometheus:v2.23.0 /etc/prometheus/prometheus.yml              /etc/prometheus/prometheus.yml
COPY --from=prom/prometheus:v2.23.0 /usr/share/prometheus/console_libraries/    /usr/share/prometheus/console_libraries/
COPY --from=prom/prometheus:v2.23.0 /usr/share/prometheus/consoles/             /usr/share/prometheus/consoles/
COPY --from=prom/prometheus:v2.23.0 /LICENSE/                                   /licenses/
COPY --from=prom/prometheus:v2.23.0 /NOTICE                                     /NOTICE
COPY --from=prom/prometheus:v2.23.0 /npm_licenses.tar.bz2                       /npm_licenses.tar.bz2

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/
RUN mkdir -p /prometheus && \
    chown -R nobody etc/prometheus /prometheus

USER       nobody
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
