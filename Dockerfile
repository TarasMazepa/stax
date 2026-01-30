FROM taras0mazepa/dart-fastlane:3.10.8 AS build

WORKDIR /stax
COPY cli .
COPY VERSION .

RUN <<EOF
VERSION="$(cat VERSION)"
dart pub get
dart compile exe bin/cli.dart -o stax -Dversion=$VERSION
dart compile exe bin/stax_daemon.dart -o stax-daemon -Dversion=$VERSION
EOF

FROM alpine:latest

COPY --from=build /stax/stax /usr/local/bin/stax
COPY --from=build /stax/stax-daemon /usr/local/bin/stax-daemon

RUN <<EOF
apk add bash gcompat git
chmod +x /usr/local/bin/stax /usr/local/bin/stax-daemon
EOF

ENV PATH="/usr/local/bin/stax:/usr/local/bin/stax-daemon:$PATH"
