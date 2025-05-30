FROM dart:3.8.1 AS build

WORKDIR /stax
COPY cli .
COPY VERSION .

RUN dart pub get
RUN dart compile exe bin/cli.dart -o stax -Dversion="$(cat VERSION)"
RUN dart compile exe bin/stax_daemon.dart -o stax-daemon -Dversion="$(cat VERSION)"

FROM alpine:latest

RUN apk add bash gcompat git
COPY --from=build /stax/stax /usr/local/bin/stax
COPY --from=build /stax/stax-daemon /usr/local/bin/stax-daemon
RUN chmod +x /usr/local/bin/stax /usr/local/bin/stax-daemon
ENV PATH="/usr/local/bin/stax:/usr/local/bin/stax-daemon:$PATH"
