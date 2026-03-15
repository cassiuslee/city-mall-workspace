# 前端分析与 API 文档冲突报告

对比范围：

- 前端分析：`docs/frontend-analysis/*`
- API 文档：`api-docs/index.md`、`api-docs/llms.txt`、`api-docs/apifox-md/**/*`

判定原则：

1. 以前端真实使用为最高优先级
2. API 文档中与前端不一致的地方全部显式记录
3. 最终后端合同以“前端可直接接入”为目标，而不是机械照抄 Apifox

## 全局冲突

### 响应包装结构冲突

- 前端统一请求封装 `city-mall-web/src/utils/http.ts` 把响应当作 `{ code, msg, result }` 处理。
- Apifox 多数接口文档只声明了 `msg` 和 `result`，没有声明 `code`。
- 结论：最终后端合同必须保留 `code`、`msg`、`result` 三段式包装，否则与前端现有类型假设不一致。

### 鉴权头约定存在文档表达差异

- 总说明 `api-docs/apifox-md/doc-1521513.md` 要求 header 包含 `source-client: miniapp`，这与前端一致。
- Apifox 某些接口示例把 `Authorization` 写成 `Bearer {{token}}`，但前端实际发送的是裸 token：`Authorization: <token>`。
- 结论：后端实现应兼容当前前端的裸 token 方案，至少不要强制要求 `Bearer ` 前缀。

### 文档覆盖范围大于前端实际使用

- API 文档包含搜索模块、刷新 token、首页新鲜好物等接口。
- 当前前端没有对应 service 或页面闭环。
- 结论：这些接口不能直接当作当前阶段后端必做项，应降级为“文档存在但前端未落地”的能力。

## home

### 冲突 1：文档存在 `/home/new`，前端完全未接入

- 文档：`api-docs/apifox-md/api-43426883.md` 定义 `GET /home/new`
- 前端：`src/services/home.ts` 没有该接口，首页页面也没有调用
- 影响：不能把 `/home/new` 视为当前前端首页合同的一部分
- 结论：当前 home 模块以 `/home/banner`、`/home/category/mutli`、`/home/hot/mutli`、`/home/goods/guessLike` 为准

### 冲突 2：首页分类/热门接口已请求，但页面模板部分被注释

- 前端仍会请求 `/home/category/mutli`、`/home/hot/mutli`
- 但首页当前主要展示轮播和猜你喜欢
- 影响：后端仍需实现接口，不能因模板暂时注释就删除

### 冲突 3：热门推荐文档按四个独立接口组织，前端用一个通用 service 动态拼 URL

- 文档：`llms.txt` 中按 `/hot/preference`、`/hot/inVogue`、`/hot/oneStop`、`/hot/new` 分别列出
- 前端：`src/services/hot.ts` 的 `getHotRecommendAPI(url, data)` 允许页面传任意热门推荐 URL
- 影响：后端需要保证这四个路径的返回结构完全一致，才能被前端复用同一个 service

## category

### 冲突 1：分类页“全部”入口在前端存在，但文档没有对应商品列表合同

- 前端：`src/pages/category/category.vue` 存在“全部”入口，但没有跳转和 service
- 文档：当前只有 `/category/top`，没有清晰的二级分类商品列表接口纳入现行前端合同
- 影响：分类页无法扩展为完整列表页闭环
- 结论：`/category/top` 是当前唯一有效合同；二级分类商品列表属于待补能力

## product

### 冲突 1：商品详情文档字段远多于前端实际消费字段

- 文档：`api-docs/apifox-md/api-43426903.md` 包含 `spuCode`、`brand`、`salesCount`、`commentCount`、`collectCount`、`mainVideos`、`videoScale`、`categories`、`isCollect`、`hotByDay`、`evaluationInfo` 等大量字段
- 前端：`src/pages/goods/goods.vue` 主要使用 `id/name/desc/price/oldPrice/mainPictures/details/skus/specs/similarProducts/userAddresses`
- 影响：如果完全按文档建模，后端会输出很多当前无消费价值的字段
- 结论：最终商品详情合同应以前端实际消费字段为必需项，其余字段标记为可选扩展

### 冲突 2：`userAddresses` 在商品详情文档中几乎是空能力

- 文档：`api-43426903.md` 里 `userAddresses` 被声明为 `null`
- 前端类型：`GoodsResult.userAddresses: AddressItem[]`
- 前端页面：商品详情页实际上也没有真正消费这个字段，只是类型中保留
- 影响：文档、类型、页面三者不一致
- 结论：商品详情正式合同里不把 `userAddresses` 作为必需字段；如保留则必须改成地址数组结构，而不是 `null`

### 冲突 3：同类推荐旧接口已废弃，但文档索引仍保留

- 文档：`llms.txt` 保留了 `/goods/relevant`，并说明应改用详情里的 `similarProducts`
- 前端：只使用 `similarProducts`
- 结论：最终合同不纳入 `/goods/relevant`

### 冲突 4：收藏能力在文档/前端主流程中都未形成正式闭环

- 前端 UI 有“收藏”按钮
- 当前 API 文档没有与前端现状对应的收藏接口被纳入使用链路
- 结论：收藏是产品缺口，不是现有 product 合同的一部分

## auth

### 冲突 1：文档存在刷新 token，前端没有调用链

- 文档：`api-docs/apifox-md/api-43426848.md` 定义 `PUT /login/refresh`
- 前端：没有对应 service、没有 401 后刷新逻辑；401 直接清空登录态并跳登录页
- 影响：当前后端不应假设前端会自动刷新 token
- 结论：刷新 token 属于文档存在但前端未接入能力

### 冲突 2：登录返回体文档与前端最小需求存在差异

