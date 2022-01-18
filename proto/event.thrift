namespace java dev.vality.pstds.event
namespace erlang pstds_event

include "base.thrift"

struct TimestampedChange {
    1: required base.Timestamp occured_at
    2: required Change change
}

union Change {
    1: TokenCreated token_created
    2: StatusChanged status_changed
}

struct TokenCreated {
    1: required base.PaymentSystemTokenData token_data
}

struct StatusChanged {
    1: required base.TokenStatus new_status
}
