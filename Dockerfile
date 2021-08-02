FROM ubuntu:xenial

WORKDIR /build
# install tools and dependencies
RUN apt-get update && \
        apt-get install -y \
        curl \
        wget \
        unzip \
        supervisor;

# build openethereum
RUN wget https://github.com/openethereum/openethereum/releases/download/v3.3.0-rc.4/openethereum-linux-v3.3.0-rc.4.zip && \
    unzip /build/openethereum-linux-v3.3.0-rc.4.zip && \
    chmod u+x /build/openethereum

RUN mkdir /var/openethereum && \
    mkdir /var/openethereum/keys && \
    mkdir /var/openethereum/keys/nfdev/;

COPY nfdev.json /var/openethereum/chains/nfdev.json
COPY keys/ /var/openethereum/keys/nfdev/
COPY password /var/openethereum/password
COPY ./scripts/* /var/openethereum/
RUN chmod +x /var/openethereum/*.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 8545 8546 30303
CMD ["/usr/bin/supervisord"]
