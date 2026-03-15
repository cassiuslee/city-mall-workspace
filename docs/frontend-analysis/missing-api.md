# 前端缺失 / 未闭环的后端能力

基于真实页面、组件、Store 与后台检索结果整理。这里的“缺失”包含三类：

- 前端已有入口，但没有对应 service / API
- 已有 service，但流程仍停留在 mock 或半接入状态
- 前端参数/字段已预埋，但当前后端契约未完整显式化

## 高优先级

### 1. 真实支付闭环未落地

现状：

- `src/services/pay.ts` 已定义 `GET /pay/wxPay/miniPay`
- `src/pagesOrder/detail/detail.vue` 与 `src/pagesOrder/list/components/OrderList.vue` 中真实支付代码被注释
- 当前实际调用的是 `GET /pay/mock`
- `src/pagesOrder/payment/payment.vue` 仅展示“模拟支付成功”，不校验支付结果

后端需求：

- 提供正式支付参数接口：`GET /pay/wxPay/miniPay?orderId=...`
- 返回完整的 `WechatMiniprogram.RequestPaymentOption`
- 提供支付结果确认/查询能力，至少满足以下其一：
  - 支付回调后订单详情可立即反映最新状态
  - 新增支付状态查询接口供支付结果页轮询/确认

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| GET | `/pay/wxPay/miniPay` | 获取微信支付拉起参数 |
| GET | `/pay/status` 或 `/member/order/:id/pay-status` | 支付结果确认 |

### 2. 商品收藏能力缺失

现状：

- `src/pages/goods/goods.vue` 底部有“收藏”按钮
- 没有任何 service 或点击事件调用

后端需求：

- 商品收藏/取消收藏
- 收藏状态查询（详情页首屏需要）
- 我的收藏列表（当前页面未做，但通常会成为后续用户中心能力）

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| GET | `/member/collection/goods/:id` | 查询当前商品是否已收藏 |
| POST | `/member/collection/goods` | 收藏商品 |
| DELETE | `/member/collection/goods/:id` | 取消收藏 |

### 3. 评价与售后能力缺失

现状：

- `src/pagesOrder/detail/detail.vue` 存在“申请售后”和“去评价”按钮
- “去评价”甚至有空 `navigator url=""`
- 没有任何对应 service、路由、页面或接口

后端需求：

- 订单评价资格查询与评价提交
- 订单售后申请、售后记录查询
- 订单详情中返回可评价/可售后状态时，前端能据此控制按钮展示

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| GET | `/member/order/:id/review-status` | 查询订单是否可评价 |
| POST | `/member/order/:id/reviews` | 提交评价 |
| POST | `/member/order/:id/after-sale` | 发起售后 |
| GET | `/member/order/:id/after-sale` | 查询售后进度 |

### 4. 搜索能力缺失

现状：

- `src/pages/index/components/CustomNavbar.vue`、`src/pages/category/category.vue` 有搜索 UI 占位
- 当前没有搜索 service、搜索结果页、搜索建议或历史搜索能力

后端需求：

- 商品搜索
- 热词/默认词
- 搜索建议与搜索历史（可后续）

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| GET | `/search/goods` | 按关键词/分类/排序分页搜索商品 |
| GET | `/search/hot` | 搜索热词 |
| GET | `/search/suggest` | 输入联想建议 |

## 中优先级

### 5. 商品详情地址面板未接真实数据

现状：

- `GoodsResult` 类型里定义了 `userAddresses: AddressItem[]`
- `src/pages/goods/goods.vue` 使用了 `AddressPanel`
- 但当前地址面板是静态展示，没有读取真实地址、没有选择地址、没有与 `addressStore` 联动

后端需求：

- 如果商品详情页需要“送至”能力，后端无需新增接口，可复用已存在地址接口
- 但需要保证 `GET /member/address` 或 `GET /goods?id=...` 返回的地址数据结构一致、可直接用于面板选择

前端联动建议：

- 详情页打开地址面板时调用 `GET /member/address`
- 用户确认地址后同步到 `addressStore.selectedAddress`

### 6. 分类页“全部”入口未落地

现状：

