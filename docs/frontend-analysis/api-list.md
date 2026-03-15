# city-mall-web API 清单

基于 `city-mall-web/src/services` 与实际页面调用整理，优先以后端真实需要支撑的前端行为为准。

## 通用约定

- 统一请求封装：`city-mall-web/src/utils/http.ts`
- 基础返回结构：`{ code: string, msg: string, result: T }`
- 默认请求头：`source-client: miniapp`
- 登录态请求头：`Authorization: <token>`
- `401` 行为：清空 `memberStore.profile` 并跳转 `/pages/login/login`
- 分页通用结构：`PageResult<T>`，字段为 `items`、`counts`、`page`、`pages`、`pageSize`

## 首页 / 推荐

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| home | GET | `/home/banner` | `getHomeBannerAPI` | `distributionSite`，默认 `1`；分类页传 `2` | `BannerItem[]`：`id` `imgUrl` `hrefUrl` `type` | `pages/index/index.vue`、`pages/category/category.vue` |
| home | GET | `/home/category/mutli` | `getHomeCategoryAPI` | 无 | `CategoryItem[]`：`id` `name` `icon` | `pages/index/index.vue`（当前请求了，但面板模板被注释） |
| home | GET | `/home/hot/mutli` | `getHomeHotAPI` | 无 | `HotItem[]`：`id` `title` `alt` `pictures` `target` `type` | `pages/index/index.vue`（当前请求了，但面板模板被注释） |
| home | GET | `/home/goods/guessLike` | `getHomeGoodsGuessLikeAPI` | `page` `pageSize` | `PageResult<GuessItem>`，`GuessItem` 实际等同 `GoodsItem` | `components/XtxGuess.vue`，被首页/购物车/我的/订单详情/支付结果复用 |
| hot | GET | `/hot/preference` | `getHotRecommendAPI` | `page` `pageSize` 首屏；翻页时额外带 `subType` | `HotResult`：`bannerPicture` `title` `subTypes[].goodsItems` | `pages/hot/hot.vue` |
| hot | GET | `/hot/inVogue` | `getHotRecommendAPI` | 同上 | 同上 | `pages/hot/hot.vue` |
| hot | GET | `/hot/oneStop` | `getHotRecommendAPI` | 同上 | 同上 | `pages/hot/hot.vue` |
| hot | GET | `/hot/new` | `getHotRecommendAPI` | 同上 | 同上 | `pages/hot/hot.vue` |

## 分类 / 商品

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| category | GET | `/category/top` | `getCategoryTopAPI` | 无 | `CategoryTopItem[]`：一级分类 `id/name/picture/imageBanners`，二级分类 `children[].goods` | `pages/category/category.vue` |
| product | GET | `/goods` | `getGoodsByIdAPI` | `id` | `GoodsResult`：基础信息、`mainPictures`、`details`、`skus`、`specs`、`similarProducts`、`userAddresses` | `pages/goods/goods.vue` |

## 登录 / 会员

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| auth | POST | `/login/wxMin` | `postLoginWxMinAPI` | `code` `encryptedData?` `iv?` | `LoginResult`：`id` `avatar` `account` `nickname?` `mobile` `token` | `pages/login/login.vue` 微信手机号登录 |
| auth | POST | `/login/wxMin/simple` | `postLoginWxMinSimpleAPI` | `phoneNumber` | `LoginResult` | `pages/login/login.vue` 开发态模拟快捷登录 |
| auth | POST | `/login` | `postLoginAPI` | `account` `password` | `LoginResult` | `pages/login/login.vue` H5 账号密码登录 |
| member | GET | `/member/profile` | `getMemberProfileAPI` | 无 | `ProfileDetail`：`id` `avatar` `account` `nickname` `gender` `birthday` `fullLocation` `profession` | `pagesMember/profile/profile.vue` |
| member | PUT | `/member/profile` | `putMemberProfileAPI` | `nickname` `gender` `birthday` `profession` `provinceCode?` `cityCode?` `countyCode?` | `ProfileDetail` | `pagesMember/profile/profile.vue` |
| member | POST(upload) | `/member/profile/avatar` | 无 service，页面直传 | multipart file 字段名 `file` | 前端按 `result.avatar` 解析 | `pagesMember/profile/profile.vue` |

## 地址

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| address | POST | `/member/address` | `postMemberAddressAPI` | `AddressParams`：`receiver` `contact` `provinceCode` `cityCode` `countyCode` `address` `isDefault` | 无明确类型，前端只关心成功失败 | `pagesMember/address-form/address-form.vue` |
| address | GET | `/member/address` | `getMemberAddressAPI` | 无 | `AddressItem[]`：在 `AddressParams` 基础上增加 `id` `fullLocation` | `pagesMember/address/address.vue`、订单确认页默认地址 |
| address | GET | `/member/address/:id` | `getMemberAddressByIdAPI` | 路径 `id` | `AddressItem` | `pagesMember/address-form/address-form.vue` |
| address | PUT | `/member/address/:id` | `putMemberAddressByIdAPI` | 路径 `id` + `AddressParams` | 无明确类型 | `pagesMember/address-form/address-form.vue` |
| address | DELETE | `/member/address/:id` | `deleteMemberAddressByIdAPI` | 路径 `id` | 无明确类型 | `pagesMember/address/address.vue` |

