FROM debian:stable-slim

COPY ./scripts/run.sh ./run.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        libicu-dev \
        libasound2 \
        libusb-1.0-0 \
    && ./run.sh \
    && apt-get purge -y \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && rm run.sh

USER nobody
ENTRYPOINT [ "SDRconnect", "--server" ]
