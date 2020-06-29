FROM ubuntu:devel

LABEL description="A docker image for build pandoc with latex"
LABEL maintainer="keyi@cs.stanford.edu"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get update \
    && apt-get install -y --no-install-recommends pandoc pdf2svg librsvg2-bin texlive-full python3-pip python3-dev build-essential && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install requirements
COPY . /docker
RUN python3 -m pip install -r /docker/requirements.txt && rm -rf /root/.cache
