ARG IMAGE=scratch
ARG OS=linux
ARG ARCH=amd64

FROM golang:1.24.5-alpine3.21 as builder

WORKDIR /go/src/github.com/eko/pihole-exporter
COPY . .

RUN apk --no-cache add git alpine-sdk

RUN go mod vendor
RUN CGO_ENABLED=0 GOOS=$OS GOARCH=$ARCH go build -ldflags '-s -w' -o binary ./

FROM $IMAGE

LABEL name="pihole-exporter"

WORKDIR /root/
COPY --from=builder /go/src/github.com/eko/pihole-exporter/binary pihole-exporter

CMD ["./pihole-exporter"]