- `src/pages/category/category.vue` 中二级分类标题右侧有“全部” `navigator`
- 当前没有跳转地址，也没有二级分类商品列表页

后端需求：

- 商品列表查询接口，至少支持二级分类维度分页

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| GET | `/category/sub/:id/goods` 或 `/goods` | 查询某二级分类下的商品列表 |

### 7. 退出登录仅本地清理，无服务端登出

现状：

- `src/pagesMember/settings/settings.vue` 仅调用 `memberStore.clearProfile()`
- 如果后端后续引入 refresh token、设备管理、黑名单 token，则本地退出不够

后端需求：

- 可选提供登出接口，用于服务端使 token 失效

建议补充接口：

| 方法 | URL | 用途 |
| --- | --- | --- |
| POST | `/logout` 或 `/member/logout` | 注销当前登录态 |

### 8. 地址选择页路由参数已预埋，但没有形成页面模式切换

现状：

- `src/pagesOrder/create/create.vue` 跳转的是 `/pagesMember/address/address?from=order`
- `src/pagesMember/address/address.vue` 没有读取 `from` 参数
- 当前地址页无论从“设置”还是从“订单确认”进入，行为都完全相同

后端影响：

- 这不是新增接口诉求，但说明地址列表返回结构需要同时满足“管理页展示”和“订单页选择”两种模式
- 如果后续要做“仅可选地址”“下单来源标记”之类规则，前后端都需要补充场景参数约定

## 契约不完整 / 需要显式化的点

### 9. 头像上传响应类型未显式定义

现状：

- `src/pagesMember/profile/profile.vue` 直接 `JSON.parse(res.data).result.avatar`
- `src/services` / `src/types` 中没有对应响应类型

后端需求：

- 明确上传头像响应结构，至少稳定返回：

```json
{
  "code": "1",
  "msg": "操作成功",
  "result": {
    "avatar": "https://..."
  }
}
```

### 10. 多个写接口未声明返回值，建议统一为空体或明确结果体

现状：

- 地址、购物车、订单、支付中的多个 POST/PUT/DELETE service 没有显式泛型
- 前端目前只关心成功失败，但后端实现时最好统一约定

建议：

- 无业务数据返回时，统一 `result: null` 或 `result: {}`
- 有更新后对象返回时，保持和查询接口同构，方便前端局部刷新

涉及接口：

- `/member/address` POST / PUT / DELETE
- `/member/cart` POST / PUT / DELETE
- `/member/cart/selected` PUT
- `/member/order` DELETE
- `/pay/mock` GET
- `/member/order/consignment/:id` GET

### 11. 订单取消接口命名与 HTTP 方法语义不一致

现状：

- service 名为 `getMemberOrderCancelByIdAPI`
- 实际请求是 `PUT /member/order/:id/cancel`

后端结论：

- 路由本身没问题，应按“修改订单状态”实现
- 文档和代码生成时不要被前端函数名误导为 GET

### 12. 预订单与商品详情的地址来源存在双轨

现状：

- `GoodsResult` 包含 `userAddresses`
- `OrderPreResult` 也包含 `userAddresses`
- 当前真正被订单页消费的是 `OrderPreResult.userAddresses`

后端建议：

- 若详情页短期不做真实地址选择，可不必在商品详情接口返回地址列表
- 若保留，需保证两处地址结构完全一致

## 前端已预留但当前未消费的字段

这些字段不是“接口缺失”，但说明后端可以先保留，不必围绕它们优先优化接口体验：

- `BannerItem.hrefUrl`
- `BannerItem.type`
- `HotItem.alt`
- `HotItem.target`
- `CategoryTopItem.imageBanners`
- `GoodsItem.discount`
- `GoodsItem.orderNum`
- `GoodsResult.userAddresses`（当前详情页未真正用起来）
- `CartItem.isEffective`
- `OrderLogisticResult.company`
- `OrderLogisticResult.count`

## 建议的后端实现优先级

1. 支付正式链路：`miniPay` + 支付结果确认
2. 搜索接口
3. 收藏接口
4. 评价 / 售后接口
5. 商品列表页接口（支持分类“全部”）
6. 可选登出接口
7. 头像上传响应类型、空返回体规范等契约收口
