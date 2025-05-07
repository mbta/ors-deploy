FROM alpine:latest

RUN apk add osmctools --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

WORKDIR /app

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "ash", "entrypoint.sh" ]
