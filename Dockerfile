FROM docker:19.03.8

LABEL maintainer="RafikFarhad <rafikfarhad@gmail.com>"

RUN apk update && \
  apk upgrade && \
  apk add --no-cache git curl python bash

#  Downloading gcloud package
# RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
# RUN mkdir -p /usr/local/gcloud \
#   && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
#   && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
# ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
