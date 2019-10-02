FROM golang:1.13 AS compiler

WORKDIR $GOPATH/src/github.com/msoedov/hacker-slides

ENV GO111MODULE on
ENV GOPROXY https://goproxy.io

COPY . .
RUN go mod download
RUN GOOS=linux CGO_ENABLE=0 go build  -a -tags netgo -ldflags '-w -extldflags "-static"' -o /bin/hacker-slides *.go

FROM alpine:3.10

WORKDIR /srv

ENV GIN_MODE=release
RUN mkdir slides
COPY --from=compiler /bin/hacker-slides /bin/hacker-slides
COPY static static
COPY templates templates
COPY initial-slides.md initial-slides.md
CMD hacker-slides $PORT
