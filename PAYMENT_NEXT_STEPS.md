# GUTENG 支付接入待办

当前仅预留 `/api/payments/status`，明确返回 disabled。请先向 PayPal 中国确认：个人卖家账户是否能为 GUTENG 独立站开通 PayPal Checkout/API、支持的币种、结算银行账户、网站审核要求及退款/争议权限。

获得书面/后台批准后，再实现服务端 OAuth token、create order、capture、webhook signature verification、幂等事件处理和退款。未获批前不得切换 Live，不得收真实款。
