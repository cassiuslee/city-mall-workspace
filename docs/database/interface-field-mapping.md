# 数据库字段到接口返回映射

本文件用于把 `docs/database/table-design.md` 与 `docs/api-compare/final-endpoint-contract.md` 对齐，说明后端返回字段分别来自哪张表、哪一列，以及是否需要 join、快照、JSON 展开或运行时计算。

## 映射规则

- `直出字段`：接口字段可直接从单表列读取
- `关联字段`：需要 join 其他表读取
- `快照字段`：来自订单/购物车等业务快照列，不应实时回查商品主数据
- `拼装字段`：由多个字段拼接
- `展开字段`：由 JSON 列或子表聚合生成
- `计算字段`：运行时计算，不直接落单列

## 全局通用

### ApiResult

| 接口字段 | 来源 | 类型 | 说明 |
| --- | --- | --- | --- |
| `code` | 业务层统一赋值 | 直出字段 | 非数据库字段 |
| `msg` | 业务层统一赋值 | 直出字段 | 非数据库字段 |
| `result` | 各业务表查询结果 | 聚合字段 | 由下列模块决定 |

### PageResult<T>

| 接口字段 | 来源 | 类型 | 说明 |
| --- | --- | --- | --- |
| `counts` | `COUNT(*)` | 计算字段 | 总记录数 |
| `page` | 请求参数 | 直出字段 | 当前页码 |
| `pages` | `ceil(counts / pageSize)` | 计算字段 | 总页数 |
| `pageSize` | 请求参数 | 直出字段 | 分页大小 |
| `items` | 业务查询结果集 | 聚合字段 | 当前页数据 |

## home

### GET `/home/banner`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `cms_banner.id` | 直出字段 | 主键 |
| `imgUrl` | `cms_banner.img_url` | 直出字段 | 轮播图地址 |
| `hrefUrl` | `cms_banner.href_url` | 直出字段 | 跳转链接 |
| `type` | `cms_banner.type` | 直出字段 | 跳转类型 |

过滤条件：

- `distributionSite` -> `cms_banner.distribution_site`
- 仅查询 `is_show = 1 and deleted = 0`

### GET `/home/category/mutli`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `category.id` | 直出字段 | 一级分类 id |
| `name` | `category.name` | 直出字段 | 分类名 |
| `icon` | `category.icon` | 直出字段 | 首页图标 |

过滤条件：

- `category.level = 1`
- `category.is_show = 1 and deleted = 0`

### GET `/home/hot/mutli`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `cms_hot_zone.id` | 直出字段 | 热门专区 id |
| `title` | `cms_hot_zone.title` | 直出字段 | 标题 |
| `alt` | `cms_hot_zone.alt` | 直出字段 | 副标题 |
| `pictures` | `cms_hot_zone.pictures` | 展开字段 | JSON 数组直接返回 |
| `target` | `cms_hot_zone.target` | 直出字段 | 跳转目标 |
| `type` | `cms_hot_zone.type` | 直出字段 | 业务类型 |

### GET `/home/goods/guessLike`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `product.id` | 直出字段 | 商品 id |
| `name` | `product.name` | 直出字段 | 商品名 |
| `desc` | `product.desc` | 直出字段 | 商品描述 |
| `picture` | `product.default_picture` | 直出字段 | 商品封面 |
| `price` | `product.price` | 直出字段 | 商品价格 |
| `discount` | 无首版强制列 | 扩展字段 | 当前可不返回或固定空 |
| `orderNum` | `product.sales_count` | 直出字段 | 对应销量扩展字段 |

过滤条件：

- `product.status = 1 and deleted = 0`

### GET `/hot/*`

#### HotResult

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `bannerPicture` | `cms_hot_zone.banner_picture` | 直出字段 | 热门页封面 |
| `title` | `cms_hot_zone.title` | 直出字段 | 页面标题 |
| `subTypes` | `cms_hot_zone_item` 分组结果 | 聚合字段 | 按 `sub_type/sub_title` 聚合 |

#### SubTypeItem

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `cms_hot_zone_item.sub_type` | 直出字段 | 子分组编码 |
| `title` | `cms_hot_zone_item.sub_title` | 直出字段 | 子分组标题 |
| `goodsItems` | `product + cms_hot_zone_item` | 聚合字段 | 该子分组下的分页商品结果 |

## category

### GET `/category/top`

