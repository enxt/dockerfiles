Launch gym server:

set-variable -name DISPLAY -value <your.ip>:0.0
docker run -ti --rm -p 5000:5000 -e DISPLAY=$DISPLAY enxt/gym-http-api