## 购物车

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| cart | POST | `/member/cart` | `postMemberCartAPI` | `skuId` `count` | 无明确类型 | `pages/goods/goods.vue` 加购 |
| cart | GET | `/member/cart` | `getMemberCartAPI` | 无 | `CartItem[]`：`id` `skuId` `name` `picture` `count` `price` `nowPrice` `stock` `selected` `attrsText` `isEffective` | `pages/cart/components/CartMain.vue` |
| cart | DELETE | `/member/cart` | `deleteMemberCartAPI` | `ids: string[]`，实际传 SKU ID 数组 | 无明确类型 | `pages/cart/components/CartMain.vue` |
| cart | PUT | `/member/cart/:skuId` | `putMemberCartBySkuIdAPI` | `selected?` `count?` | 无明确类型 | `pages/cart/components/CartMain.vue` |
| cart | PUT | `/member/cart/selected` | `putMemberCartSelectedAPI` | `selected: boolean` | 无明确类型 | `pages/cart/components/CartMain.vue` |

## 订单 / 支付

| 领域 | 方法 | URL | Service 函数 | 请求参数 | 返回结果 | 主要使用位置 |
| --- | --- | --- | --- | --- | --- | --- |
| order | GET | `/member/order/pre` | `getMemberOrderPreAPI` | 无 | `OrderPreResult`：`goods[]` `summary` `userAddresses[]` | `pagesOrder/create/create.vue` 购物车结算 |
| order | GET | `/member/order/pre/now` | `getMemberOrderPreNowAPI` | `skuId` `count` `addressId?` | `OrderPreResult` | `pagesOrder/create/create.vue` 立即购买 |
| order | GET | `/member/order/repurchase/:id` | `getMemberOrderRepurchaseByIdAPI` | 路径 `id` | `OrderPreResult` | `pagesOrder/create/create.vue` 再次购买 |
| order | POST | `/member/order` | `postMemberOrderAPI` | `OrderCreateParams`：`addressId` `deliveryTimeType` `buyerMessage` `goods[]` `payChannel` `payType` | `{ id: string }` | `pagesOrder/create/create.vue` |
| order | GET | `/member/order/:id` | `getMemberOrderByIdAPI` | 路径 `id` | `OrderResult`：状态、倒计时、sku、收货信息、金额、创建时间 | `pagesOrder/detail/detail.vue` |
| order | GET | `/member/order/consignment/:id` | `getMemberOrderConsignmentByIdAPI` | 路径 `id` | 无明确类型 | `pagesOrder/detail/detail.vue` 开发态模拟发货 |
| order | PUT | `/member/order/:id/receipt` | `putMemberOrderReceiptByIdAPI` | 路径 `id` | `OrderResult` | `pagesOrder/detail/detail.vue`、`pagesOrder/list/components/OrderList.vue` |
| order | GET | `/member/order/:id/logistics` | `getMemberOrderLogisticsByIdAPI` | 路径 `id` | `OrderLogisticResult`：`company` `count` `list[]` | `pagesOrder/detail/detail.vue` |
| order | DELETE | `/member/order` | `deleteMemberOrderAPI` | `ids: string[]` | 无明确类型 | 订单详情、订单列表 |
| order | PUT | `/member/order/:id/cancel` | `getMemberOrderCancelByIdAPI` | 路径 `id` + `cancelReason` | `OrderResult` | `pagesOrder/detail/detail.vue` |
| order | GET | `/member/order` | `getMemberOrderAPI` | `page` `pageSize` `orderState` | `OrderListResult`：`items` `pages` `counts` 等 | `pagesOrder/list/components/OrderList.vue` |
| pay | GET | `/pay/wxPay/miniPay` | `getPayWxPayMiniPayAPI` | `orderId` | `WechatMiniprogram.RequestPaymentOption` | 已封装但实际页面中被注释，当前未真正调用微信支付 |
| pay | GET | `/pay/mock` | `getPayMockAPI` | `orderId` | 无明确类型 | 订单详情、订单列表，当前主支付路径 |

## 前端已显式暴露但未完全落地的接口信号

- 真实微信支付已预留：`/pay/wxPay/miniPay`，但页面内注释掉了 `wx.requestPayment`。
- 头像上传未走 `src/services`，而是页面直接 `uni.uploadFile` 到 `/member/profile/avatar`。
- 分类页“全部”、商品页“收藏”、订单页“申请售后/去评价”已有 UI 入口，但没有对应 service。
