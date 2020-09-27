FROM ubuntu:devel

LABEL description="A docker image for build pandoc with latex"
LABEL maintainer="keyi@cs.stanford.edu"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get update \
    && apt-get install -y --no-install-recommends pdf2svg librsvg2-bin wget \
                                                  texlive-full python3-pip \
                                                  python3-dev build-essential \
                                                  graphviz && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/jgm/pandoc/releases/download/2.6/pandoc-2.6-1-amd64.deb -O pandoc.deb && \
    dpkg -i pandoc.deb && \
    rm *.deb

# install requirements
COPY . /docker
RUN python3 -m pip install -r /docker/requirements.txt && rm -rf /root/.cache
