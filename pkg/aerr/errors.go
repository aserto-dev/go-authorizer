package aerr

import (
	"net/http"

	"github.com/aserto-dev/errors"
	"google.golang.org/grpc/codes"
)

var (
	// Means no tenant id was found in the current context
	ErrNoTenantID = newErr("E30001", codes.InvalidArgument, http.StatusBadRequest, "no tenant id specified")
	// Means the tenant id is not valid
	ErrInvalidTenantID = newErr("E30002", codes.InvalidArgument, http.StatusBadRequest, "invalid tenant id")
	// The asked-for runtime is not yet available, but will likely be in the future.
	ErrRuntimeLoading = newErr("E30003", codes.Unavailable, http.StatusTooEarly, "runtime has not yet loaded")
	// Returned if a policy id is not found in the database
	ErrPolicyNotFound = newErr("E10004", codes.NotFound, http.StatusNotFound, "policy not found")
	// Returned if a policy id is invalid
	ErrInvalidPolicyID = newErr("E30005", codes.InvalidArgument, http.StatusBadRequest, "invalid policy id")
	// Return if a user already exists
	ErrUserAlreadyExists = newErr("E30006", codes.AlreadyExists, http.StatusConflict, "user already exists")
	// Returned when authentication has failed or is not possible
	ErrAuthenticationFailed = newErr("E30007", codes.Unauthenticated, http.StatusUnauthorized, "authentication failed")
	// Returned when a given parameter is incorrect (wrong format, value or type)
	ErrInvalidArgument = newErr("E30008", codes.InvalidArgument, http.StatusBadRequest, "invalid argument")
	// Return if a user is not found
	ErrUserNotFound = newErr("E30009", codes.NotFound, http.StatusNotFound, "user not found")
	// Returned when a runtime query has an error
	ErrBadQuery = newErr("E30010", codes.InvalidArgument, http.StatusBadRequest, "invalid query")
	// Returned when a decision is invalid
	ErrInvalidDecision = newErr("E30011", codes.InvalidArgument, http.StatusBadRequest, "invalid decision")
	// Returned when a runtime failed to load
	ErrBadRuntime = newErr("E30012", codes.Unavailable, http.StatusServiceUnavailable, "runtime loading failed")
	// Returned if object object id is not found in the directory
	ErrDirectoryObjectNotFound = newErr("E30013", codes.NotFound, http.StatusNotFound, "directory object not found")
	// Returned if the loaded policy is invalid.
	ErrInvalidPolicy = newErr("E30014", codes.Internal, http.StatusInternalServerError, "invalid policy")
	// Returned when authorization has failed or is not possible
	ErrAuthorizationFailed = newErr("E30015", codes.PermissionDenied, http.StatusUnauthorized, "authorization failed")
)

func newErr(code string, statusCode codes.Code, httpCode int, msg string) *errors.AsertoError {
	return errors.NewAsertoError(code, statusCode, httpCode, msg)
}
