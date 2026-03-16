# V1 Schema 审计（Oracle）

审计对象：`city-mall-api/db/migration/V1__init_schema.sql`

对照材料：

- `city-mall-web/src/services/*`
- `docs/database/table-design.md`
- `docs/database/interface-field-mapping.md`
- `docs/api-compare/final-endpoint-contract.md`

## 结论

- 表集合覆盖了当前前端 `home/category/goods/hot/login/address/cart/order/pay` 的主要落库需求，整体结构可用。
- 与 `docs/database/table-design.md` 基本一致（表和核心列没有缺失）。
- 主要风险集中在：前端“必需字段”对应列的可空策略、若干读路径缺少复合索引、以及少量命名/语义容易误用的字段。

## 必须处理的问题（建议在开始业务模块开发前修正）

### 1. 合同与文档不一致

- 前端已使用 `PUT /member/profile`（`city-mall-web/src/services/profile.ts`），但 `docs/api-compare/final-endpoint-contract.md` 目前没有完整覆盖 profile 写接口与头像上传接口。

### 2. 可空列与默认值风险（前端类型更严格）

- `category.icon` 可空，但首页 `CategoryItem.icon` 目前按必需字段使用。
- `category.picture` 可空，但分类页类型要求图片存在。
- `cms_hot_zone.banner_picture` 可空，但热门页 `bannerPicture` 期望为字符串。
- `cms_hot_zone.pictures` 可空 JSON，但首页热门 `pictures: string[]` 期望数组。
- `product_sku.picture` 可空，但商品详情 SKU `picture: string` 期望必需。
- `product_spec_value.picture` 可空，但规格值 `picture: string` 期望必需。
- `member_user.gender` 默认 `'未知'`，但前端类型目前只允许 `'男'|'女'`。
- `member_address.full_location` 在表中必填，但前端创建/更新地址入参不提供该字段，后端必须由地区编码派生填充。

### 3. 登录建档规则不明确

- `/login/wxMin` 允许仅 `code`（手机号相关参数可选），但 `member_user.account`、`member_user.mobile` 在表中都是非空且唯一。
- 需要明确：无手机号时是否允许先建“半账号”，还是强制拿到手机号再落库。

### 4. 默认地址规则未约束

- `member_address.is_default` 存在，但 schema 没有限制同一用户只能有一个默认地址。

## 索引建议（与实际读路径更匹配）

- 多数查询都隐含 `deleted = 0`，建议关键读索引将 `deleted` 合并到复合索引中。
- `cms_banner`：读路径按 `distribution_site + is_show + deleted` 过滤并按 `sort_order` 排序，当前索引缺少 `is_show/deleted`。
- `category`：读路径按 `level/parent_id/is_show/deleted/sort_order`，当前索引不含展示/删除标记。
- `product`：读路径常按 `secondary_category_id + status + deleted`，当前索引较浅。
- 子表（图片、属性、规格、轨迹）：建议使用 `(fk, deleted, sort_order)` 以支持有序聚合。
- `order_info`：订单列表通常按 `member_id + order_state + deleted` 过滤并按时间排序，建议加上 `create_time`。

## 命名/语义提示（避免后续误用）

- `cart_item.id` 是行主键，但对外 `CartItem.id` 映射的是 `product_id`（按现有映射文档约定），开发时容易混淆。
- `order_item.id` 是行主键，但对外 `skus[].id` 映射的是 `sku_id`。
- `product_spec_value.descr` 对外映射 `desc`，是少数不一致命名点。
- `order_info.receiver_contact` 实际承载“收货人姓名”（对外字段名是 `receiverContact`），语义上容易被理解为联系方式。
