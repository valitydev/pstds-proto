namespace java com.rbkmoney.pstds.storage
namespace erlang pstds

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

typedef string PaymentSessionID

/** Дата экспирации */
struct ExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

union TokenRevision {
    1: Latest latest
    2: Revision revision
}

struct Latest{}
struct Revision {
    1: required i32 revision
}

struct PaymentSystemTokenData {
    /**
    * Токен МПС:
    * - VISA: vProvisionedTokenID
    * - MASTERCARD: tokenUniqueReference
    * - NSPKMIR: tokenNumber
    **/
    1: required PaymentToken tokenID

    /**
    * Энролмент МПС:
    * - VISA: vPanEnrollmentID
    * - MASTERCARD: panUniqueReference
    * - NSPKMIR: subscriptionID (?)
    **/
    2: required EnrollmentID enrollmentID

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

struct PaymentSystemToken {
    1: required Token token
    2: required PaymentSystem payment_system
    3: required Revision revision
}

struct PutPaymentSystemTokenResult {
    1: required PaymentSystemToken payment_system_token
}

exception InvalidCardData {
    1: optional string reason
}

exception CardDataNotFound {}

exception SessionDataNotFound {}

exception PaymentSystemTokenNotFound{}

exception InvalidPaymentSystemToken {
    1: optional string reason
}

/**
 * Интерфейс для приложений
 *
 * При недоступности (отсутствии или залоченности) кейринга сервис сигнализирует об этом с помощью
 * woody-ошибки `Resource Unavailable`.
 */
service Storage {

    /** Получить данные платёжного токена */
    PaymentSystemTokenData GetPaymentSystemTokenData(1: PaymentSystemToken token)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Получить данные активного платёжного токена по токену банковской карты */
    PaymentSystemTokenData GetPaymentSystemTokenByBankCardToken(1: PaymentSystemToken token)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Сохранить платёжный токен */
    PutPaymentSystemTokenResult PutPaymentSystemToken(1: PaymentSystemTokenData payment_system_token)
        throws (1: InvalidPaymentSystemToken invalid)

    /** Обновить статус платёжного токена
    * Параметры:
    * - token - параметры токена, ревизия - latest
    * - updated_status - статус токена, полученный от МПС
    * - updated_at - время обновления статуса у МПС
    **/
    void UpdatePaymentSystemTokenStatus(
        1: PaymentSystemToken token,
        2: TokenStatus updated_status,
        3: Timestamp updated_at
    )
        throws (1: PaymentSystemTokenNotFound not_found)
}

/// Event sink

typedef i64 EventID
typedef i32 SequenceID
typedef string Timestamp

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

exception NoLastEvent {}

struct Event {
    1: required SequenceID sequence
    2: required Timestamp occured_at
    3: required Change change
}

union Change {
    1: StatusChanged change
}

struct StatusChanged {
    1: required TokenStatus new_status
}

struct SinkEvent {
    1: required EventID id
    2: required Timestamp created_at
    4: required Event payload
}

service EventSink {

    list<SinkEvent> GetEvents (1: EventRange range)
        throws ()

    EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}