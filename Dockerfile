FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
    curl \
    supervisor;

RUN curl --fail -o parity https://releases.parity.io/v2.0.6/x86_64-unknown-linux-gnu/parity
RUN mv parity /usr/bin && chmod +x /usr/bin/parity

RUN mkdir /var/parity && \
    mkdir /var/parity/keys && \
    mkdir /var/parity/keys/nfdev/;

COPY nfdev.json /var/parity/chains/nfdev.json
COPY keys/ /var/parity/keys/nfdev/
COPY password /var/parity/password
COPY authcodes /var/parity/signer/authcodes
COPY ./scripts/simulate_blocks.sh /var/parity/signer/simulate_blocks.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 8545 8546 8180 30303
CMD ["/usr/bin/supervisord"]
