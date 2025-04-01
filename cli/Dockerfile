FROM dart:3.7.2 AS build

WORKDIR /stax
COPY . .

RUN dart pub get
RUN dart compile exe bin/cli.dart -o stax

FROM alpine:latest

RUN apk add bash gcompat git
COPY --from=build /stax/stax /usr/local/bin/stax
RUN chmod +x /usr/local/bin/stax
ENV PATH="/usr/local/bin/stax:$PATH"
