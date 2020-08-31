namespace java com.rbkmoney.pstds.event
namespace erlang pstds_event

include "base.thrift"

struct Event {
    1: required base.SequenceID sequence
    2: required base.Timestamp occured_at
    3: required Change change
}

union Change {
    1: TokenCreated token_created
    2: StatusChanged status_changed
}

struct TokenCreated {
    1: base.PaymentSystemTokenData token_data
}

struct StatusChanged {
    2: required base.TokenStatus new_status
}
