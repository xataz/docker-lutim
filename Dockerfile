FROM alpine:3.8

ARG LUTIM_VERSION=0.11.4

ENV GID=991 \
    UID=991 \
    CONTACT=contact@domain.tld \
    WEBROOT=/ \
    SECRET=e7c0b28877f7479fe6711720475dcbbd \
    MAX_FILE_SIZE=10000000000 \
    DEFAULT_DELAY=1 \
    MAX_DELAY=0

LABEL description="lutim based on alpine" \
      tags="latest 0.11.4 0.11 0" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201812081200"

RUN apk add --update --no-cache --virtual .build-deps \
                build-base \
                libressl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                wget \
                postgresql-dev \
                gnupg \
                zlib-dev \
                mariadb-dev \
                imagemagick6-dev \
                perl-devel-checklib \
    && apk add --update --no-cache \
                libressl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                perl-dbi \
                imagemagick6 \
                shared-mime-info \
                tini \
                su-exec \
                postgresql-libs \
    && echo | cpan \
    && cpan install Carton \
    && git clone -b ${LUTIM_VERSION} https://framagit.org/luc/lutim.git /usr/lutim \
    && cd /usr/lutim \
    && echo "requires 'Image::Magick';" >> /usr/lutim/cpanfile \
    && echo "requires 'Mojolicious::Plugin::AssetPack::Backcompat';" >> /usr/lutim/cpanfile \
    && rm -rf cpanfile.snapshot \
    && carton install \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lutim/local/cache/*

VOLUME /usr/lutim/data /usr/lutim/files

EXPOSE 8181

COPY lutim.conf /usr/lutim/lutim.conf
COPY startup    /usr/local/bin/startup
RUN  chmod +x   /usr/local/bin/startup
COPY lutim_cron /etc/periodic/daily/lutim_cron
RUN  chmod +x   /etc/periodic/daily/lutim_cron

CMD ["/usr/local/bin/startup"]
