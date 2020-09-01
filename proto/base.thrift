namespace java com.rbkmoney.pstds.base
namespace erlang pstds_base

typedef i64 EventID
typedef i32 SequenceID
typedef string Timestamp
typedef string Token
typedef string PaymentToken
typedef string EnrollmentID

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

/** Дата экспирации */
struct ExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

struct PaymentSystemTokenData {
    /**
    * Токен МПС:
    * - VISA: vProvisionedTokenID
    * - MASTERCARD: tokenUniqueReference
    * - NSPKMIR: tokenNumber
    **/
    1: required PaymentToken token_id

    /**
    * Энролмент МПС:
    * - VISA: vPanEnrollmentID
    * - MASTERCARD: panUniqueReference
    * - NSPKMIR: subscriptionID (?)
    **/
    2: required EnrollmentID enrollment_id

    /**
    * Идентификатор МПС
    **/
    3: required PaymentSystem payment_system

    /**
    * Статус токена
    **/
    4: required TokenStatus status

    /**
    * Токен банковской карты, для которого выписан токен МПС
    **/
    5: required Token bank_card_token

    /**
    * Дата экспирации токена
    **/
    6: optional ExpDate exp_date

    /**
    * Уникальный идентификатор карты в МПС (аналоги и замена PAN)
    **/
    7: optional string pan_account_reference
}
