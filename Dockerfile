FROM docker:19.03.8

LABEL maintainer="RafikFarhad<rafikfarhad@gmail.com>"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]