#purpose: Provide a Docker container that does not require extra setup before cmake commands
#         for the development of firmware for Plantiga products.
#version: 0.60b
#author: Andrew Hollister
#contributor: Paul Helter (provided base environment_setup to base this off of)
#SEE: ~/cmake/environment_setup.sh for source

FROM ubuntu:22.04

#Following Docker recommended convention for custom image based on maintained image
#GCC and required items, multi-lib for 32-bit support, coverage tool
RUN apt-get update -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
	bzip2 \
	clang-format \
	clang-tidy \
	cmake \
	default-jdk \
	doxygen \
	g++ \
	git \
	graphviz \
	iwyu \
	lcov \
	libncurses5-dev \
	libprotobuf-dev \
	man \
	ninja-build \
	openssh-client \
	protobuf-compiler \
	python2 \
	python3-protobuf \
	srecord \
	unzip \
	vim \
	wget \
	xz-utils \
	zip \
	&& apt-get autoclean -y && apt-get --purge --yes autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install cross-compiler
ENV ARM_VERSION=12.2.rel1
ENV ARM_TARGET=arm-none-eabi
ENV ARM_ARCH=x86_64
ENV ARM_URL=https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_VERSION}/binrel/arm-gnu-toolchain-${ARM_VERSION}-${ARM_ARCH}-${ARM_TARGET}.tar.xz
RUN cd /tmp && \
	wget ${ARM_URL} && \
	tar -xf arm-gnu-toolchain-${ARM_VERSION}-${ARM_ARCH}-${ARM_TARGET}.tar.xz --strip-components=1 -C /usr && \
	rm -rf /tmp/*

# Install Simplicity Commander (to build upgrade images)
RUN cd /tmp && \
	wget https://www.silabs.com/documents/public/software/SimplicityCommander-Linux.zip && \
	unzip SimplicityCommander-Linux.zip && \
	tar -xf SimplicityCommander-Linux/Commander_linux_x86_64_*.tar.bz -C /usr/local/ && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV PATH=/usr/local/commander/:$PATH


RUN mkdir /root/java && \
	cd /root/java && \
	wget -O plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download

ENV PLANTUML_DIR=/root/java
