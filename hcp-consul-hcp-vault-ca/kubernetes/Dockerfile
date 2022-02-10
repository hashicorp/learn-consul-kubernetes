FROM alpine:3.15.0

RUN apk update && apk add terraform bash vault libcap && \
    setcap cap_ipc_lock= /usr/sbin/vault


ENTRYPOINT ["/bin/bash"]