FROM docker:19.03.8

LABEL maintainer="RafikFarhad <rafikfarhad@gmail.com>"

RUN apk update && \
  apk upgrade && \
  apk add --no-cache bash curl

RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=/root/gcloud --disable-prompts > /dev/null 2>&1

ENV PATH $PATH:/root/gcloud/google-cloud-sdk/bin

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
