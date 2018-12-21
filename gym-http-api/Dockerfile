FROM alpine:edge

WORKDIR /app

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update \
    python3 \
    python3-dev \
    python3-tkinter \
    py-pip \
    build-base \
 && rm -rf /var/cache/apk/*

# upgrade pip
RUN pip3 install --upgrade pip

# install dependencies of the Gym
RUN apk add --update \
    ca-certificates \
    gcc \
    g++ \
    cmake \
    zlib-dev \
    jpeg-dev \
    xvfb \
    libavc1394-dev \
    xorg-server-dev \
    py-opengl-accelerate \
    swig \
    git \
    libffi-dev \
    openblas \
    openblas-dev \
    ffmpeg \
    ffmpeg-dev \
    hdf5-dev \
    libc++-dev
    # py-numpy \
    # py-numpy-dev \    
    # libffi \

# install nose2 for python test
RUN pip3 install nose2

# pyglet for classic control
# RUN pip3 install pyglet

# install OpenAI Gym (all, exclude MuJoCo)
RUN git clone https://github.com/davemssavage/gym.git && pip3 install -e './gym[all]'

RUN git clone https://github.com/davemssavage/gym-http-api && cd gym-http-api && git checkout bind-address && sed -i 's/numpy=.*/numpy>=1.10.4/g' requirements.txt && pip3 install -r requirements.txt

EXPOSE 5000

# xvfb wrapper
COPY xvfb-run /usr/bin/xvfb-run

RUN chmod +x /usr/bin/xvfb-run

CMD xvfb-run -s "-screen 0 1400x900x24" python3 -u gym-http-api/gym_http_server.py --listen 0.0.0.0
