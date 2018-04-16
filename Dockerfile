FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
    curl \
    supervisor;

RUN curl --fail -o parity.deb http://d1h4xl4cr1h0mo.cloudfront.net/v1.9.6/x86_64-unknown-linux-gnu/parity_1.9.6_ubuntu_amd64.deb

RUN dpkg -i parity.deb

RUN mkdir /var/parity && \
    mkdir /var/parity/keys && \
    mkdir /var/parity/keys/nfdev/;

COPY nfdev.json /var/parity/chains/nfdev.json
COPY keys/ /var/parity/keys/nfdev/
COPY password /var/parity/password

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 8545 8546 8180 30303
CMD ["/usr/bin/supervisord"]
