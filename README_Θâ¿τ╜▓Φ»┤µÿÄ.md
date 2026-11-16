# GUTENG Cloudflare 商品后台开发包

本开发包基于此前第四版 GUTENG PWA 页面制作，增加 Cloudflare Workers + D1 商品管理 API 和管理员后台。

## 本版已经实现
- 前台商品从 D1 数据库读取，不再使用写死的演示商品数据。
- `/admin.html` 管理员登录。
- 新增、编辑、上架、下架、归档商品。
- 商品字段：名称、SKU、分类、描述、CNY售价、库存、图片URL、市场代码、各市场售价JSON、履约方式。
- 管理员会话由 Worker 服务端签发，HttpOnly + Secure + SameSite=Strict Cookie；密码通过 Cloudflare Worker Secret 提供，不写入前端。
- 未配置真实支付时，前台明确不开放结算，避免误收款或生成虚假订单。

## 重要边界
- 这是可部署的开发起步包，不是已经部署到你的 Cloudflare 账户的系统。
- 当前没有真实订单、客户账户、物流报价、R2图片上传、税费计算、PayPal正式收款或退款流程。
- 各市场价格需人工确认后录入，系统不自动编造汇率。
- 前台购物车目前仅保存在顾客自己的浏览器；真实订单和结账要在下一阶段开发。
- 目前图片通过 HTTPS 图片URL引用；后续可绑定 Cloudflare R2 做图片上传。
- 公开上架前，需确认商品合法销售、目标市场税费、进口责任、消费者退货规则、隐私政策与物流服务。

## Cloudflare 部署步骤

### 1. 创建 D1 数据库
在 Cloudflare Dashboard -> Workers & Pages -> D1 SQL Database -> Create database，名称建议 `guteng-db`。
也可以在本地终端运行：

```bash
npm install
npx wrangler d1 create guteng-db
```

将创建结果中的 `database_id` 填入 `wrangler.jsonc`，替换占位文字。

### 2. 执行数据库迁移

```bash
npx wrangler d1 migrations apply guteng-db --remote
```

### 3. 配置后台密码和会话密钥

```bash
npx wrangler secret put ADMIN_PASSWORD
npx wrangler secret put SESSION_SECRET
```

分别输入一个强管理员密码，以及一段至少 32 字符的随机会话密钥。不要把这两个值写进代码或发给任何人。

### 4. 安装并部署

```bash
npm install
npx wrangler deploy
```

Worker 部署完成后会得到 `workers.dev` 地址。测试：
- `/api/health` 应返回 `ok: true`
- `/` 打开商城
- `/admin.html` 打开商品管理后台

### 5. 首次上架商品
进入 `/admin.html`，使用刚设置的 `ADMIN_PASSWORD` 登录，点击新增商品，填写真实商品信息、SKU、价格、库存、市场代码，先保存为草稿；核对后再切换为上架。

## 现有 Cloudflare 网站如何更新
本包不会自动覆盖你当前的 Worker。先在 Cloudflare Dashboard 确认现有部署是 Git 集成还是直接上传/编辑 Worker。建议先创建一个新的测试 Worker（例如 `guteng-storefront-test`），完成测试后再把正式域名或路由切换到新 Worker。不要直接删除当前线上版本。

## 下一阶段
1. 订单服务端化：D1订单表、库存预留、地址加密/最小化保存、订单查询。
2. PayPal Sandbox：只有确认中国个人卖家账户获准用于独立站 Checkout 后才接入；后端创建订单、金额校验、捕获、Webhook 验签与幂等处理。
3. Cloudflare R2 图片上传与权限控制。
4. 多币种报价、真实物流报价、拆包履约和税费合规规则。

支付配置：默认 Sandbox，当前没有支付按钮，也不会接收真实付款。绝不能把 PayPal Secret 放进网页前端。
