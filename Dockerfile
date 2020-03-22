FROM docker:19.03.8

LABEL maintainer="RafikFarhad<rafikfarhad@gmail.com>"

RUN curl -sSL https://sdk.cloud.google.com | bash

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]