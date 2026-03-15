# DTO / VO 清单

目标：把 `final-endpoint-contract.md` 的最终接口合同拆成可直接落后端的模型清单。

命名约定：

- `Query`：GET 查询参数
- `DTO`：POST / PUT / DELETE 请求体
- `VO`：接口返回体中的业务对象
- `Item`：VO 的内嵌子对象
- `Result`：聚合型返回对象

## 全局通用

### 通用模型

| 名称 | 类型 | 用途 |
| --- | --- | --- |
| `ApiResult<T>` | 通用包装 | 所有接口统一响应外层 |
| `PageResult<T>` | 通用包装 | 分页接口统一结果 |

### 建议枚举

| 名称 | 说明 |
| --- | --- |
| `OrderStateEnum` | 订单状态：待付款/待发货/待收货/待评价/已完成/已取消 |
| `PayTypeEnum` | 支付方式：在线支付、货到付款 |
| `PayChannelEnum` | 支付渠道：支付宝、微信 |
| `DeliveryTimeTypeEnum` | 配送时间：不限、工作日、双休或假日 |

## home

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `HomeBannerQuery` | Query | `distributionSite?: number` |
| `GuessLikeQuery` | Query | `page?: number`, `pageSize?: number` |
| `HotRecommendQuery` | Query | `page?: number`, `pageSize?: number`, `subType?: string` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `BannerVO` | VO | 首页/分类页轮播项 |
| `HomeCategoryVO` | VO | 首页一级分类 |
| `HomeHotVO` | VO | 首页热门推荐项 |
| `HotRecommendVO` | Result | 热门推荐聚合结果 |
| `HotSubTypeVO` | VO | 热门推荐子分类 |

## category

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `CategoryTopVO` | VO | 一级分类结果 |
| `CategoryChildVO` | VO | 二级分类结果 |
| `CategoryGoodsVO` | VO | 分类页商品摘要，可直接复用 `GoodsSimpleVO` |

## product

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `GoodsDetailQuery` | Query | `id: string` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `GoodsSimpleVO` | VO | 商品摘要，供猜你喜欢/分类/热门/相似商品复用 |
| `GoodsDetailVO` | VO | 商品详情主对象 |
| `GoodsDetailPropertyVO` | VO | 商品属性项 |
| `GoodsSkuVO` | VO | SKU 信息 |
| `GoodsSkuSpecVO` | VO | SKU 中的规格值 |
| `GoodsSpecVO` | VO | 规格组 |
| `GoodsSpecValueVO` | VO | 规格值 |

### 设计说明

- `GoodsSimpleVO` 建议统一字段：`id/name/desc/picture/price`
- `discount/orderNum` 可放在 `GoodsSimpleVO` 中作为可选字段
- `userAddresses` 不建议内嵌在 `GoodsDetailVO` 作为必需字段

## auth

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `WxMinLoginDTO` | DTO | `code: string`, `encryptedData?: string`, `iv?: string` |
| `WxMinSimpleLoginDTO` | DTO | `phoneNumber: string` |
| `PasswordLoginDTO` | DTO | `account: string`, `password: string` |
| `ProfileUpdateDTO` | DTO | `nickname`, `gender`, `birthday`, `profession`, `provinceCode?`, `cityCode?`, `countyCode?` |
| `AvatarUploadDTO` | DTO | multipart `file` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `LoginVO` | VO | 登录成功返回体 |
| `MemberProfileVO` | VO | 个人信息返回体 |
| `AvatarUploadVO` | VO | 头像上传返回体，仅含 `avatar` |

### 设计说明

- `LoginVO` 与 `MemberProfileVO` 不要强制共用一个模型
- `LoginVO` 保持最小登录态字段即可：`id/avatar/account/nickname/mobile/token`

