# 字段使用分析

按领域整理“前端真正消费/提交/持久化了哪些字段”，用于反推后端 DTO/VO 设计。

## 通用结构

### 分页

| 字段 | 来源类型 | 使用位置 | 用途 |
| --- | --- | --- | --- |
| `items` | `PageResult<T>` | 猜你喜欢、热门推荐、订单列表 | 列表渲染 |
| `page` | `PageResult<T>` | 猜你喜欢、热门推荐、订单列表 | 翻页控制 |
| `pages` | `PageResult<T>` | 猜你喜欢、热门推荐、订单列表 | 判断是否还有下一页 |
| `pageSize` | `PageResult<T>` / `PageParams` | 热门推荐、订单列表 | 翻页续传 |
| `counts` | `PageResult<T>` / `OrderListResult` | 当前前端基本不展示 | 总量信息，后端建议保留 |

## 登录与会员

### 登录返回体 `LoginResult`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `token` | `src/utils/http.ts` | 组装 `Authorization` 请求头 |
| `avatar` | `pages/my/my.vue`、`pagesMember/profile/profile.vue`、`stores/modules/member.ts` | 个人页头像展示、持久化 |
| `nickname` | `pages/my/my.vue`、`pagesMember/profile/profile.vue` | 昵称展示与编辑 |
| `account` | `pages/my/my.vue`、`pagesMember/profile/profile.vue` | 昵称缺省兜底、账号展示 |
| `mobile` | 当前页面不直接展示 | 登录资料保留字段 |
| `id` | 当前页面不直接展示 | 标识字段，后端必须返回 |

### 个人信息 `ProfileDetail` / `ProfileParams`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `avatar` | 个人信息页、我的页面 | 展示头像；上传头像成功后局部更新 |
| `account` | 个人信息页 | 只读展示 |
| `nickname` | 个人信息页、我的页面 | 输入、展示、保存后同步 Store |
| `gender` | 个人信息页 | 单选修改 |
| `birthday` | 个人信息页 | 日期选择 |
| `fullLocation` | 个人信息页 | 地区文案展示 |
| `profession` | 个人信息页 | 文本输入 |
| `provinceCode` `cityCode` `countyCode` | 保存个人资料时提交 | 仅请求参数使用，前端不展示编码 |

### 头像上传返回

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `result.avatar` | `pagesMember/profile/profile.vue` | 上传成功后更新页面与 Store |

## 首页 / 热门 / 分类 / 商品

### Banner / Category / Hot

| 字段 | 来源类型 | 使用位置 | 用途 |
| --- | --- | --- | --- |
| `imgUrl` | `BannerItem` | 轮播组件 | 图片展示 |
| `hrefUrl` | `BannerItem` | 当前前端未显式消费 | 后续跳转预留 |
| `type` | `BannerItem` / `HotItem` | 热门页入口映射、轮播预留 | 跳转类型/活动类型 |
| `icon` | `CategoryItem` | 分类面板（当前模板被注释） | 图标展示 |
| `name` | `CategoryItem` / `CategoryTopItem` / `CategoryChildItem` | 首页分类、分类页左侧/右侧标题 | 文案展示 |
| `picture` | `CategoryTopItem` / `CategoryChildItem` / `GoodsItem` | 分类商品、商品卡片 | 图片展示 |
| `title` | `HotItem` / `HotResult` / `SubTypeItem` | 热门模块、热门页 tab | 标题展示 |
| `bannerPicture` | `HotResult` | 热门页顶部封面 | 图片展示 |
| `goodsItems.items` | `SubTypeItem` | 热门页列表 | 商品列表渲染 |

### 商品与猜你喜欢 `GoodsItem` / `GoodsResult`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `id` | 商品跳转、猜你喜欢、分类/热门/相似商品列表 | 路由参数、详情查询 |
| `name` | 商品详情、分类、热门、猜你喜欢、订单预览 | 标题展示 |
| `desc` | 商品详情、猜你喜欢类型 | 商品文案 |
| `price` | 商品详情、分类、热门、猜你喜欢、相似商品 | 价格展示 |
| `discount` `orderNum` | 当前前端几乎未使用 | 可保留为扩展字段 |
| `oldPrice` | 商品详情 | 原价展示 |
| `mainPictures` | 商品详情 | 轮播与预览 |
| `details.properties[].name/value` | 商品详情 | 属性列表展示 |
| `details.pictures` | 商品详情 | 详情图展示 |
| `similarProducts[].id/name/picture/price` | 商品详情 | 同类推荐 |
| `skus[].id` | 商品详情 | 加购/立即购买时提交 `skuId` |
| `skus[].picture/price/inventory/specs[].valueName` | 商品详情 | 组装第三方 SKU 弹层数据 |
| `specs[].name/values[]` | 商品详情 | 组装规格选择 UI |
| `userAddresses` | `GoodsResult` | 当前详情页未实际展示 | 字段已返回，但主要被订单预结算替代 |

## 地址

