FROM fpco/ubuntu-with-libgmp:14.04

ENV LC_ALL C.UTF-8

WORKDIR /app

COPY .stack-work/docker/_home/.local/bin/fizz-buzz-challenge ./

CMD ["/app/fizz-buzz-challenge"]
