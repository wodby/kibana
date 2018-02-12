FROM wodby/alpine:3.6-1.2.0

ARG KIBANA_VER

ENV KIBANA_VER=${KIBANA_VER} \
    \
    PATH="/usr/share/kibana/bin:${PATH}"

RUN set -ex; \
    \
    addgroup -g 1000 -S kibana; \
    adduser -u 1000 -D -S -s /bin/bash -G kibana kibana; \
    echo "PS1='\w\$ '" >> /home/kibana/.bashrc; \
    \
    apk add --update --no-cache -t .kibana-rundeps \
        make \
        nodejs; \
    \
    apk add --no-cache -t .kibana-build-deps gnupg openssl; \
    \
    # Download and verify kibana.
    cd /tmp; \
    kibana_url="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VER}-linux-x86_64.tar.gz"; \
    curl -o kibana.tar.gz -Lskj "${kibana_url}"; \
    curl -o kibana.tar.gz.asc -Lskj "${kibana_url}.asc"; \
    GPG_KEYS=46095ACC8548582C1A2699A9D27D666CD88E42B4 gpg-verify.sh /tmp/kibana.tar.gz.asc /tmp/kibana.tar.gz; \
    \
    mkdir -p /usr/share/kibana/node/bin; \
    tar zxf kibana.tar.gz --strip-components=1 -C /usr/share/kibana; \
    ln -sf /usr/bin/node /usr/share/kibana/node/bin/node; \
    chown -R kibana:kibana /usr/share/kibana; \
    \
    # Clean up
    apk del --purge .kibana-build-deps; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

USER 1000

WORKDIR /usr/share/kibana

COPY bin /usr/local/bin/
COPY config /usr/share/kibana/config/

EXPOSE 5601

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["kibana-docker"]