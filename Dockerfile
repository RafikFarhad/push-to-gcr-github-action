FROM docker:19.03.8

LABEL maintainer="RafikFarhad<rafikfarhad@gmail.com>"

RUN apk-update && \
    apk-upgrade && \
    apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]