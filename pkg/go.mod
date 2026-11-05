module github.com/aserto-dev/go-authorizer/pkg

go 1.26.0

toolchain go1.27.3

replace github.com/aserto-dev/go-authorizer/aserto => ../aserto

require (
	github.com/aserto-dev/errors v0.34.2-0.20261006083714-760eef8e0b6c
	google.golang.org/grpc v1.85.0
)

require (
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.33.0 // indirect
	github.com/mattn/go-colorable v0.1.16 // indirect
	github.com/mattn/go-isatty v0.0.24 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/rs/zerolog v1.35.1 // indirect
	golang.org/x/net v0.62.0 // indirect
	golang.org/x/sys v0.49.0 // indirect
	golang.org/x/text v0.43.0 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20261026165753-2ffab32bce7e // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20261026165753-2ffab32bce7e // indirect
	google.golang.org/protobuf v1.36.12 // indirect
)
