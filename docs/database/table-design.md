# 表设计说明

本文件在 ER 基础上进一步细化字段、索引和用途，用于指导 `V1__init_schema.sql`。

## 通用约定

### 公共字段

所有表统一包含：

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | `bigint unsigned` | 主键 |
| `create_time` | `datetime(3)` | 创建时间 |
| `update_time` | `datetime(3)` | 更新时间 |
| `deleted` | `tinyint(1)` | 逻辑删除标记，`0/1` |

### 命名规范

- 表名使用业务语义，不使用复数
- 字段名优先对齐前端合同，如 `nickname`、`full_location`、`order_state`
- 关联字段统一使用 `<entity>_id`

## 1. category

用途：维护一级、二级分类。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `parent_id` | `bigint unsigned` | 默认 `0` | 父分类 id，一级分类为 `0` |
| `name` | `varchar(64)` | 非空 | 分类名称 |
| `icon` | `varchar(255)` | 可空 | 首页分类图标 |
| `picture` | `varchar(255)` | 可空 | 分类图片 |
| `level` | `tinyint unsigned` | 非空 | 分类层级，`1/2` |
| `sort_order` | `int` | 默认 `0` | 排序值 |
| `is_show` | `tinyint(1)` | 默认 `1` | 是否展示 |

索引建议：

- `idx_category_parent_id`
- `idx_category_level_sort`

## 2. product

用途：SPU 商品主信息。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `primary_category_id` | `bigint unsigned` | 非空 | 一级分类 |
| `secondary_category_id` | `bigint unsigned` | 非空 | 二级分类 |
| `name` | `varchar(128)` | 非空 | 商品名称 |
| `desc` | `varchar(255)` | 非空 | 商品描述 |
| `price` | `decimal(10,2)` | 非空 | 默认展示价格 |
| `old_price` | `decimal(10,2)` | 非空 | 划线价 |
| `default_picture` | `varchar(255)` | 非空 | 默认主图 |
| `status` | `tinyint unsigned` | 默认 `1` | 商品状态 |
| `brand_name` | `varchar(64)` | 可空 | 品牌名，预留 |
| `sales_count` | `int unsigned` | 默认 `0` | 销量，预留 |
| `comment_count` | `int unsigned` | 默认 `0` | 评论数，预留 |

索引建议：

- `idx_product_primary_category_id`
- `idx_product_secondary_category_id`
- `idx_product_status`

## 3. product_main_picture

用途：商品主图轮播。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `picture` | `varchar(255)` | 非空 | 图片地址 |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 4. product_detail_picture

用途：商品详情图。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `picture` | `varchar(255)` | 非空 | 详情图片 |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 5. product_detail_property

用途：商品属性展示块，对应前端 `details.properties`。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `name` | `varchar(64)` | 非空 | 属性名 |
| `value` | `varchar(255)` | 非空 | 属性值 |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 6. product_spec

用途：规格组，例如颜色、尺寸。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `name` | `varchar(64)` | 非空 | 规格名 |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 7. product_spec_value

