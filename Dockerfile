# Unlike the official Docker golang image, use a multistage build for increased
# build caching efficiency.
ARG GOROOT=/usr/local/go

FROM alpine:3.12 as builder
ARG GOGIT=https://go.googlesource.com/go
ARG GOROOT

RUN apk add --no-cache --virtual .clone-deps \
	ca-certificates \
	git

RUN apk add --no-cache --virtual .build-deps \
	bash \
	gcc \
	musl-dev \
	openssl \
	go

RUN set -eux; \
	mkdir -p ${GOROOT} && \
	git clone --depth 1 ${GOGIT} -b dev.go2go ${GOROOT}

WORKDIR ${GOROOT}
RUN cd src && ./make.bash
RUN rm -rf ${GOROOT}/pkg/bootstrap ${GOROOT}/pkg/obj ${GOROOT}/.git

FROM alpine:3.12
ARG GOPATH=/go
ARG GOROOT

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
# - docker run --rm debian:stretch grep '^hosts:' /etc/nsswitch.conf
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

COPY --from=builder ${GOROOT} ${GOROOT}
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
