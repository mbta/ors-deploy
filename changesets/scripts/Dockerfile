FROM alpine:3.21

RUN apk --no-cache add osmctools=0.9-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

WORKDIR /app

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "ash", "scripts/entrypoint.sh" ]
