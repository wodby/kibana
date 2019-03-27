ARG OPENJDK_VER

FROM wodby/openjdk:${OPENJDK_VER}-jre

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
        libstdc++ \
        make; \
    \
    apk add --no-cache -t .kibana-build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        openssl \
        python \
        xz; \
    \
    node_version=$(wget -qO- "https://raw.githubusercontent.com/elastic/kibana/v${KIBANA_VER}/.node-version"); \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    for key in \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        77984A986EBC2AA786BC0F66B01FBB92821C587A \
        8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
        4ED778F539E3634C779C87C6D7062848A1AB005C \
        A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
        B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
        gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done; \
    curl -fsSLO --compressed "https://nodejs.org/dist/v$node_version/node-v$node_version.tar.xz"; \
    curl -fsSLO --compressed "https://nodejs.org/dist/v$node_version/SHASUMS256.txt.asc"; \
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc; \
    grep " node-v$node_version.tar.xz\$" SHASUMS256.txt | sha256sum -c -; \
    ls -la; \
    tar -xf "node-v$node_version.tar.xz"; \
    cd "node-v$node_version"; \
    ./configure; \
    make -j$(getconf _NPROCESSORS_ONLN); \
    make install; \
    cd ..; \
    rm -Rf "node-v$node_version"; \
    rm "node-v$node_version.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
    \
    cd /tmp; \
    kibana_url="https://artifacts.elastic.co/downloads/kibana/kibana-oss-${KIBANA_VER}-linux-x86_64.tar.gz"; \
    # Since 6.3 kibana provides a separate OSS version without x-pack.
    [[ $(compare_semver "6.3.0" "${KIBANA_VER}") == 0 ]] && kibana_url="${kibana_url/-oss/}"; \
    curl -o kibana.tar.gz -Lskj "${kibana_url}"; \
    curl -o kibana.tar.gz.asc -Lskj "${kibana_url}.asc"; \
    GPG_KEYS=46095ACC8548582C1A2699A9D27D666CD88E42B4 gpg_verify /tmp/kibana.tar.gz.asc /tmp/kibana.tar.gz; \
    \
    mkdir -p /usr/share/kibana/node/bin; \
    tar zxf kibana.tar.gz --strip-components=1 -C /usr/share/kibana; \
    ln -sf /usr/bin/node /usr/share/kibana/node/bin/node; \
    chown -R kibana:kibana /usr/share/kibana; \
    \
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