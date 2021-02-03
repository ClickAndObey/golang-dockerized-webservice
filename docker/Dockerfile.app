FROM golang:1.15-buster as build-base

WORKDIR /build

COPY src /build/src
COPY go.mod /build
COPY main.go /build

RUN go build -o /build/output/webservice

FROM golang:1.15-buster

WORKDIR /webservice

COPY --from=build-base /build/output/webservice /webservice/golang-dockerized-webservice

CMD ["/webservice/golang-dockerized-webservice"]