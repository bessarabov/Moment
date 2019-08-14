FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    perl \
    ;

COPY lib/ /app/lib/
COPY t/ /app/t/
COPY xt/ /app/xt/

WORKDIR /app/

CMD prove -lv t/
