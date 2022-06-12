FROM alpine:lastest AS GOLANG

RUN mkdir /go

RUN cd /go \
  && wget https://golang.google.cn/dl/go1.18.2.linux-amd64.tar.gz \
  && tar -C /usr/local -zxf go1.18.2.linux-amd64.tar.gz \
  && rm -rf /go/go1.18.2.linux-amd64.tar.gz \
  && mkdir /lib64 \
  && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
ENV CGO_ENABLED=0
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
RUN GOOS=linux go build -installsuffix cgo -o httpserver httpserver.go

FROM GOLANG

COPY --from=GOLANG /root/httpserver /root/httpserver
EXPOSE 80
WORKDIR /root/httpserver/
ENTRYPOINT ["./httpserver"]



