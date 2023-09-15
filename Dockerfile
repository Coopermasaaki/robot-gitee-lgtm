FROM openeuler/openeuler:23.03 as BUILDER
RUN dnf update -y && \
    dnf install -y golang && \
    go env -w GOPROXY=https://goproxy.cn,direct

MAINTAINER zengchen1024<chenzeng765@gmail.com>

# build binary
WORKDIR /go/src/github.com/opensourceways/robot-gitee-lgtm
COPY . .
RUN GO111MODULE=on CGO_ENABLED=0 go build -a -o robot-gitee-lgtm .

# copy binary config and utils
FROM openeuler/openeuler:22.03
RUN dnf -y update && \
    dnf in -y shadow && \
    groupadd -g 1000 master-robot-gitee-lgtm && \
    useradd -u 1000 -g master-robot-gitee-lgtm -s /bin/bash -m master-robot-gitee-lgtm

USER master-robot-gitee-lgtm

COPY  --chown=master-robot-gitee-lgtm --from=BUILDER /go/src/github.com/opensourceways/robot-gitee-lgtm/robot-gitee-lgtm /opt/app/robot-gitee-lgtm

ENTRYPOINT ["/opt/app/robot-gitee-lgtm"]
