FROM ubuntu:14.04
WORKDIR /build

# add miner repo
RUN apt-get update && \
        apt-get install -y software-properties-common && \
	add-apt-repository ppa:ethereum/ethereum

# install tools and dependencies
RUN apt-get update && \
        apt-get install -y \
        build-essential \
        g++ \
        curl \
        git \
        file \
        binutils \
	pkg-config \
	libssl-dev \
        libudev-dev \
        python \
        make \
        ca-certificates \
        zip \
        dpkg-dev \
        rhash \
        openssl \
        gcc \
        libc6 \
        libc6-dev \
        ethminer \
	supervisor

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

#downgrade rustup
#RUN rustup install 1.18.0 && rustup default 1.18.0-x86_64-unknown-linux-gnu

# show backtraces
ENV RUST_BACKTRACE 1

# show tools
RUN rustc -vV && \
cargo -V && \
gcc -v &&\
g++ -v

# build parity 1.8.0 beta
RUN git clone https://github.com/Neufund/parity.git && \
        cd parity && \
        git checkout v1.8.7-neufund && \
        cargo build --release --verbose && \
        ls /build/parity/target/release/parity && \
        strip /build/parity/target/release/parity

COPY nfdev.json /var/parity/chains/nfdev.json
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY password /build/
RUN mkdir /var/parity/keys
RUN mkdir /var/parity/keys/nfdev/
COPY keys/ /var/parity/keys/nfdev/

EXPOSE 8080 8545 8546 8180 30303
CMD ["/usr/bin/supervisord"]
