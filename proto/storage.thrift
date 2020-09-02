namespace java com.rbkmoney.pstds.storage
namespace erlang pstds_storage

include "base.thrift"

struct PaymentSystemTokenResult {
    1: required base.Token payment_system_token
}

exception PaymentSystemTokenNotFound{}

exception InvalidTokenExpData {}

/**
 * Интерфейс для приложений
 */
service Storage {

    /** Получить данные платёжного токена */
    base.PaymentSystemTokenData GetPaymentSystemTokenData(1: base.Token token, 2: base.TokenRevision revision)
        throws (1: PaymentSystemTokenNotFound not_found)

    /** Сохранить платёжный токен */
    PaymentSystemTokenResult PutPaymentSystemToken(
        1: base.PaymentSystemTokenData payment_system_token,
        2: base.Token bank_card_token
    )
        throws (1: InvalidTokenExpData invalid_exp_data)

    /** Обновить статус платёжного токена
    * Параметры:
    * - token - параметры токена, ревизия - latest
    **/
    void UpdatePaymentSystemTokenStatus(
        1: base.Token token,
        2: base.TokenStatus updated_status
    )
        throws (1: PaymentSystemTokenNotFound not_found)

    base.TokenRevision GetTokenRevision(1: base.Token token)
        throws (1: PaymentSystemTokenNotFound not_found)

}

