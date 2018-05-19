
Build: ```docker build -t apt-cacher .```

Run: ```docker run -d -p 3142:3142 --name aptcacher apt-cacher```

and then you can run containers with:
```docker run -t -i --rm -e http_proxy http://dockerhost:3142/ debian bash```

**Here, `dockerhost` is the IP address or FQDN of a host running the Docker daemon which acts as an APT proxy server.**

For more instructions and options: [see this docker example page]

[see this docker example page]: https://docs.docker.com/engine/examples/apt-cacher-ng/
