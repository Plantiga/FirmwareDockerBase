#purpose: Provide a Docker container that does not require extra setup before cmake commands
#         for the development of firmware for Plantiga products.
#version: 0.60b
#author: Andrew Hollister
#contributor: Paul Helter (provided base environment_setup to base this off of)
#SEE: ~/cmake/environment_setup.sh for source

FROM ubuntu:20.04

#Following Docker recommended convention for custom image based on maintained image
#GCC and required items, multi-lib for 32-bit support, coverage tool
RUN apt-get update -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
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
	protobuf-compiler \
	python-is-python2 \
	python-protobuf \
	srecord \
	unzip \
	vim \
	wget \
	zip && \
	apt-get autoclean -y && apt-get --purge --yes autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install cross-compiler
ENV ARM_VERSION=10.3-2021.10
RUN cd /tmp && \
	wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/${ARM_VERSION}/gcc-arm-none-eabi-${ARM_VERSION}-x86_64-linux.tar.bz2 && \
	tar -xf gcc-arm-none-eabi-${ARM_VERSION}-x86_64-linux.tar.bz2 --strip-components=1 -C /usr && \
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

# Upgrade Doxygen to fix some warnings
ENV DOXYGEN_VERSION=1.9.2
RUN apt-get update -y \
	&& apt-get remove doxygen -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
	make \
	libclang1-9 \
	libclang-cpp9 \
	&& \
	cd /tmp && \
	wget https://www.doxygen.nl/files/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
	tar -xf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
	cd doxygen-${DOXYGEN_VERSION} && \
	make install && \
	apt-get autoclean -y && apt-get --purge --yes autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y -o Acquire::Retries=10 --no-install-recommends \
	openssh-client && \
	apt-get autoclean -y && apt-get --purge --yes autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
