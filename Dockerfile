FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
    wget \
    supervisor; \

    wget https://d1h4xl4cr1h0mo.cloudfront.net/stable-release/x86_64-unknown-linux-gnu/parity_1.9.5_ubuntu_amd64.deb && \
    dpkg -i parity_1.9.5_ubuntu_amd64.deb; \

    mkdir /var/parity && \
    mkdir /var/parity/keys && \
    mkdir /var/parity/keys/nfdev/;

COPY nfdev.json /var/parity/chains/nfdev.json
COPY keys/ /var/parity/keys/nfdev/
COPY password /var/parity/password

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 8545 8546 8180 30303
CMD ["/usr/bin/supervisord"]
