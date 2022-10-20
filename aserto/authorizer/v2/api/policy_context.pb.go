// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.28.1
// 	protoc        (unknown)
// source: aserto/authorizer/v2/api/policy_context.proto

package api

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type PolicyContext struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Path      string   `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`           // policy path aka package name
	Decisions []string `protobuf:"bytes,2,rep,name=decisions,proto3" json:"decisions,omitempty"` // list (1..N) of policy decisions (aka rules)
}

func (x *PolicyContext) Reset() {
	*x = PolicyContext{}
	if protoimpl.UnsafeEnabled {
		mi := &file_aserto_authorizer_v2_api_policy_context_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PolicyContext) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PolicyContext) ProtoMessage() {}

func (x *PolicyContext) ProtoReflect() protoreflect.Message {
	mi := &file_aserto_authorizer_v2_api_policy_context_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PolicyContext.ProtoReflect.Descriptor instead.
func (*PolicyContext) Descriptor() ([]byte, []int) {
	return file_aserto_authorizer_v2_api_policy_context_proto_rawDescGZIP(), []int{0}
}

func (x *PolicyContext) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *PolicyContext) GetDecisions() []string {
	if x != nil {
		return x.Decisions
	}
	return nil
}

var File_aserto_authorizer_v2_api_policy_context_proto protoreflect.FileDescriptor

var file_aserto_authorizer_v2_api_policy_context_proto_rawDesc = []byte{
	0x0a, 0x2d, 0x61, 0x73, 0x65, 0x72, 0x74, 0x6f, 0x2f, 0x61, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69,
	0x7a, 0x65, 0x72, 0x2f, 0x76, 0x32, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x70, 0x6f, 0x6c, 0x69, 0x63,
	0x79, 0x5f, 0x63, 0x6f, 0x6e, 0x74, 0x65, 0x78, 0x74, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12,
	0x18, 0x61, 0x73, 0x65, 0x72, 0x74, 0x6f, 0x2e, 0x61, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69, 0x7a,
	0x65, 0x72, 0x2e, 0x76, 0x32, 0x2e, 0x61, 0x70, 0x69, 0x22, 0x41, 0x0a, 0x0d, 0x50, 0x6f, 0x6c,
	0x69, 0x63, 0x79, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x78, 0x74, 0x12, 0x12, 0x0a, 0x04, 0x70, 0x61,
	0x74, 0x68, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x04, 0x70, 0x61, 0x74, 0x68, 0x12, 0x1c,
	0x0a, 0x09, 0x64, 0x65, 0x63, 0x69, 0x73, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0x02, 0x20, 0x03, 0x28,
	0x09, 0x52, 0x09, 0x64, 0x65, 0x63, 0x69, 0x73, 0x69, 0x6f, 0x6e, 0x73, 0x42, 0x5d, 0x5a, 0x40,
	0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x61, 0x73, 0x65, 0x72, 0x74,
	0x6f, 0x2d, 0x64, 0x65, 0x76, 0x2f, 0x67, 0x6f, 0x2d, 0x61, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69,
	0x7a, 0x65, 0x72, 0x2f, 0x61, 0x73, 0x65, 0x72, 0x74, 0x6f, 0x2f, 0x61, 0x75, 0x74, 0x68, 0x6f,
	0x72, 0x69, 0x7a, 0x65, 0x72, 0x2f, 0x76, 0x32, 0x2f, 0x61, 0x70, 0x69, 0x3b, 0x61, 0x70, 0x69,
	0xaa, 0x02, 0x18, 0x41, 0x73, 0x65, 0x72, 0x74, 0x6f, 0x2e, 0x41, 0x75, 0x74, 0x68, 0x6f, 0x72,
	0x69, 0x7a, 0x65, 0x72, 0x2e, 0x56, 0x32, 0x2e, 0x41, 0x50, 0x49, 0x62, 0x06, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x33,
}

var (
	file_aserto_authorizer_v2_api_policy_context_proto_rawDescOnce sync.Once
	file_aserto_authorizer_v2_api_policy_context_proto_rawDescData = file_aserto_authorizer_v2_api_policy_context_proto_rawDesc
)

func file_aserto_authorizer_v2_api_policy_context_proto_rawDescGZIP() []byte {
	file_aserto_authorizer_v2_api_policy_context_proto_rawDescOnce.Do(func() {
		file_aserto_authorizer_v2_api_policy_context_proto_rawDescData = protoimpl.X.CompressGZIP(file_aserto_authorizer_v2_api_policy_context_proto_rawDescData)
	})
	return file_aserto_authorizer_v2_api_policy_context_proto_rawDescData
}

var file_aserto_authorizer_v2_api_policy_context_proto_msgTypes = make([]protoimpl.MessageInfo, 1)
var file_aserto_authorizer_v2_api_policy_context_proto_goTypes = []interface{}{
	(*PolicyContext)(nil), // 0: aserto.authorizer.v2.api.PolicyContext
}
var file_aserto_authorizer_v2_api_policy_context_proto_depIdxs = []int32{
	0, // [0:0] is the sub-list for method output_type
	0, // [0:0] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_aserto_authorizer_v2_api_policy_context_proto_init() }
func file_aserto_authorizer_v2_api_policy_context_proto_init() {
	if File_aserto_authorizer_v2_api_policy_context_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_aserto_authorizer_v2_api_policy_context_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PolicyContext); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_aserto_authorizer_v2_api_policy_context_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   1,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_aserto_authorizer_v2_api_policy_context_proto_goTypes,
		DependencyIndexes: file_aserto_authorizer_v2_api_policy_context_proto_depIdxs,
		MessageInfos:      file_aserto_authorizer_v2_api_policy_context_proto_msgTypes,
	}.Build()
	File_aserto_authorizer_v2_api_policy_context_proto = out.File
	file_aserto_authorizer_v2_api_policy_context_proto_rawDesc = nil
	file_aserto_authorizer_v2_api_policy_context_proto_goTypes = nil
	file_aserto_authorizer_v2_api_policy_context_proto_depIdxs = nil
}
