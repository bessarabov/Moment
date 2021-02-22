FROM perl:5.30.0

RUN cpanm --notest \
    Capture::Tiny \
    Test::Exception \
    Test::MockTime \
    Test::Whitespaces \
    ;

COPY lib/ /app/lib/
COPY t/ /app/t/
COPY xt/ /app/xt/

WORKDIR /app/
