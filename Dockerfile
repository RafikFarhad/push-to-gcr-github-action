FROM docker:19.03.8

LABEL maintainer="RafikFarhad <rafikfarhad@gmail.com>"

RUN apk update && \
  apk upgrade && \
  apk add --no-cache python bash

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