#### CategoryTopItem

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `category.id` | 直出字段 | 一级分类 id |
| `name` | `category.name` | 直出字段 | 一级分类名 |
| `picture` | `category.picture` | 直出字段 | 一级分类图 |
| `imageBanners` | 无首版独立列 | 扩展字段 | 首版可返回空数组 |
| `children` | 二级分类查询结果 | 聚合字段 | 查询 `parent_id = 一级分类id` |

#### CategoryChildItem

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `category.id` | 直出字段 | 二级分类 id |
| `name` | `category.name` | 直出字段 | 二级分类名 |
| `picture` | `category.picture` | 直出字段 | 二级分类图 |
| `goods` | `product` 查询结果 | 聚合字段 | 查询 `product.secondary_category_id = 二级分类id` |

## product

### GET `/goods`

#### GoodsResult

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `product.id` | 直出字段 | 商品 id |
| `name` | `product.name` | 直出字段 | 商品名称 |
| `desc` | `product.desc` | 直出字段 | 商品描述 |
| `price` | `product.price` | 直出字段 | 默认展示价 |
| `oldPrice` | `product.old_price` | 直出字段 | 原价 |
| `mainPictures` | `product_main_picture.picture` | 聚合字段 | 按 `sort_order` 聚合数组 |
| `details.properties` | `product_detail_property` | 聚合字段 | 映射 `{name, value}` 数组 |
| `details.pictures` | `product_detail_picture.picture` | 聚合字段 | 按 `sort_order` 聚合数组 |
| `similarProducts` | `product` | 关联字段 | 按同二级分类实时查询，排除当前商品 |
| `skus` | `product_sku + product_sku_value` | 聚合字段 | 每个 SKU 聚合 specs |
| `specs` | `product_spec + product_spec_value` | 聚合字段 | 每个规格组聚合 values |
| `userAddresses` | `member_address` | 关联字段/可选 | 仅登录且需要返回时查询 |

#### GoodsResult.skus[]

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `product_sku.id` | 直出字段 | SKU id |
| `inventory` | `product_sku.inventory` | 直出字段 | 库存 |
| `oldPrice` | `product_sku.old_price` | 直出字段 | SKU 原价 |
| `picture` | `product_sku.picture` | 直出字段 | SKU 图 |
| `price` | `product_sku.price` | 直出字段 | SKU 售价 |
| `skuCode` | `product_sku.sku_code` | 直出字段 | SKU 编码 |
| `specs` | `product_sku_value` | 聚合字段 | 映射 `{name, valueName}` |

#### GoodsResult.specs[]

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `name` | `product_spec.name` | 直出字段 | 规格名 |
| `values[].name` | `product_spec_value.name` | 直出字段 | 规格值名 |
| `values[].picture` | `product_spec_value.picture` | 直出字段 | 规格图 |
| `values[].desc` | `product_spec_value.descr` | 直出字段 | 规格备注 |
| `values[].available` | `product_sku.inventory > 0` | 计算字段 | 根据 SKU 库存计算 |

## auth

### POST `/login*`

#### LoginResult

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `member_user.id` | 直出字段 | 用户 id |
| `avatar` | `member_user.avatar` | 直出字段 | 头像 |
| `account` | `member_user.account` | 直出字段 | 账号 |
| `nickname` | `member_user.nickname` | 直出字段 | 昵称 |
| `mobile` | `member_user.mobile` | 直出字段 | 手机号 |
| `token` | 登录态服务生成 | 计算字段 | 非数据库字段 |

### GET `/member/profile`

#### ProfileDetail

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `member_user.id` | 直出字段 | 用户 id |
| `avatar` | `member_user.avatar` | 直出字段 | 头像 |
| `account` | `member_user.account` | 直出字段 | 账号 |
| `nickname` | `member_user.nickname` | 直出字段 | 昵称 |
| `gender` | `member_user.gender` | 直出字段 | 性别 |
| `birthday` | `member_user.birthday` | 直出字段 | 生日 |
| `fullLocation` | `member_user.full_location` | 直出字段 | 省市区文案 |
| `profession` | `member_user.profession` | 直出字段 | 职业 |

### POST `/member/profile/avatar`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `avatar` | `member_user.avatar` | 直出字段 | 上传成功后更新并返回 |

## address

### GET `/member/address` / `/member/address/:id`

#### AddressItem

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `member_address.id` | 直出字段 | 地址 id |
| `receiver` | `member_address.receiver` | 直出字段 | 收货人 |
| `contact` | `member_address.contact` | 直出字段 | 联系方式 |
| `provinceCode` | `member_address.province_code` | 直出字段 | 省编码 |
| `cityCode` | `member_address.city_code` | 直出字段 | 市编码 |
| `countyCode` | `member_address.county_code` | 直出字段 | 区县编码 |
| `fullLocation` | `member_address.full_location` | 直出字段 | 省市区文案 |
| `address` | `member_address.address` | 直出字段 | 详细地址 |
| `isDefault` | `member_address.is_default` | 直出字段 | 默认标记 |

