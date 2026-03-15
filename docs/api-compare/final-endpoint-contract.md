# 最终接口合同（以前端实际使用为准）

本文件是 `city-mall-web` 当前阶段的后端落地合同。

约束原则：

1. 优先满足前端真实调用与字段消费
2. 当 Apifox 与前端不一致时，以前端现状为准
3. 文档存在但前端未使用的接口，不纳入当前必做合同

## 全局约定

### 请求

- Base URL：由环境配置决定，不写死到合同中
- 小程序端请求头必须支持：`source-client: miniapp`
- 鉴权接口必须支持：`Authorization: <token>`
- 当前前端没有使用 `Bearer ` 前缀，不应强制要求

### 统一响应包装

所有接口统一返回：

```json
{
  "code": "1",
  "msg": "操作成功",
  "result": {}
}
```

字段说明：

- `code: string`：业务码，前端类型中已假定存在
- `msg: string`：提示信息
- `result: any`：业务数据

### 分页结构

通用分页结果：

```json
{
  "counts": 0,
  "page": 1,
  "pages": 1,
  "pageSize": 10,
  "items": []
}
```

分页相关字段在最终合同中统一为 `number`，不使用字符串。

## home

### GET `/home/banner`

- 用途：首页、分类页轮播图
- Query：
  - `distributionSite?: number`，默认 `1`
    - `1` 首页
    - `2` 分类页
- Result：`BannerItem[]`

```ts
type BannerItem = {
  id: string
  imgUrl: string
  hrefUrl: string
  type: number
}
```

### GET `/home/category/mutli`

- 用途：首页前台分类
- Result：`CategoryItem[]`

```ts
type CategoryItem = {
  id: string
  name: string
  icon: string
}
```

### GET `/home/hot/mutli`

- 用途：首页热门推荐
- Result：`HotItem[]`

```ts
type HotItem = {
  id: string
  title: string
  alt: string
  pictures: string[]
  target: string
  type: string
}
```

### GET `/home/goods/guessLike`

- 用途：猜你喜欢，多个页面复用
- Query：
  - `page?: number`
  - `pageSize?: number`
- Result：`PageResult<GoodsItem>`

```ts
type GoodsItem = {
  id: string
  name: string
  desc: string
  picture: string
  price: number
  discount?: number
  orderNum?: number
}
```

### 当前不纳入 home 合同

- `GET /home/new`
  - Apifox 有定义
  - 当前前端未使用

## category

### GET `/category/top`

- 用途：分类页左侧一级分类 + 右侧二级分类商品
- Result：`CategoryTopItem[]`

```ts
type CategoryTopItem = {
  id: string
  name: string
  picture: string
  imageBanners: string[]
  children: CategoryChildItem[]
}

type CategoryChildItem = {
  id: string
  name: string
  picture: string
  goods: GoodsItem[]
}
```

### 当前不纳入 category 合同

- 分类“全部”商品列表接口
  - 前端 UI 有入口意图，但还没有实际 service

## product

### GET `/goods`

- 用途：商品详情
- Query：
  - `id: string`
- Result：`GoodsResult`

```ts
type GoodsResult = {
  id: string
  name: string
  desc: string
  price: number
  oldPrice: number
  mainPictures: string[]
  details: {
    properties: { name: string; value: string }[]
    pictures: string[]
  }
  similarProducts: GoodsItem[]
  skus: {
    id: string
    inventory: number
    oldPrice: number
    picture: string
    price: number
    skuCode: string
    specs: { name: string; valueName: string }[]
  }[]
  specs: {
    name: string
    values: {
      available: boolean
      desc: string
      name: string
      picture: string
    }[]
  }[]
  userAddresses?: AddressItem[]
}
```

说明：

- `price`、`oldPrice`、SKU 价格字段统一按 `number` 返回
- `userAddresses` 当前页面未真正消费，建议作为可选字段；如果返回，结构必须与地址模块一致

### 当前不纳入 product 合同

