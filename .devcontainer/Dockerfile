FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal

RUN apt-get update && apt-get install -y \
    curl \
    git \
    locales \
    make \
    ; 

RUN curl --silent https://raw.githubusercontent.com/miyagawa/cpanminus/1.9019/App-cpanminus/cpanm | perl - App::cpanminus

RUN cpanm \
    Capture::Tiny \
    Test::Exception \
    Test::MockTime \
    ;
