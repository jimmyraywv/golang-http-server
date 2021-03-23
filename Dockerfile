FROM golang:1.14.6 as builder
WORKDIR /
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main.bin .

FROM scratch
WORKDIR /
COPY --from=builder main.bin main
COPY html html
COPY tmp tmp
EXPOSE 8080
USER 0
ENTRYPOINT ["/main"]
