FROM golang:1.24-alpine AS builder
WORKDIR /myapp
COPY . .
RUN go build -o main main.go


FROM alpine:3.20
WORKDIR /myapp
COPY --from=builder /myapp/main /myapp/main
EXPOSE 4444
CMD ["/myapp/main"]


# docker build -t ttl.sh/myapp:2h .
# docker push ttl.sh/myapp:2h

