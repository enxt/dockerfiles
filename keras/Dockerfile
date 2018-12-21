FROM tensorflow/tensorflow:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  git \
	curl \
	ca-certificates \
	libjpeg-dev \
	libpng-dev \
	python3-pip \
	python3-setuptools && \
	rm -rf /var/lib/apt/lists/*
RUN pip3 install keras
WORKDIR /workspace
RUN chmod -R a+w /workspace
