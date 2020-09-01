namespace java com.rbkmoney.pstds.base
namespace erlang pstds_base

typedef i64 EventID
typedef i32 SequenceID
typedef string Timestamp
typedef string Token
typedef string PaymentToken
typedef string EnrollmentID
typedef string PanAccountReference
typedef i64 TokenRevision

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
union TokenStatus {
    1: InactiveToken inactive
    2: ActiveToken active
    3: SuspendedToken suspended
    4: DeletedToken deleted
}

struct InactiveToken{}
struct ActiveToken {}
struct SuspendedToken {}
struct DeletedToken {}

/** Дата экспирации */
struct TokenExpDate {
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
    * Платёжная система
    **/
    3: required PaymentSystem payment_system

    /**
    * Статус токена
    **/
    4: required TokenStatus status

    /**
    * Дата экспирации токена
    **/
    5: optional TokenExpDate exp_date

    /**
    * Уникальный идентификатор карты в МПС (аналоги и замена PAN)
    **/
    6: optional PanAccountReference pan_account_reference
}