## cart

### GET `/member/cart`

#### CartItem

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `cart_item.product_id` | 直出字段 | 前端把它当商品 id 使用 |
| `skuId` | `cart_item.sku_id` | 直出字段 | 购物车操作主键 |
| `name` | `cart_item.name` | 快照字段 | 商品名快照 |
| `picture` | `cart_item.picture` | 快照字段 | 图片快照 |
| `count` | `cart_item.count` | 直出字段 | 数量 |
| `price` | `cart_item.price` | 快照字段 | 加入时价格 |
| `nowPrice` | `cart_item.now_price` | 直出字段 | 当前价格冗余 |
| `stock` | `cart_item.stock` | 直出字段 | 当前库存冗余 |
| `selected` | `cart_item.selected` | 直出字段 | 是否选中 |
| `attrsText` | `cart_item.attrs_text` | 快照字段 | 规格文案 |
| `isEffective` | `cart_item.is_effective` | 直出字段 | 是否有效 |

## order

### GET `/member/order/pre` / `/member/order/pre/now` / `/member/order/repurchase/:id`

#### OrderPreResult.goods[]

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `product.id` | 关联字段 | 商品 id |
| `name` | `product.name` 或 `cart_item.name` | 关联/快照字段 | 购物车结算可优先用购物车快照 |
| `picture` | `product.default_picture` 或 `cart_item.picture` | 关联/快照字段 | 商品图 |
| `count` | `cart_item.count` 或请求参数 | 直出字段 | 数量 |
| `skuId` | `product_sku.id` / `cart_item.sku_id` | 直出字段 | SKU id |
| `attrsText` | `product_sku.attrs_text` 或 `cart_item.attrs_text` | 关联/快照字段 | SKU 文案 |
| `price` | `product_sku.old_price` 或 `cart_item.price` | 关联/快照字段 | 原价 |
| `payPrice` | `product_sku.price` 或 `cart_item.now_price` | 关联/快照字段 | 实付单价 |
| `totalPrice` | `price * count` | 计算字段 | 小计原价 |
| `totalPayPrice` | `payPrice * count` | 计算字段 | 小计实付 |

#### OrderPreResult.summary

| 接口字段 | 来源 | 方式 | 说明 |
| --- | --- | --- | --- |
| `totalPrice` | 商品小计汇总 | 计算字段 | 汇总原价 |
| `postFee` | 运费规则 | 计算字段 | 首版可按业务规则计算 |
| `totalPayPrice` | 商品实付汇总 + 运费 | 计算字段 | 汇总实付 |

#### OrderPreResult.userAddresses

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `userAddresses` | `member_address` | 关联字段 | 复用 AddressItem 映射 |

### POST `/member/order`

#### 返回 `{ id }`

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `order_info.id` | 直出字段 | 订单主键 |

### GET `/member/order/:id`

#### OrderResult

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `order_info.id` | 直出字段 | 订单 id |
| `orderState` | `order_info.order_state` | 直出字段 | 订单状态 |
| `countdown` | `pay_latest_time - now()` | 计算字段 | 转为剩余秒数 |
| `receiverContact` | `order_info.receiver_contact` | 快照字段 | 收货人快照 |
| `receiverMobile` | `order_info.receiver_mobile` | 快照字段 | 手机号快照 |
| `receiverAddress` | `order_info.receiver_address` | 快照字段 | 地址全文快照 |
| `createTime` | `order_info.create_time` | 直出字段 | 下单时间 |
| `totalMoney` | `order_info.total_money` | 直出字段 | 商品总额 |
| `postFee` | `order_info.post_fee` | 直出字段 | 运费 |
| `payMoney` | `order_info.pay_money` | 直出字段 | 实付金额 |
| `skus` | `order_item` | 聚合字段 | 订单项列表 |

#### OrderResult.skus[]

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `id` | `order_item.sku_id` | 快照字段 | 返回 SKU id |
| `spuId` | `order_item.product_id` | 快照字段 | 返回商品 id |
| `name` | `order_item.name` | 快照字段 | 商品名 |
| `attrsText` | `order_item.attrs_text` | 快照字段 | 规格文案 |
| `quantity` | `order_item.quantity` | 快照字段 | 数量 |
| `curPrice` | `order_item.cur_price` | 快照字段 | 当前单价快照 |
| `image` | `order_item.image` | 快照字段 | 图片快照 |

