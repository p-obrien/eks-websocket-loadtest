
FROM golang:1.23 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o websocket-server .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/websocket-server .
EXPOSE 8080
CMD ["./websocket-server"]

