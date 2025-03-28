FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    git \
    gcc

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

RUN brew install TarasMazepa/stax/stax

RUN cd ~/ && git clone https://github.com/0xMALVEE/stax-demo.git && cd stax-demo 
