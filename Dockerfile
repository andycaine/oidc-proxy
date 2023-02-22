from httpd:2.4 as builder

RUN apt update && apt install -y \
    make \
    wget \
    curl \
    gcc \
    pkg-config \
    libapr1-dev \
    libaprutil1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libjansson-dev \
    libcjose-dev \
    libpcre2-dev

RUN wget https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.12.3/mod_auth_openidc-2.4.12.3.tar.gz \
    && tar xzf mod_auth_openidc-2.4.12.3.tar.gz \
    && cd mod_auth_openidc-2.4.12.3 \
    && ./configure --with-apxs=/usr/local/apache2/bin/apxs \
    && make \
    && make install


from httpd:2.4

RUN apt update && apt install -y \
    libjansson4 \
    libcjose0 \
    libpcre2-posix2

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY --from=builder /usr/local/apache2/modules/mod_auth_openidc.so ./modules/
