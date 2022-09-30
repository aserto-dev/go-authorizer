// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             (unknown)
// source: aserto/authorizer/v2/authorizer.proto

package authorizer

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// AuthorizerClient is the client API for Authorizer service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type AuthorizerClient interface {
	DecisionTree(ctx context.Context, in *DecisionTreeRequest, opts ...grpc.CallOption) (*DecisionTreeResponse, error)
	Is(ctx context.Context, in *IsRequest, opts ...grpc.CallOption) (*IsResponse, error)
	Query(ctx context.Context, in *QueryRequest, opts ...grpc.CallOption) (*QueryResponse, error)
	Compile(ctx context.Context, in *CompileRequest, opts ...grpc.CallOption) (*CompileResponse, error)
}

type authorizerClient struct {
	cc grpc.ClientConnInterface
}

func NewAuthorizerClient(cc grpc.ClientConnInterface) AuthorizerClient {
	return &authorizerClient{cc}
}

func (c *authorizerClient) DecisionTree(ctx context.Context, in *DecisionTreeRequest, opts ...grpc.CallOption) (*DecisionTreeResponse, error) {
	out := new(DecisionTreeResponse)
	err := c.cc.Invoke(ctx, "/aserto.authorizer.v2.Authorizer/DecisionTree", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *authorizerClient) Is(ctx context.Context, in *IsRequest, opts ...grpc.CallOption) (*IsResponse, error) {
	out := new(IsResponse)
	err := c.cc.Invoke(ctx, "/aserto.authorizer.v2.Authorizer/Is", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *authorizerClient) Query(ctx context.Context, in *QueryRequest, opts ...grpc.CallOption) (*QueryResponse, error) {
	out := new(QueryResponse)
	err := c.cc.Invoke(ctx, "/aserto.authorizer.v2.Authorizer/Query", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *authorizerClient) Compile(ctx context.Context, in *CompileRequest, opts ...grpc.CallOption) (*CompileResponse, error) {
	out := new(CompileResponse)
	err := c.cc.Invoke(ctx, "/aserto.authorizer.v2.Authorizer/Compile", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AuthorizerServer is the server API for Authorizer service.
// All implementations should embed UnimplementedAuthorizerServer
// for forward compatibility
type AuthorizerServer interface {
	DecisionTree(context.Context, *DecisionTreeRequest) (*DecisionTreeResponse, error)
	Is(context.Context, *IsRequest) (*IsResponse, error)
	Query(context.Context, *QueryRequest) (*QueryResponse, error)
	Compile(context.Context, *CompileRequest) (*CompileResponse, error)
}

// UnimplementedAuthorizerServer should be embedded to have forward compatible implementations.
type UnimplementedAuthorizerServer struct {
}

func (UnimplementedAuthorizerServer) DecisionTree(context.Context, *DecisionTreeRequest) (*DecisionTreeResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method DecisionTree not implemented")
}
func (UnimplementedAuthorizerServer) Is(context.Context, *IsRequest) (*IsResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Is not implemented")
}
func (UnimplementedAuthorizerServer) Query(context.Context, *QueryRequest) (*QueryResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Query not implemented")
}
func (UnimplementedAuthorizerServer) Compile(context.Context, *CompileRequest) (*CompileResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Compile not implemented")
}

// UnsafeAuthorizerServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to AuthorizerServer will
// result in compilation errors.
type UnsafeAuthorizerServer interface {
	mustEmbedUnimplementedAuthorizerServer()
}

func RegisterAuthorizerServer(s grpc.ServiceRegistrar, srv AuthorizerServer) {
	s.RegisterService(&Authorizer_ServiceDesc, srv)
}

func _Authorizer_DecisionTree_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(DecisionTreeRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AuthorizerServer).DecisionTree(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/aserto.authorizer.v2.Authorizer/DecisionTree",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AuthorizerServer).DecisionTree(ctx, req.(*DecisionTreeRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _Authorizer_Is_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(IsRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AuthorizerServer).Is(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/aserto.authorizer.v2.Authorizer/Is",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AuthorizerServer).Is(ctx, req.(*IsRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _Authorizer_Query_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(QueryRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AuthorizerServer).Query(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/aserto.authorizer.v2.Authorizer/Query",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AuthorizerServer).Query(ctx, req.(*QueryRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _Authorizer_Compile_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CompileRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(AuthorizerServer).Compile(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/aserto.authorizer.v2.Authorizer/Compile",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(AuthorizerServer).Compile(ctx, req.(*CompileRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// Authorizer_ServiceDesc is the grpc.ServiceDesc for Authorizer service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var Authorizer_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "aserto.authorizer.v2.Authorizer",
	HandlerType: (*AuthorizerServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "DecisionTree",
			Handler:    _Authorizer_DecisionTree_Handler,
		},
		{
			MethodName: "Is",
			Handler:    _Authorizer_Is_Handler,
		},
		{
			MethodName: "Query",
			Handler:    _Authorizer_Query_Handler,
		},
		{
			MethodName: "Compile",
			Handler:    _Authorizer_Compile_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "aserto/authorizer/v2/authorizer.proto",
}
