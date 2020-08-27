namespace java com.rbkmoney.pstds.storage
namespace erlang pstds

include "base.thrift"

typedef string PaymentToken
typedef string EnrollmentID

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
    3: required base.PaymentSystem payment_system

    /**
    * Статус токена
    **/
    4: required base.TokenStatus status

    /**
    * Токен банковской карты, для которого выписан токен МПС
    **/
    5: required base.Token bank_card_token

    /**
    * Дата экспирации токена
    **/
    6: optional ExpDate exp_date

    /**
    * Уникальный идентификатор карты в МПС (аналоги и замена PAN)
    **/
    7: optional string pan_account_reference
}

struct PutPaymentSystemTokenResult {
    1: required base.PaymentSystemToken payment_system_token
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
    PaymentSystemTokenData GetPaymentSystemTokenData(1: base.PaymentSystemToken token)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Получить данные активного платёжного токена по токену банковской карты */
    PaymentSystemTokenData GetPaymentSystemTokenByBankCardToken(1: base.PaymentSystemToken token)
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
        1: base.PaymentSystemToken token,
        2: base.TokenStatus updated_status,
        3: base.Timestamp updated_at
    )
        throws (1: PaymentSystemTokenNotFound not_found)
}