## address

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `AddressCreateDTO` | DTO | `receiver`, `contact`, `provinceCode`, `cityCode`, `countyCode`, `address`, `isDefault` |
| `AddressUpdateDTO` | DTO | 同 `AddressCreateDTO` |
| `AddressDetailQuery` | Query | `id: string` |
| `AddressDeleteDTO` | DTO / Path | `id: string` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AddressVO` | VO | 地址对象 |

### 设计说明

- `AddressVO` 在地址列表、地址详情、订单预结算中应完全同构
- 当前不建议把 `postalCode` 放进强制模型

## cart

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `CartAddDTO` | DTO | `skuId: string`, `count: number` |
| `CartUpdateDTO` | DTO | `selected?: boolean`, `count?: number` |
| `CartSelectedDTO` | DTO | `selected: boolean` |
| `CartDeleteDTO` | DTO | `ids: string[]` |
| `CartSkuQuery` | Query / Path | `skuId: string` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `CartItemVO` | VO | 购物车商品项 |

### 设计说明

- `CartDeleteDTO.ids` 必须表达为 SKU ID 集合
- `CartItemVO` 不强制包含 `isCollect`、`discount`

## order

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `OrderPreNowQuery` | Query | `skuId: string`, `count: string`, `addressId?: string` |
| `OrderRepurchaseQuery` | Query / Path | `id: string` |
| `OrderDetailQuery` | Query / Path | `id: string` |
| `OrderLogisticsQuery` | Query / Path | `id: string` |
| `OrderReceiptDTO` | DTO / Path | `id: string` |
| `OrderCancelDTO` | DTO | `cancelReason: string` |
| `OrderDeleteDTO` | DTO | `ids: string[]` |
| `OrderListQuery` | Query | `page?: number`, `pageSize?: number`, `orderState: number` |
| `OrderCreateDTO` | DTO | `addressId`, `deliveryTimeType`, `buyerMessage`, `goods`, `payChannel`, `payType` |
| `OrderCreateGoodsDTO` | DTO | `skuId: string`, `count: number` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `OrderPreResultVO` | Result | 预订单结果 |
| `OrderPreGoodsVO` | VO | 预订单商品项 |
| `OrderSummaryVO` | VO | 预订单金额摘要 |
| `OrderSubmitVO` | VO | 提交订单返回，仅含 `id` |
| `OrderVO` | VO | 订单详情主对象 |
| `OrderSkuVO` | VO | 订单商品项 |
| `OrderListResultVO` | Result | 订单列表结果 |
| `OrderLogisticResultVO` | Result | 物流结果 |
| `OrderLogisticItemVO` | VO | 物流节点 |
| `OrderLogisticCompanyVO` | VO | 物流公司信息 |

### 设计说明

- `OrderVO` 与 `OrderListResultVO.items[]` 建议共用主结构，再额外扩展 `totalNum`
- 金额、数量、分页字段统一用 `number`
- `OrderPreNowQuery.count` 为兼容前端，当前先按 `string` 接收

## payment

### Query / DTO

| 名称 | 类型 | 字段 |
| --- | --- | --- |
| `PayQuery` | Query | `orderId: string` |

### VO

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `MiniPayVO` | VO | 微信支付参数 |

### 设计说明

- `GET /pay/mock` 不需要专门 VO，统一空结果即可
- `MiniPayVO` 应尽量与微信 `requestPayment` 参数结构同构

## 建议的后端包结构

### home

- `home.dto.HomeBannerQuery`
- `home.dto.GuessLikeQuery`
- `home.dto.HotRecommendQuery`
- `home.vo.BannerVO`
- `home.vo.HomeCategoryVO`
- `home.vo.HomeHotVO`
- `home.vo.HotRecommendVO`
- `home.vo.HotSubTypeVO`

### category

- `category.vo.CategoryTopVO`
- `category.vo.CategoryChildVO`

### product

- `product.dto.GoodsDetailQuery`
- `product.vo.GoodsSimpleVO`
- `product.vo.GoodsDetailVO`
- `product.vo.GoodsDetailPropertyVO`
- `product.vo.GoodsSkuVO`
- `product.vo.GoodsSkuSpecVO`
- `product.vo.GoodsSpecVO`
- `product.vo.GoodsSpecValueVO`

### auth / member

- `auth.dto.WxMinLoginDTO`
- `auth.dto.WxMinSimpleLoginDTO`
- `auth.dto.PasswordLoginDTO`
- `member.dto.ProfileUpdateDTO`
- `member.vo.LoginVO`
- `member.vo.MemberProfileVO`
- `member.vo.AvatarUploadVO`

### address

- `address.dto.AddressCreateDTO`
- `address.dto.AddressUpdateDTO`
- `address.vo.AddressVO`

### cart

- `cart.dto.CartAddDTO`
- `cart.dto.CartUpdateDTO`
- `cart.dto.CartSelectedDTO`
- `cart.dto.CartDeleteDTO`
- `cart.vo.CartItemVO`

### order

- `order.dto.OrderPreNowQuery`
- `order.dto.OrderCreateDTO`
- `order.dto.OrderCreateGoodsDTO`
- `order.dto.OrderCancelDTO`
- `order.dto.OrderDeleteDTO`
- `order.dto.OrderListQuery`
- `order.vo.OrderPreResultVO`
- `order.vo.OrderPreGoodsVO`
- `order.vo.OrderSummaryVO`
- `order.vo.OrderSubmitVO`
- `order.vo.OrderVO`
- `order.vo.OrderSkuVO`
- `order.vo.OrderListResultVO`
- `order.vo.OrderLogisticResultVO`
- `order.vo.OrderLogisticItemVO`
- `order.vo.OrderLogisticCompanyVO`

### payment

- `payment.dto.PayQuery`
- `payment.vo.MiniPayVO`

## 当前不建议立即落地的模型

这些能力在前端尚未形成闭环，先不要进入第一批后端实现：

- `search.dto.SearchQuery`
- `search.vo.SearchResultVO`
- `search.vo.SearchTipVO`
- `collection.dto.GoodsCollectionDTO`
- `collection.vo.GoodsCollectionVO`
- `review.dto.OrderReviewDTO`
- `review.vo.OrderReviewVO`
- `aftersale.dto.AfterSaleCreateDTO`
- `aftersale.vo.AfterSaleVO`
- `auth.dto.RefreshTokenDTO`
- `auth.vo.RefreshTokenVO`