### 地址请求 / 返回

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `receiver` | 地址列表、订单确认页、地址表单 | 收货人展示与提交 |
| `contact` | 地址列表、订单确认页、地址表单 | 手机号展示与提交 |
| `fullLocation` | 地址列表、订单确认页、地址表单、个人信息页 | 地区文案展示 |
| `provinceCode` `cityCode` `countyCode` | 地址表单提交 | 后端存储编码 |
| `address` | 地址列表、订单确认页、地址表单 | 详细地址展示与提交 |
| `isDefault` | 地址列表、订单确认页、地址表单 | 默认地址标识与选中 |
| `id` | 地址修改、删除、选择、提交订单 | 主键引用 |

## 购物车

### 购物车项 `CartItem`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `id` | 购物车商品点击跳商品详情 | 商品 SPU 标识 |
| `skuId` | 修改数量、删除、选中切换 | 购物车操作主键 |
| `name` | 购物车列表 | 商品名展示 |
| `picture` | 购物车列表 | 图片展示 |
| `count` | 购物车列表、结算数量计算 | 数量展示与提交 |
| `price` | 当前列表不直接展示 | 加购价格保留 |
| `nowPrice` | 购物车列表、合计金额 | 当前成交价 |
| `stock` | 数量组件上限 | 购买数量限制 |
| `selected` | 单选、全选、结算前过滤 | 选中态 |
| `attrsText` | 购物车列表 | SKU 规格文案 |
| `isEffective` | 当前前端几乎未使用 | 无效商品能力预留 |

## 订单

### 预订单 `OrderPreResult`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `goods[].id` | 订单确认页商品跳转 | 商品详情链接 |
| `goods[].skuId` | 提交订单 | 构造 `goods[]` 请求体 |
| `goods[].name` | 订单确认页 | 商品标题 |
| `goods[].picture` | 订单确认页 | 商品图 |
| `goods[].attrsText` | 订单确认页 | SKU 文案 |
| `goods[].count` | 订单确认页、提交订单 | 数量展示与下单 |
| `goods[].payPrice` | 订单确认页 | 实付单价 |
| `goods[].price` | 订单确认页 | 原价 |
| `summary.totalPrice` | 订单确认页 | 商品总价 |
| `summary.postFee` | 订单确认页 | 运费 |
| `summary.totalPayPrice` | 订单确认页 | 应付金额 |
| `userAddresses[]` | 订单确认页 | 默认地址兜底 |

### 提交订单 `OrderCreateParams`

| 字段 | 来源 | 用途 |
| --- | --- | --- |
| `addressId` | 当前选中地址 | 下单必填 |
| `deliveryTimeType` | 配送时间 picker | 下单必填 |
| `buyerMessage` | 备注输入框 | 下单可选备注 |
| `goods[].skuId` `goods[].count` | 预订单商品列表 | 下单商品明细 |
| `payChannel` | 前端写死 `2` | 当前约定微信 |
| `payType` | 前端写死 `1` | 当前约定在线支付 |

### 订单详情 / 列表 `OrderResult` / `OrderItem`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `id` | 详情页复制、列表跳转、支付/取消/删除/收货 | 订单主键 |
| `orderState` | 详情页、列表页 | 决定按钮和状态文案 |
| `countdown` | 详情页待付款状态 | 倒计时组件 |
| `skus[].spuId` | 详情页商品跳详情 | 商品链接 |
| `skus[].id` | 列表渲染 key | SKU 标识 |
| `skus[].name` `skus[].image` `skus[].attrsText` `skus[].quantity` `skus[].curPrice` | 详情页、列表页 | 商品信息展示 |
| `receiverContact` `receiverMobile` `receiverAddress` | 详情页 | 收货信息展示 |
| `createTime` | 详情页、列表页 | 下单时间展示 |
| `totalMoney` `postFee` `payMoney` | 详情页、列表页 | 金额展示 |
| `totalNum` | `OrderItem` | 列表页“共 N 件商品” |

### 物流 `OrderLogisticResult`

| 字段 | 使用位置 | 用途 |
| --- | --- | --- |
| `list[].id` | 详情页 | 日志列表 key |
| `list[].text` | 详情页 | 物流文案 |
| `list[].time` | 详情页 | 物流时间 |
| `company` `count` | 当前页面几乎未展示 | 后续物流头部信息可复用 |

## Store 持久化 / 缓存字段

| Store | 字段 | 来源 | 说明 |
| --- | --- | --- | --- |
| `memberStore` | `profile` | `LoginResult` | 持久化到 uni storage；后续所有鉴权请求依赖 `token` |
| `addressStore` | `selectedAddress` | `AddressItem` | 仅内存缓存；从地址页返回订单确认页时使用 |

## 实际使用弱、但类型仍定义的字段

这些字段在当前前端中基本不展示或只作为保留字段存在，后端可保留但不必优先优化页面体验。

- `GoodsItem.discount`
- `GoodsItem.orderNum`
- `BannerItem.hrefUrl`
- `HotItem.alt`
- `HotItem.target`
- `CategoryTopItem.imageBanners`
- `GoodsResult.userAddresses`
- `OrderLogisticResult.company`
- `OrderLogisticResult.count`
- `CartItem.isEffective`
- `LoginResult.mobile`
