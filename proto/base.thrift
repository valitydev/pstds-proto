typedef i64 EventID
typedef i32 SequenceID
typedef string Timestamp
typedef string Token

/**
* Поддерживаемые платёжные системы
**/
enum PaymentSystem {
    visa
    mastercard
    nspkmir
}

/**
* Статус токена МПС
**/
enum TokenStatus {
    inactive
    active
    suspended
    deleted
}

/**
* Ревизия токена
**/
struct Latest{}
struct Revision {
    1: required i32 revision
}

union TokenRevision {
    1: Latest latest
    2: Revision revision
}

/**
* Токен платёжной системы
**/
struct PaymentSystemToken {
    1: required Token token
    2: required PaymentSystem payment_system
    3: required Revision revision
}