### GET `/member/order`

#### OrderListResult

| 接口字段 | 来源 | 方式 | 说明 |
| --- | --- | --- | --- |
| `counts` | `COUNT(order_info.id)` | 计算字段 | 总条数 |
| `page` | 请求参数 | 直出字段 | 当前页 |
| `pages` | `ceil(counts / pageSize)` | 计算字段 | 总页数 |
| `pageSize` | 请求参数 | 直出字段 | 每页大小 |
| `items` | `order_info + order_item` | 聚合字段 | 每个订单聚合为一个对象 |
| `items[].totalNum` | `order_info.total_num` | 直出字段 | 商品件数 |

### GET `/member/order/:id/logistics`

#### OrderLogisticResult

| 接口字段 | 表.列 | 方式 | 说明 |
| --- | --- | --- | --- |
| `company.name` | `order_logistics.company_name` | 直出字段 | 物流公司名 |
| `company.number` | `order_logistics.logistics_no` | 直出字段 | 运单号 |
| `company.tel` | `order_logistics.company_tel` | 直出字段 | 联系电话 |
| `count` | `order_logistics.trace_count` | 直出字段 | 节点数 |
| `list` | `order_logistics_trace` | 聚合字段 | 轨迹节点数组 |
| `list[].id` | `order_logistics_trace.id` | 直出字段 | 节点 id |
| `list[].text` | `order_logistics_trace.text` | 直出字段 | 轨迹文案 |
| `list[].time` | `order_logistics_trace.trace_time` | 直出字段 | 轨迹时间 |

## payment

### GET `/pay/wxPay/miniPay`

#### MiniPayResult

| 接口字段 | 来源 | 方式 | 说明 |
| --- | --- | --- | --- |
| `timeStamp` | 微信下单响应 / 服务端签名结果 | 计算字段 | 非数据库字段 |
| `signType` | 微信下单响应 / 服务端签名结果 | 计算字段 | 非数据库字段 |
| `package` | 微信下单响应 / 服务端签名结果 | 计算字段 | 非数据库字段 |
| `paySign` | 微信下单响应 / 服务端签名结果 | 计算字段 | 非数据库字段 |
| `nonceStr` | 微信下单响应 / 服务端签名结果 | 计算字段 | 非数据库字段 |
| `appId` | 配置中心或微信响应 | 计算字段 | 非数据库字段 |

同时建议落库：

- `payment_record.order_id`
- `payment_record.member_id`
- `payment_record.pay_channel`
- `payment_record.pay_type`
- `payment_record.pay_status`
- `payment_record.amount`
- `payment_record.out_trade_no`
- `payment_record.pay_payload`

### GET `/pay/mock`

| 行为 | 来源 | 说明 |
| --- | --- | --- |
| 返回空结果 | 业务层统一赋值 | `result = null` 或 `{}` |
| 模拟支付记录 | `payment_record` | 插入一条成功支付记录 |
| 订单状态推进 | `order_info.order_state` | 由待付款推进到已支付后状态 |

## 特殊字段说明

### `fullLocation`

- 当前数据库已直接保存到 `member_user.full_location` 和 `member_address.full_location`
- 首版不要求运行时由省市区编码拼装

### `receiverAddress`

- 当前来自 `order_info.receiver_address`
- 必须是下单时快照，不应在订单详情时重新查询 `member_address`

### `attrsText`

- 商品详情阶段：来自 `product_sku.attrs_text` 或 `product_sku_value` 聚合结果
- 购物车阶段：来自 `cart_item.attrs_text`
- 订单阶段：来自 `order_item.attrs_text`

### `countdown`

- 来自 `order_info.pay_latest_time`
- 返回时按“剩余秒数”计算
- 若订单不处于待付款状态，可返回 `0` 或 `-1`，由业务层约定

### `similarProducts`

- 首版不单独建推荐关系表
- 查询 `product.secondary_category_id = 当前商品.secondary_category_id and product.id != 当前商品.id`
- 再按业务排序与数量限制返回

### `userAddresses`

- 当前数据库设计不在 `product` 表保存地址
- 商品详情若要返回 `userAddresses`，应登录后关联查询 `member_address`
- 订单预结算返回的 `userAddresses` 同样复用 `member_address`

### `goodsItems`

- 来自 `cms_hot_zone_item` 与 `product` 联表
- 按 `sub_type` 分组、按 `sort_order` 排序
- 再包装为 `PageResult<GoodsItem>`
