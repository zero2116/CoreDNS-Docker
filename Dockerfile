# Download
FROM ubuntu AS downloader
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /download
RUN apt install -y curl unzip && \
    curl -L -o coredns-linux-amd64.zip https://ci.appveyor.com/api/buildjobs/ddqnbjdtnodscia7/artifacts/distrib%2Fcoredns-linux-amd64.zip && \
    unzip coredns-linux-amd64.zip

# Build
FROM ubuntu AS builder
ENV DEBIAN_FRONTEND=noninteractive
ENV AUTOGEN_PLANET=0
ARG OVERLAY_S6_ARCH

LABEL org.opencontainers.image.source="https://github.com/zero2116/CoreDNS-Docker"
LABEL MAINTAINER="https://github.com/zero2116"
LABEL Description="增强版CoreDNS的Docker镜像"
ADD VERSION .

WORKDIR /opt/corends-enhance
COPY --from=downloader /download/coredns-linux-amd64/coredns ./app/coredns
COPY --from=downloader /download/coredns-linux-amd64/Corefile ./conf/Corefile

EXPOSE 5353/tcp
EXPOSE 5353/udp

VOLUME ["/opt/corends-enhance/conf"]
ENTRYPOINT [ "/opt/corends-enhance/app/coredns", "-conf", "/opt/corends-enhance/conf/Corefile" ]
