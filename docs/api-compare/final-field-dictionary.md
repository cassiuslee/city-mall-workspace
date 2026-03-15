# 最终字段字典

本字典基于 `docs/frontend-analysis/*` 与 `docs/api-compare/final-endpoint-contract.md` 收敛。

规则：

- 以前端真实消费字段为必需项
- Apifox 存在但前端未消费的字段记为“扩展”
- 同名字段若出现类型冲突，以最终合同为准

## 全局通用

### ApiResult

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `code` | `string` | 是 | 统一业务码 |
| `msg` | `string` | 是 | 提示信息 |
| `result` | `T` | 是 | 业务数据 |

### PageResult<T>

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `counts` | `number` | 是 | 总记录数 |
| `page` | `number` | 是 | 当前页 |
| `pages` | `number` | 是 | 总页数 |
| `pageSize` | `number` | 是 | 每页条数 |
| `items` | `T[]` | 是 | 当前页数据 |

### 通用请求头

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `source-client` | `string` | 条件必需 | 小程序端固定为 `miniapp` |
| `Authorization` | `string` | 鉴权接口必需 | 当前前端传裸 token |

## home

### BannerItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 轮播项主键 | `/home/banner` |
| `imgUrl` | `string` | 是 | 轮播图片 | `/home/banner` |
| `hrefUrl` | `string` | 是 | 跳转链接，当前弱使用 | `/home/banner` |
| `type` | `number` | 是 | 跳转类型 | `/home/banner` |

### CategoryItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 分类主键 | `/home/category/mutli` |
| `name` | `string` | 是 | 分类名称 | `/home/category/mutli` |
| `icon` | `string` | 是 | 分类图标 | `/home/category/mutli` |

### HotItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 热门项主键 | `/home/hot/mutli` |
| `title` | `string` | 是 | 热门标题 | `/home/hot/mutli` |
| `alt` | `string` | 是 | 说明文案，当前弱使用 | `/home/hot/mutli` |
| `pictures` | `string[]` | 是 | 图片集合 | `/home/hot/mutli` |
| `target` | `string` | 是 | 跳转目标，当前弱使用 | `/home/hot/mutli` |
| `type` | `string` | 是 | 业务类型 | `/home/hot/mutli` |

### HotResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `bannerPicture` | `string` | 是 | 热门页顶部封面 | `/hot/*` |
| `title` | `string` | 是 | 页面标题 | `/hot/*` |
| `subTypes` | `SubTypeItem[]` | 是 | 子分类集合 | `/hot/*` |

### SubTypeItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 子分类 id | `/hot/*` |
| `title` | `string` | 是 | 子分类标题 | `/hot/*` |
| `goodsItems` | `PageResult<GoodsItem>` | 是 | 子分类商品分页 | `/hot/*` |

## category

### CategoryTopItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 一级分类 id | `/category/top` |
| `name` | `string` | 是 | 一级分类名 | `/category/top` |
| `picture` | `string` | 是 | 分类封面图 | `/category/top` |
| `imageBanners` | `string[]` | 是 | banner 图集合，当前弱使用 | `/category/top` |
| `children` | `CategoryChildItem[]` | 是 | 二级分类集合 | `/category/top` |

### CategoryChildItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 二级分类 id | `/category/top` |
| `name` | `string` | 是 | 二级分类名 | `/category/top` |
| `picture` | `string` | 是 | 分类图 | `/category/top` |
| `goods` | `GoodsItem[]` | 是 | 分类下商品摘要 | `/category/top` |

## product

### GoodsItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 商品 id | 猜你喜欢/分类/热门/相似商品 |
| `name` | `string` | 是 | 商品名称 | 同上 |
| `desc` | `string` | 是 | 商品描述 | 同上 |
| `picture` | `string` | 是 | 商品图片 | 同上 |
| `price` | `number` | 是 | 商品价格 | 同上 |
| `discount` | `number` | 否 | 折扣，当前弱使用 | 扩展 |
| `orderNum` | `number` | 否 | 销量，当前弱使用 | 扩展 |

### GoodsResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 商品 id | `/goods` |
| `name` | `string` | 是 | 商品名称 | `/goods` |
| `desc` | `string` | 是 | 商品描述 | `/goods` |
| `price` | `number` | 是 | 当前价格 | `/goods` |
| `oldPrice` | `number` | 是 | 原价 | `/goods` |
| `mainPictures` | `string[]` | 是 | 主图轮播 | `/goods` |
| `details` | `GoodsDetailBlock` | 是 | 详情图与属性 | `/goods` |
| `similarProducts` | `GoodsItem[]` | 是 | 同类推荐 | `/goods` |
| `skus` | `GoodsSkuItem[]` | 是 | SKU 集合 | `/goods` |
| `specs` | `GoodsSpecItem[]` | 是 | 规格集合 | `/goods` |
| `userAddresses` | `AddressItem[]` | 否 | 当前弱使用，如返回需与地址模块同构 | 扩展 |

### GoodsDetailBlock

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `properties` | `{ name: string; value: string }[]` | 是 | 商品属性 |
| `pictures` | `string[]` | 是 | 详情图 |

### GoodsSkuItem

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `id` | `string` | 是 | SKU id |
| `skuCode` | `string` | 是 | SKU 编码 |
| `price` | `number` | 是 | SKU 价格 |
| `oldPrice` | `number` | 是 | SKU 原价 |
| `inventory` | `number` | 是 | 库存 |
| `picture` | `string` | 是 | SKU 图片 |
| `specs` | `{ name: string; valueName: string }[]` | 是 | SKU 规格值 |

### GoodsSpecItem

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `name` | `string` | 是 | 规格名 |
| `values` | `GoodsSpecValue[]` | 是 | 可选规格值 |

### GoodsSpecValue

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `name` | `string` | 是 | 规格值名称 |
| `picture` | `string` | 是 | 规格图 |
| `desc` | `string` | 是 | 规格备注 |
| `available` | `boolean` | 是 | 是否可选 |

## auth

### LoginResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `number` | 是 | 用户 id | `/login*` |
| `avatar` | `string` | 是 | 头像 | `/login*` |
| `account` | `string` | 是 | 账号名 | `/login*` |
| `nickname` | `string` | 否 | 昵称 | `/login*` |
| `mobile` | `string` | 是 | 手机号，当前弱展示 | `/login*` |
| `token` | `string` | 是 | 登录 token | `/login*` |

### ProfileDetail

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 用户 id | `/member/profile` |
| `avatar` | `string` | 是 | 头像 | `/member/profile` |
| `account` | `string` | 是 | 账号 | `/member/profile` |
| `nickname` | `string` | 是 | 昵称 | `/member/profile` |
| `gender` | `string` | 是 | 性别 | `/member/profile` |
| `birthday` | `string` | 是 | 生日 | `/member/profile` |
| `fullLocation` | `string` | 是 | 省市区文案 | `/member/profile` |
| `profession` | `string` | 是 | 职业 | `/member/profile` |

### ProfileUpdateParams

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `nickname` | `string` | 是 | 昵称 | `PUT /member/profile` |
| `gender` | `string` | 是 | 性别 | `PUT /member/profile` |
| `birthday` | `string` | 是 | 生日 | `PUT /member/profile` |
| `profession` | `string` | 是 | 职业 | `PUT /member/profile` |
| `provinceCode` | `string` | 否 | 省编码 | `PUT /member/profile` |
| `cityCode` | `string` | 否 | 市编码 | `PUT /member/profile` |
| `countyCode` | `string` | 否 | 区县编码 | `PUT /member/profile` |

### AvatarUploadResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `avatar` | `string` | 是 | 上传后的头像 URL | `POST /member/profile/avatar` |

## address

### AddressItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 地址 id | 地址查询类接口 |
| `receiver` | `string` | 是 | 收货人 | 地址查询类接口 |
| `contact` | `string` | 是 | 联系电话 | 地址查询类接口 |
| `provinceCode` | `string` | 是 | 省编码 | 地址查询类接口 |
| `cityCode` | `string` | 是 | 市编码 | 地址查询类接口 |
| `countyCode` | `string` | 是 | 区县编码 | 地址查询类接口 |
| `fullLocation` | `string` | 是 | 省市区文案 | 地址查询类接口 |
| `address` | `string` | 是 | 详细地址 | 地址查询类接口 |
| `isDefault` | `number` | 是 | 是否默认，`1/0` | 地址查询类接口 |