用途：规格值，例如黑色、8 寸。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_spec_id` | `bigint unsigned` | 非空 | 规格组 id |
| `name` | `varchar(64)` | 非空 | 规格值名称 |
| `picture` | `varchar(255)` | 可空 | 规格图 |
| `descr` | `varchar(255)` | 默认空串 | 规格备注，对应前端 `desc` |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 8. product_sku

用途：SKU 信息。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `sku_code` | `varchar(64)` | 非空唯一 | SKU 编码 |
| `price` | `decimal(10,2)` | 非空 | SKU 当前价格 |
| `old_price` | `decimal(10,2)` | 非空 | SKU 原价 |
| `inventory` | `int unsigned` | 默认 `0` | 库存 |
| `picture` | `varchar(255)` | 可空 | SKU 图 |
| `attrs_text` | `varchar(255)` | 非空 | 规格文案快照 |
| `status` | `tinyint unsigned` | 默认 `1` | 状态 |

索引建议：

- `uk_product_sku_sku_code`
- `idx_product_sku_product_id`

## 9. product_sku_value

用途：SKU 与规格值的映射表。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `product_sku_id` | `bigint unsigned` | 非空 | SKU id |
| `product_spec_value_id` | `bigint unsigned` | 非空 | 规格值 id |
| `spec_name` | `varchar(64)` | 非空 | 规格名快照 |
| `value_name` | `varchar(64)` | 非空 | 规格值快照 |

索引建议：

- `uk_product_sku_value_unique`

## 10. cms_banner

用途：轮播配置，支撑首页和分类页 banner。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `distribution_site` | `tinyint unsigned` | 非空 | `1首页 2分类页` |
| `img_url` | `varchar(255)` | 非空 | 图片地址 |
| `href_url` | `varchar(255)` | 默认空串 | 跳转地址 |
| `type` | `tinyint unsigned` | 默认 `1` | 跳转类型 |
| `product_id` | `bigint unsigned` | 可空 | 关联商品 |
| `category_id` | `bigint unsigned` | 可空 | 关联分类 |
| `sort_order` | `int` | 默认 `0` | 排序 |
| `is_show` | `tinyint(1)` | 默认 `1` | 是否展示 |

## 11. cms_hot_zone

用途：热门专区主表，对应 `/home/hot/mutli` 和 `/hot/*`。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `code` | `varchar(32)` | 非空唯一 | 推荐区编码，如 `preference` |
| `title` | `varchar(64)` | 非空 | 标题 |
| `alt` | `varchar(128)` | 默认空串 | 副标题 |
| `target` | `varchar(128)` | 默认空串 | 跳转目标 |
| `type` | `varchar(32)` | 默认空串 | 业务类型 |
| `banner_picture` | `varchar(255)` | 可空 | 热门页封面 |
| `pictures` | `json` | 可空 | 首页热门图集 |
| `sort_order` | `int` | 默认 `0` | 排序 |
| `is_show` | `tinyint(1)` | 默认 `1` | 是否展示 |

## 12. cms_hot_zone_item

用途：热门专区商品配置。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `hot_zone_id` | `bigint unsigned` | 非空 | 热门专区 id |
| `sub_type` | `varchar(32)` | 默认空串 | 子分组编码 |
| `sub_title` | `varchar(64)` | 非空 | 子分组标题 |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 13. member_user

用途：会员主表，支持微信登录与 H5 登录。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `account` | `varchar(64)` | 非空唯一 | 账号 |
| `password_hash` | `varchar(255)` | 可空 | H5 密码哈希 |
| `mobile` | `varchar(20)` | 非空唯一 | 手机号 |
| `nickname` | `varchar(64)` | 默认空串 | 昵称 |
| `avatar` | `varchar(255)` | 默认空串 | 头像 |
| `gender` | `varchar(16)` | 默认 `未知` | 性别 |
| `birthday` | `date` | 可空 | 生日 |
| `profession` | `varchar(64)` | 默认空串 | 职业 |
| `province_code` | `varchar(20)` | 可空 | 省编码 |
| `city_code` | `varchar(20)` | 可空 | 市编码 |
| `county_code` | `varchar(20)` | 可空 | 区县编码 |
| `full_location` | `varchar(255)` | 默认空串 | 省市区文案 |
| `openid` | `varchar(64)` | 可空唯一 | 微信 openid |
| `union_id` | `varchar(64)` | 可空 | 微信 unionId |
| `status` | `tinyint unsigned` | 默认 `1` | 用户状态 |

## 14. member_address

用途：收货地址。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `member_id` | `bigint unsigned` | 非空 | 用户 id |
| `receiver` | `varchar(64)` | 非空 | 收货人 |
| `contact` | `varchar(20)` | 非空 | 联系方式 |
| `province_code` | `varchar(20)` | 非空 | 省编码 |
| `city_code` | `varchar(20)` | 非空 | 市编码 |
| `county_code` | `varchar(20)` | 非空 | 区县编码 |
| `full_location` | `varchar(255)` | 非空 | 省市区文案 |
| `address` | `varchar(255)` | 非空 | 详细地址 |
| `is_default` | `tinyint(1)` | 默认 `0` | 默认地址 |

索引建议：

- `idx_member_address_member_id`
- `idx_member_address_member_default`

## 15. cart_item

用途：购物车项。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `member_id` | `bigint unsigned` | 非空 | 用户 id |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `sku_id` | `bigint unsigned` | 非空 | SKU id |
| `name` | `varchar(128)` | 非空 | 商品名快照 |
| `picture` | `varchar(255)` | 非空 | 商品图快照 |
| `count` | `int unsigned` | 非空 | 数量 |
| `price` | `decimal(10,2)` | 非空 | 加入时价格 |
| `now_price` | `decimal(10,2)` | 非空 | 当前价格 |
| `stock` | `int unsigned` | 非空 | 当前库存 |
| `selected` | `tinyint(1)` | 默认 `1` | 是否选中 |
| `attrs_text` | `varchar(255)` | 非空 | SKU 规格文案 |
| `is_effective` | `tinyint(1)` | 默认 `1` | 是否有效 |

索引建议：

- `uk_cart_item_member_sku`
- `idx_cart_item_member_selected`

## 16. order_info

用途：订单主表。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `member_id` | `bigint unsigned` | 非空 | 用户 id |
| `order_state` | `tinyint unsigned` | 非空 | 订单状态 |
| `pay_type` | `tinyint unsigned` | 非空 | 支付方式 |
| `pay_channel` | `tinyint unsigned` | 非空 | 支付渠道 |
| `delivery_time_type` | `tinyint unsigned` | 非空 | 配送时间类型 |
| `buyer_message` | `varchar(255)` | 默认空串 | 买家留言 |
| `total_num` | `int unsigned` | 非空 | 商品总件数 |
| `total_money` | `decimal(10,2)` | 非空 | 商品总额 |
| `post_fee` | `decimal(10,2)` | 非空 | 运费 |
| `pay_money` | `decimal(10,2)` | 非空 | 实付金额 |
| `receiver_contact` | `varchar(64)` | 非空 | 收货人 |
| `receiver_mobile` | `varchar(20)` | 非空 | 收货手机号 |
| `receiver_address` | `varchar(255)` | 非空 | 收货地址全文 |
| `pay_latest_time` | `datetime(3)` | 可空 | 最晚支付时间 |
| `pay_time` | `datetime(3)` | 可空 | 支付时间 |
| `consign_time` | `datetime(3)` | 可空 | 发货时间 |
| `receipt_time` | `datetime(3)` | 可空 | 确认收货时间 |
| `end_time` | `datetime(3)` | 可空 | 完成时间 |
| `close_time` | `datetime(3)` | 可空 | 关闭时间 |
| `cancel_reason` | `varchar(255)` | 默认空串 | 取消原因 |

索引建议：

- `idx_order_info_member_state`
- `idx_order_info_pay_latest_time`

## 17. order_item

用途：订单明细表。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `order_id` | `bigint unsigned` | 非空 | 订单 id |
| `product_id` | `bigint unsigned` | 非空 | 商品 id |
| `sku_id` | `bigint unsigned` | 非空 | SKU id |
| `name` | `varchar(128)` | 非空 | 商品名快照 |
| `image` | `varchar(255)` | 非空 | 商品图快照 |
| `attrs_text` | `varchar(255)` | 非空 | SKU 文案快照 |
| `quantity` | `int unsigned` | 非空 | 数量 |
| `cur_price` | `decimal(10,2)` | 非空 | 当前单价 |
| `real_pay` | `decimal(10,2)` | 非空 | 实付单价 |
| `total_money` | `decimal(10,2)` | 非空 | 小计金额 |

索引建议：

- `idx_order_item_order_id`
- `idx_order_item_product_id`

## 18. order_logistics

用途：订单物流主记录。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `order_id` | `bigint unsigned` | 非空唯一 | 订单 id |
| `company_name` | `varchar(64)` | 非空 | 物流公司名 |
| `logistics_no` | `varchar(64)` | 非空 | 运单号 |
| `company_tel` | `varchar(32)` | 默认空串 | 物流联系电话 |
| `trace_count` | `int unsigned` | 默认 `0` | 轨迹节点数 |

## 19. order_logistics_trace

用途：物流轨迹节点。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `logistics_id` | `bigint unsigned` | 非空 | 物流主记录 id |
| `text` | `varchar(255)` | 非空 | 轨迹文案 |
| `trace_time` | `datetime(3)` | 非空 | 轨迹时间 |
| `sort_order` | `int` | 默认 `0` | 排序 |

## 20. payment_record

用途：支付记录与支付回调留痕。

| 字段 | 类型 | 约束 | 说明 |
| --- | --- | --- | --- |
| `order_id` | `bigint unsigned` | 非空 | 订单 id |
| `member_id` | `bigint unsigned` | 非空 | 用户 id |
| `pay_channel` | `tinyint unsigned` | 非空 | 支付渠道 |
| `pay_type` | `tinyint unsigned` | 非空 | 支付方式 |
| `pay_status` | `tinyint unsigned` | 非空 | 支付状态 |
| `amount` | `decimal(10,2)` | 非空 | 支付金额 |
| `out_trade_no` | `varchar(64)` | 非空唯一 | 本系统支付单号 |
| `transaction_no` | `varchar(64)` | 可空 | 第三方流水号 |
| `pay_time` | `datetime(3)` | 可空 | 支付成功时间 |
| `callback_time` | `datetime(3)` | 可空 | 回调时间 |
| `pay_payload` | `json` | 可空 | 发起支付报文 |
| `callback_payload` | `json` | 可空 | 支付回调报文 |

索引建议：

- `idx_payment_record_order_id`
- `idx_payment_record_member_id`
- `uk_payment_record_out_trade_no`

## 首版接口到表的映射

| 接口 | 主要读写表 |
| --- | --- |
| `/home/banner` | `cms_banner` |
| `/home/category/mutli` | `category` |
| `/home/hot/mutli`、`/hot/*` | `cms_hot_zone`、`cms_hot_zone_item`、`product` |
| `/category/top` | `category`、`product` |
| `/goods` | `product`、`product_main_picture`、`product_detail_picture`、`product_detail_property`、`product_spec`、`product_spec_value`、`product_sku`、`product_sku_value` |
| `/login*`、`/member/profile` | `member_user` |
| `/member/address*` | `member_address` |
| `/member/cart*` | `cart_item`、`product`、`product_sku` |
| `/member/order/pre*` | `cart_item`、`member_address`、`product_sku`、`product` |
| `/member/order*` | `order_info`、`order_item`、`member_address` |
| `/member/order/:id/logistics` | `order_logistics`、`order_logistics_trace` |
| `/pay/*` | `payment_record`、`order_info` |
