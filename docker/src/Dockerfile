FROM ubuntu:20.04 AS Base

ENV DEBIAN_FRONTEND=noninteractive

ENV CMAKE_GCC_VERSION_FOR_LTO=10

ARG SRC_DIR="/home/builder/src"
ENV SRC_DIR="${SRC_DIR}"

ARG IMAGE_DIR="/image"
ENV IMAGE_DIR="${IMAGE_DIR}"

ARG NUM_THREADS=4

FROM Base AS BuildEnv
RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get install -y --no-install-recommends \
		cmake build-essential ragel \
		libz-dev libicu-dev libcairo-dev libprotobuf-dev \
		protobuf-compiler libcrypto++-dev libcgal-dev \
		git-core curl python ca-certificates \
		cgdb valgrind libtbb-dev \
	&& apt-get clean autoclean \
	&& apt-get autoremove --yes \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}

    #Install path-finder-cli
FROM BuildEnv AS PathFinder

#Setup users
RUN useradd -m -U builder

#USER builder

RUN mkdir -p ${SRC_DIR}
WORKDIR ${SRC_DIR}
RUN git clone --recursive https://github.com/dbahrdt/path-finder-cli.git PathFinderCli
WORKDIR ${SRC_DIR}/PathFinderCli
RUN cd vendor/path_finder \
	&& git remote add dbahrdt https://github.com/dbahrdt/path_finder.git \
	&& git fetch dbahrdt
RUN git fetch \
	&& cd vendor/path_finder \
	&& git fetch dbahrdt \
	&& cd ../../ \
	&& git checkout 027d0a8cf84dadf4941979add82fffbe94cece0a  \
	&& git submodule update --init --recursive

# Variant for cgdb
WORKDIR ${SRC_DIR}/PathFinderCli/build
RUN cmake -DCMAKE_BUILD_TYPE=ultrasanitize ../
RUN make -j ${NUM_THREADS:-4}

# Variant for valgrind
WORKDIR ${SRC_DIR}/PathFinderCli/build_ultra
RUN cmake -DCMAKE_BUILD_TYPE=ultra ../
RUN make -j ${NUM_THREADS:-4}

WORKDIR ${SRC_DIR}/PathFinderCli/build_release
RUN cmake -DCMAKE_BUILD_TYPE=Release ../
RUN make -j ${NUM_THREADS:-4}

RUN chown -R builder:builder ${SRC_DIR} 

RUN echo ''

COPY run.sh /run.sh
RUN chmod +x /run.sh

USER builder
ENTRYPOINT ["/run.sh"]
CMD []