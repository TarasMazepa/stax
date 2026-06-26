FROM stax-e2e-test:latest

RUN echo 'echo "testing docker"' >> /.bashrc

ENV ENV=/.bashrc
