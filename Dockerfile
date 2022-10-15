FROM docker:19.03.8

LABEL maintainer="RafikFarhad <rafikfarhad@gmail.com>"

RUN apk update && \
  apk upgrade && \
  apk add --no-cache python3 bash curl

RUN curl https://sdk.cloud.google.com | bash -s -- --disable-prompts

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
