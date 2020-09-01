namespace java com.rbkmoney.pstds.storage
namespace erlang pstds_storage

include "base.thrift"

struct PaymentSystemTokenResult {
    1: required base.Token payment_system_token
}

exception InvalidCardData {
    1: optional string reason
}

exception PaymentSystemTokenNotFound{}

exception InvalidPaymentSystemToken {
    1: optional string reason
}

/**
 * Интерфейс для приложений
 */
service Storage {

    /** Получить данные платёжного токена */
    base.PaymentSystemTokenData GetPaymentSystemTokenData(1: base.Token token, 2: base.TokenRevision revision)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Получить данные активного платёжного токена по токену банковской карты */
    base.PaymentSystemTokenData GetPaymentSystemTokenByBankCardToken(1: base.Token token)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Сохранить платёжный токен */
    PaymentSystemTokenResult PutPaymentSystemToken(
        1: base.PaymentSystemTokenData payment_system_token,
        2: base.Token bank_card_token
    )
        throws (1: InvalidPaymentSystemToken invalid)

    /** Обновить статус платёжного токена
    * Параметры:
    * - token - параметры токена, ревизия - latest
    * - updated_status - статус токена, полученный от МПС
    * - updated_at - время обновления статуса у МПС
    **/
    void UpdatePaymentSystemTokenStatus(
        1: base.Token token,
        2: base.TokenStatus updated_status,
        3: base.Timestamp updated_at
    )
        throws (1: PaymentSystemTokenNotFound not_found)

    base.TokenRevision GetTokenRevision(1: base.Token token)
        throws (1: PaymentSystemTokenNotFound not_found)

}