- 前端实际最小要求：`id/avatar/account/nickname?/mobile/token`
- 刷新 token 文档返回更多字段，如 `gender/birthday/cityCode/provinceCode/profession`
- 影响：登录接口不需要强制返回 profile 全量字段，只要满足前端登录态字段即可
- 结论：登录成功返回以 `LoginResult` 为准，扩展字段可选

### 冲突 3：`Authorization` 示例前缀不一致

- 刷新 token 文档示例为 `Bearer {{token}}`
- 前端统一发送裸 token
- 结论：后端需兼容裸 token

## address

### 冲突 1：预订单地址结构比地址列表文档多 `postalCode`

- 文档：`api-43426937.md` 中 `userAddresses[]` 含 `postalCode`
- 地址列表文档：`api-43426956.md` 不含 `postalCode`
- 前端：`AddressItem` 也不含 `postalCode`
- 影响：同一地址对象在不同接口中的结构不一致
- 结论：最终合同统一以前端 `AddressItem` 为准，不要求 `postalCode`

### 冲突 2：前端地址页存在 `from=order` 场景参数，但文档无场景模式说明

- 前端：订单确认页跳转 `/pagesMember/address/address?from=order`
- 页面当前未消费该参数，文档也没有“地址选择模式”约定
- 影响：地址模块当前只形成基础 CRUD 合同，没有场景化规则合同

## cart

### 冲突 1：购物车文档字段多于前端实际类型

- 文档：`api-docs/apifox-md/api-43426918.md` 还包含 `isCollect`、`discount`
- 前端类型：`CartItem` 只定义到 `isEffective`，不含 `isCollect`、`discount`
- 前端页面：也没有消费这两个字段
- 影响：文档字段超出前端实际需要
- 结论：最终购物车合同以 `id/skuId/name/picture/count/price/nowPrice/stock/selected/attrsText/isEffective` 为必需字段

### 冲突 2：删除购物车接口的 `ids` 语义需要以前端实现解释

- 前端删除时传的是 SKU ID 数组
- 文档标题写“删除/清空购物车单品”，但如果后端按 SPU 处理会不兼容
- 结论：`DELETE /member/cart` 中 `ids` 必须按 SKU ID 处理

## order

### 冲突 1：预订单文档金额字段是 `number`，前端类型里部分写成 `string`

- 文档：`api-43426937.md` 中 `goods[].price/payPrice/totalPrice/totalPayPrice` 是 `number`
- 前端：`src/types/order.d.ts` 中这些字段多为 `string`
- 前端页面：会直接展示，有时调用 `toFixed` 的是 `summary` 下字段而不是 `goods[]`
- 影响：金额字段类型不统一
- 结论：最终合同统一使用 `number`，前端类型后续应向合同靠齐

### 冲突 2：订单详情/列表文档中多个分页与数量字段被写成 `string`

- 文档：`api-43426944.md` 中 `pageSize/pages/page/totalNum` 是 `string`
- 文档：`api-43426945.md` 中 `postFee/payMoney/totalMoney/totalNum/quantity` 等部分字段也是 `string`
- 前端类型：这些字段大多定义为 `number`
- 页面逻辑：存在数值判断、状态判断、金额展示
- 影响：若后端真返回字符串，会增加前端转换负担且不符合现有类型
- 结论：最终合同统一这些数值型字段为 `number`

### 冲突 3：订单详情文档字段大于前端实际消费

- 文档包含 `payLatestTime`、`payType`、`payChannel`、`totalNum`、`deliveryTimeType`、`payTime`、`consignTime`、`arrivalEstimatedTime`、`endTime`、`closeTime`、`evaluationTime` 等
- 前端当前核心只消费 `id/orderState/countdown/skus/receiverContact/receiverMobile/receiverAddress/createTime/totalMoney/postFee/payMoney`
- 结论：这些额外字段可保留，但不能作为当前前端对接的必需项

### 冲突 4：取消订单 service 命名误导，文档方法才是准确信号

- 前端 service 名：`getMemberOrderCancelByIdAPI`
- 实际请求：`PUT /member/order/:id/cancel`
- 文档：也是 `PUT`
- 结论：后端以 `PUT` 实现，不受前端函数名影响

### 冲突 5：订单列表和详情的 SKU 结构在文档里更复杂，但前端只消费扁平文案 `attrsText`

- 文档同时提供 `properties[]` 和 `attrsText`
- 前端只直接使用 `attrsText`
- 结论：最终合同必须保留 `attrsText`；`properties[]` 可作为附加字段保留

## payment

### 冲突 1：真实支付文档已完整，前端主流程仍走 mock

- 文档：`api-docs/apifox-md/api-44647433.md` 完整定义了微信支付参数
- 前端：订单详情、订单列表中真实支付代码注释掉，默认调用 `/pay/mock`
- 影响：支付文档与真实运行流程不一致
- 结论：当前 payment 模块必须同时保留 `mock` 与 `wxPay/miniPay` 两个合同，其中 `mock` 是当前前端主路径

### 冲突 2：支付成功后的状态确认没有形成正式接口合同

- 文档没有显式支付状态查询接口
- 前端支付结果页也不查订单状态
- 结论：这是文档与前端共同缺失的能力，需要在最终合同里新增建议项，但不算现有接口的一部分

## 文档存在但不纳入当前最终合同的接口

### 搜索模块

- `POST /search/all`
- `GET /search/tips`

原因：

- 前端当前没有对应 service 和结果页闭环
- 仅有 UI 占位，不构成当前后端实施的强约束

### 刷新 token

- `PUT /login/refresh`

原因：

- 前端未接入自动刷新逻辑
- 当前 401 行为是直接跳登录

### 首页新鲜好物

- `GET /home/new`

原因：

- 文档存在，但当前前端首页未使用
