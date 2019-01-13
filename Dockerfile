#purpose: Provide a Docker container that does not require extra setup before cmake commands
#         for the development of firmware for Plantiga products.
#version: 0.50b
#author: Andrew Hollister
#contributor: Paul Helter (provided base environment_setup to base this off of)
#SEE: ~/cmake/environment_setup.sh for source

FROM ubuntu:18.04

#Following Docker recommended convention for custom image based on maintained image
#GCC and required items, multi-lib for 32-bit support, coverage tool, (default-jdk can be entered here as well)
RUN apt-get update -y \
	&& apt-get install -y \
	clang-format-6.0 \
	clang-tidy-6.0 \
	cmake \
	doxygen \
	gcc-multilib \
	g++-multilib \
	graphviz  \
	iwyu \
	lcov \
	ninja-build \
	software-properties-common \
	wget

#Have to split out these installs because they must be installed after dependencies in the previous RUN
#This may no longer be true after removing gcc-arm-none-eabi from apt-get install list and running autoremove
RUN apt-get install -y \
	binutils-arm-linux-gnueabi \
	gcc-arm-linux-gnueabi \
	libc6-armel-cross \
	libc6-dev-armel-cross \
	libncurses5-dev

#Crosscompiler Install with cleaning
RUN add-apt-repository ppa:team-gcc-arm-embedded/ppa \
	&& apt-get update -y \
	&& apt-get autoremove -y \
	&& apt-get install -y gcc-arm-embedded

#PlantUML Install
#Uncomment next line when we want to use the documentation from PlantUML
#RUN apt-get install -y default-jdk
# RUN mkdir ~/java \
# 	&& wget http://plantuml.sourceforge.net/download.html
# RUN mv download.html ~/java/plantuml.jar
# ENV PLANTUML_DIR="~/java"

#Clean up apt lists to reduce image size.
RUN rm -r /var/lib/apt/lists/*
