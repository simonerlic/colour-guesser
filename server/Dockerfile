# syntax=docker/dockerfile:1

FROM golang:1.20-alpine as build-go
WORKDIR /colour-guesser
COPY . .
EXPOSE 8080
RUN apk add build-base
RUN CGO_ENABLED=1 go build -o app main.go

FROM alpine:3.18.2 as production
WORKDIR /colour-guesser
COPY --from=build-go /colour-guesser .
CMD ["./app"]