- `/goods/relevant`
  - Apifox 已标注废弃
  - 前端使用 `similarProducts` 替代
- 收藏接口
  - 前端只有按钮，没有实际调用链

## auth

### POST `/login/wxMin`

- 用途：小程序授权登录
- Body：

```ts
type LoginWxMinParams = {
  code: string
  encryptedData?: string
  iv?: string
}
```

- Result：`LoginResult`

### POST `/login/wxMin/simple`

- 用途：开发态模拟快捷登录
- Body：

```ts
{ phoneNumber: string }
```

- Result：`LoginResult`

### POST `/login`

- 用途：H5 账号密码登录
- Body：

```ts
{ account: string; password: string }
```

- Result：`LoginResult`

### 登录返回结构

```ts
type LoginResult = {
  id: number
  avatar: string
  account: string
  nickname?: string
  mobile: string
  token: string
}
```

说明：

- 当前前端登录态只强依赖上述字段
- 不要求登录接口返回完整 profile 字段

### 当前不纳入 auth 合同

- `PUT /login/refresh`
  - 文档存在
  - 前端没有接入刷新 token 逻辑

## address

### AddressItem 统一结构

```ts
type AddressItem = {
  id: string
  receiver: string
  contact: string
  provinceCode: string
  cityCode: string
  countyCode: string
  fullLocation: string
  address: string
  isDefault: number
}
```

### POST `/member/address`

- 用途：新增地址
- Body：

```ts
type AddressParams = {
  receiver: string
  contact: string
  provinceCode: string
  cityCode: string
  countyCode: string
  address: string
  isDefault: number
}
```

- Result：`null` 或 `{}`

### GET `/member/address`

- 用途：地址列表
- Result：`AddressItem[]`

### GET `/member/address/:id`

- 用途：地址详情
- Result：`AddressItem`

### PUT `/member/address/:id`

- 用途：修改地址
- Body：`AddressParams`
- Result：`null` 或 `{}`

### DELETE `/member/address/:id`

- 用途：删除地址
- Result：`null` 或 `{}`

说明：

- 最终合同不要求 `postalCode`
- `isDefault` 明确保留 `1/0` 整数语义

## cart

### CartItem 统一结构

```ts
type CartItem = {
  id: string
  skuId: string
  name: string
  picture: string
  count: number
  price: number
  nowPrice: number
  stock: number
  selected: boolean
  attrsText: string
  isEffective: boolean
}
```

### POST `/member/cart`

- 用途：加入购物车
- Body：

```ts
{ skuId: string; count: number }
```

- Result：`null` 或 `{}`

### GET `/member/cart`

- 用途：获取购物车列表
- Result：`CartItem[]`

### DELETE `/member/cart`

- 用途：删除购物车项
- Body：

```ts
{ ids: string[] }
```

说明：

- `ids` 必须按 SKU ID 处理

- Result：`null` 或 `{}`

### PUT `/member/cart/:skuId`

- 用途：改单项数量或勾选状态
- Body：

```ts
{ selected?: boolean; count?: number }
```

- Result：`null` 或 `{}`

### PUT `/member/cart/selected`

- 用途：全选/取消全选
- Body：

```ts
{ selected: boolean }
```

- Result：`null` 或 `{}`

说明：

- `isCollect`、`discount` 不纳入当前购物车必需字段

## order

### 预订单结果结构

```ts
type OrderPreResult = {
  goods: {
    id: string
    name: string
    picture: string
    count: number
    skuId: string
    attrsText: string
    price: number
    payPrice: number
    totalPrice: number
    totalPayPrice: number
  }[]
  summary: {
    totalPrice: number
    postFee: number
    totalPayPrice: number
  }
  userAddresses: AddressItem[]
}
```

说明：

- 金额字段统一使用 `number`
- `summary.goodsCount`、`summary.discountPrice` 可作为附加字段，不是当前前端强依赖项

### GET `/member/order/pre`

- 用途：购物车结算预订单
- Result：`OrderPreResult`