### AddressParams

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `receiver` | `string` | 是 | 收货人 | 地址写接口 |
| `contact` | `string` | 是 | 联系电话 | 地址写接口 |
| `provinceCode` | `string` | 是 | 省编码 | 地址写接口 |
| `cityCode` | `string` | 是 | 市编码 | 地址写接口 |
| `countyCode` | `string` | 是 | 区县编码 | 地址写接口 |
| `address` | `string` | 是 | 详细地址 | 地址写接口 |
| `isDefault` | `number` | 是 | 默认标记 | 地址写接口 |

## cart

### CartItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | SPU id | `/member/cart` |
| `skuId` | `string` | 是 | SKU id，购物车操作主键 | `/member/cart` |
| `name` | `string` | 是 | 商品名 | `/member/cart` |
| `picture` | `string` | 是 | 图片 | `/member/cart` |
| `count` | `number` | 是 | 数量 | `/member/cart` |
| `price` | `number` | 是 | 加入时价格 | `/member/cart` |
| `nowPrice` | `number` | 是 | 当前价格 | `/member/cart` |
| `stock` | `number` | 是 | 库存 | `/member/cart` |
| `selected` | `boolean` | 是 | 是否选中 | `/member/cart` |
| `attrsText` | `string` | 是 | SKU 规格文案 | `/member/cart` |
| `isEffective` | `boolean` | 是 | 是否有效商品，当前弱使用 | `/member/cart` |

### CartAddParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `skuId` | `string` | 是 | SKU id |
| `count` | `number` | 是 | 加购数量 |

### CartUpdateParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `selected` | `boolean` | 否 | 修改选中状态 |
| `count` | `number` | 否 | 修改数量 |

### CartSelectedParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `selected` | `boolean` | 是 | 全选或取消全选 |

### CartDeleteParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `ids` | `string[]` | 是 | 待删 SKU ID 集合 |

## order

### OrderPreGoodsItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 商品 id | `/member/order/pre*` |
| `name` | `string` | 是 | 商品名称 | `/member/order/pre*` |
| `picture` | `string` | 是 | 商品图 | `/member/order/pre*` |
| `count` | `number` | 是 | 数量 | `/member/order/pre*` |
| `skuId` | `string` | 是 | SKU id | `/member/order/pre*` |
| `attrsText` | `string` | 是 | SKU 文案 | `/member/order/pre*` |
| `price` | `number` | 是 | 原价 | `/member/order/pre*` |
| `payPrice` | `number` | 是 | 实付单价 | `/member/order/pre*` |
| `totalPrice` | `number` | 是 | 小计原价 | `/member/order/pre*` |
| `totalPayPrice` | `number` | 是 | 小计实付 | `/member/order/pre*` |

### OrderSummary

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `totalPrice` | `number` | 是 | 商品总价 | `/member/order/pre*` |
| `postFee` | `number` | 是 | 运费 | `/member/order/pre*` |
| `totalPayPrice` | `number` | 是 | 应付总价 | `/member/order/pre*` |
| `goodsCount` | `number` | 否 | 商品件数，扩展 | 扩展 |
| `discountPrice` | `number` | 否 | 优惠金额，扩展 | 扩展 |

### OrderPreResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `goods` | `OrderPreGoodsItem[]` | 是 | 预订单商品列表 | `/member/order/pre*` |
| `summary` | `OrderSummary` | 是 | 结算摘要 | `/member/order/pre*` |
| `userAddresses` | `AddressItem[]` | 是 | 可选地址列表 | `/member/order/pre*` |

### OrderCreateParams

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `addressId` | `string` | 是 | 收货地址 id | `POST /member/order` |
| `deliveryTimeType` | `number` | 是 | 配送时间类型 | `POST /member/order` |
| `buyerMessage` | `string` | 是 | 买家留言 | `POST /member/order` |
| `goods` | `{ skuId: string; count: number }[]` | 是 | 下单商品 | `POST /member/order` |
| `payChannel` | `number` | 是 | 支付渠道，当前前端写死 `2` | `POST /member/order` |
| `payType` | `number` | 是 | 支付方式，当前前端写死 `1` | `POST /member/order` |

### OrderSkuItem

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | SKU id | 订单详情/列表 |
| `spuId` | `string` | 是 | 商品 id | 订单详情/列表 |
| `name` | `string` | 是 | 商品名 | 订单详情/列表 |
| `attrsText` | `string` | 是 | SKU 文案 | 订单详情/列表 |
| `quantity` | `number` | 是 | 数量 | 订单详情/列表 |
| `curPrice` | `number` | 是 | 当前单价 | 订单详情/列表 |
| `image` | `string` | 是 | 图片 | 订单详情/列表 |

### OrderResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `id` | `string` | 是 | 订单 id | 订单详情/确认收货/取消 |
| `orderState` | `number` | 是 | 订单状态 | 同上 |
| `countdown` | `number` | 是 | 支付倒计时 | 同上 |
| `skus` | `OrderSkuItem[]` | 是 | 订单商品 | 同上 |
| `receiverContact` | `string` | 是 | 收货人 | 同上 |
| `receiverMobile` | `string` | 是 | 收货手机号 | 同上 |
| `receiverAddress` | `string` | 是 | 收货地址 | 同上 |
| `createTime` | `string` | 是 | 创建时间 | 同上 |
| `totalMoney` | `number` | 是 | 总金额 | 同上 |
| `postFee` | `number` | 是 | 运费 | 同上 |
| `payMoney` | `number` | 是 | 实付金额 | 同上 |
| `payType` | `number` | 否 | 支付方式，扩展 | 扩展 |
| `payChannel` | `number` | 否 | 支付渠道，扩展 | 扩展 |
| `totalNum` | `number` | 否 | 商品总数，列表扩展 | 扩展 |
| `deliveryTimeType` | `number` | 否 | 配送时间类型，扩展 | 扩展 |

### OrderListResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `counts` | `number` | 是 | 总条数 | `GET /member/order` |
| `page` | `number` | 是 | 当前页 | `GET /member/order` |
| `pages` | `number` | 是 | 总页数 | `GET /member/order` |
| `pageSize` | `number` | 是 | 每页数量 | `GET /member/order` |
| `items` | `(OrderResult & { totalNum: number })[]` | 是 | 订单列表 | `GET /member/order` |

### OrderLogisticCompany

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `name` | `string` | 是 | 物流公司名 |
| `number` | `string` | 是 | 运单号 |
| `tel` | `string` | 是 | 联系电话 |

### OrderLogisticItem

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `id` | `string` | 是 | 节点 id |
| `text` | `string` | 是 | 物流文案 |
| `time` | `string` | 是 | 物流时间 |

### OrderLogisticResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `company` | `OrderLogisticCompany` | 否 | 物流公司信息，扩展 | `/member/order/:id/logistics` |
| `count` | `number` | 否 | 节点数量，扩展 | `/member/order/:id/logistics` |
| `list` | `OrderLogisticItem[]` | 是 | 物流轨迹列表 | `/member/order/:id/logistics` |

### OrderCancelParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `cancelReason` | `string` | 是 | 取消原因 |

### OrderDeleteParams

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `ids` | `string[]` | 是 | 待删订单 id 集合 |

### OrderListQuery

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `page` | `number` | 否 | 页码 |
| `pageSize` | `number` | 否 | 每页数量 |
| `orderState` | `number` | 是 | 状态筛选 |

## payment

### MiniPayResult

| 字段 | 类型 | 必需 | 说明 | 来源 |
| --- | --- | --- | --- | --- |
| `timeStamp` | `string` | 是 | 微信时间戳 | `/pay/wxPay/miniPay` |
| `signType` | `string` | 是 | 签名算法 | `/pay/wxPay/miniPay` |
| `package` | `string` | 是 | 预支付包 | `/pay/wxPay/miniPay` |
| `paySign` | `string` | 是 | 支付签名 | `/pay/wxPay/miniPay` |
| `nonceStr` | `string` | 是 | 随机串 | `/pay/wxPay/miniPay` |
| `appId` | `string` | 否 | appId，当前可选 | `/pay/wxPay/miniPay` |

### PayQuery

| 字段 | 类型 | 必需 | 说明 |
| --- | --- | --- | --- |
| `orderId` | `string` | 是 | 支付订单 id |

## 当前不纳入强制字段字典的能力

这些字段和模型来自文档或产品意图，但不属于当前前端闭环的强制合同：

- 搜索：`SearchQuery`、`SearchResult`、`SearchTipItem`
- 收藏：`GoodsCollectionItem`
- 评价：`OrderReviewDTO`、`OrderReviewVO`
- 售后：`AfterSaleCreateDTO`、`AfterSaleVO`
- 登出：`LogoutResult`
