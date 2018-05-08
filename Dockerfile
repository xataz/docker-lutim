FROM xataz/alpine:3.7

ARG LUTIM_VER=0.10.4

ENV GID=991 \
    UID=991 \
    CONTACT=contact@domain.tld \
    WEBROOT=/ \
    SECRET=e7c0b28877f7479fe6711720475dcbbd \
    MAX_FILE_SIZE=10000000000 \
    DEFAULT_DELAY=1 \
    MAX_DELAY=0

LABEL description="lutim based on alpine" \
      tags="latest 0.10.4 0.10 0" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201805080600"

RUN BUILD_DEPS="build-base \
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
                perl-devel-checklib" \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.5/main ${BUILD_DEPS} \
                libressl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                perl-dbi \
                imagemagick==6.9.6.8-r1 \
                imagemagick-dev==6.9.6.8-r1 \
                shared-mime-info \
                tini \
                su-exec \
                postgresql-libs \
    && echo | cpan \
    && cpan install Carton \
    && cd / \
    && git clone -b ${LUTIM_VER} https://git.framasoft.org/luc/lutim.git /usr/lutim \
    && echo "requires 'Image::Magick';" >> /usr/lutim/cpanfile \
    && echo "requires 'Mojolicious::Plugin::AssetPack::Backcompat';" >> /usr/lutim/cpanfile \
    && cd /usr/lutim \
    && rm -rf cpanfile.snapshot \
    && carton install \
    && apk del --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.5/main ${BUILD_DEPS} imagemagick-dev \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lutim/local/cache/*

VOLUME /usr/lutim/data/ /usr/lutim/files

EXPOSE 8181

ADD lutim.conf /usr/lutim/lutim.conf
ADD startup /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]
