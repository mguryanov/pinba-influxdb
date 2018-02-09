FROM golang:1.8-alpine3.6 as builder

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
WORKDIR $GOPATH/src/app

RUN apk add --update --no-cache bash git
ADD pinba-influxdb ./ 

RUN go get -v github.com/golang/dep/cmd/dep
#RUN dep init
RUN dep status

RUN dep ensure -update
RUN CGO_ENABLED=0 GOOS=linux go build -a -o pinba-influxer main.go

#======

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /
COPY --from=builder /go/src/app/pinba-influxer .
CMD ["./pinba-influxer","--config=/config.yml"]