### GET `/member/order/pre/now`

- 用途：立即购买预订单
- Query：

```ts
{ skuId: string; count: string; addressId?: string }
```

- Result：`OrderPreResult`

说明：

- 为兼容当前前端，`count` 查询参数按字符串接收

### GET `/member/order/repurchase/:id`

- 用途：再次购买预订单
- Result：`OrderPreResult`

### POST `/member/order`

- 用途：提交订单
- Body：

```ts
type OrderCreateParams = {
  addressId: string
  deliveryTimeType: number
  buyerMessage: string
  goods: { skuId: string; count: number }[]
  payChannel: 1 | 2
  payType: 1 | 2
}
```

- Result：

```ts
{ id: string }
```

### 订单详情结构

```ts
type OrderResult = {
  id: string
  orderState: 1 | 2 | 3 | 4 | 5 | 6
  countdown: number
  skus: {
    id: string
    spuId: string
    name: string
    attrsText: string
    quantity: number
    curPrice: number
    image: string
  }[]
  receiverContact: string
  receiverMobile: string
  receiverAddress: string
  createTime: string
  totalMoney: number
  postFee: number
  payMoney: number
}
```

### GET `/member/order/:id`

- 用途：订单详情
- Result：`OrderResult`

说明：

- 文档中的 `payType`、`payChannel`、`totalNum`、`deliveryTimeType`、多个时间字段可保留为扩展字段
- 当前前端主流程不强依赖它们

### GET `/member/order/:id/logistics`

- 用途：订单物流
- Result：

```ts
type OrderLogisticResult = {
  company?: {
    name: string
    number: string
    tel: string
  }
  count?: number
  list: {
    id: string
    text: string
    time: string
  }[]
}
```

说明：

- 当前前端强依赖的是 `list[]`
- `company`、`count` 作为可选扩展字段保留

### PUT `/member/order/:id/cancel`

- 用途：取消订单
- Body：

```ts
{ cancelReason: string }
```

- Result：`OrderResult`

### PUT `/member/order/:id/receipt`

- 用途：确认收货
- Result：`OrderResult`

### DELETE `/member/order`

- 用途：删除订单
- Body：

```ts
{ ids: string[] }
```

- Result：`null` 或 `{}`

### GET `/member/order`

- 用途：订单列表
- Query：

```ts
{ page?: number; pageSize?: number; orderState: number }
```

- Result：

```ts
type OrderListResult = {
  counts: number
  page: number
  pages: number
  pageSize: number
  items: (OrderResult & { totalNum: number })[]
}
```

说明：

- `page`、`pages`、`pageSize`、`totalNum` 在最终合同中统一使用 `number`

### GET `/member/order/consignment/:id`

- 用途：开发态模拟发货
- Result：`null` 或 `{}`

说明：

- 属于开发辅助接口，不属于生产主流程，但当前前端会调用

## payment

### GET `/pay/wxPay/miniPay`

- 用途：获取微信支付参数
- Query：

```ts
{ orderId: string }
```

- Result：

```ts
type MiniPayResult = {
  timeStamp: string
  signType: string
  package: string
  paySign: string
  nonceStr: string
  appId?: string
}
```

说明：

- 该接口当前已被前端封装，但主流程里默认未启用
- 后端仍应按正式合同提供

### GET `/pay/mock`

- 用途：模拟支付
- Query：

```ts
{ orderId: string }
```

- Result：`null` 或 `{}`

说明：

- 这是当前前端支付主路径，必须保留

## 当前不纳入最终合同的文档接口

### 搜索模块

- `POST /search/all`
- `GET /search/tips`

原因：前端暂无实际 service 和页面闭环。

### 收藏 / 评价 / 售后

- 前端存在 UI 意图，但没有实际接口调用链
- 当前阶段归类为缺失能力，不纳入已确认合同

### 登出

- 前端目前只有本地清理登录态
- 服务端登出可后续补充，不属于当前强制合同
