# Next Step Audit (Docs Only)

审计范围（只读）：

- `docs/frontend-analysis/*`
- `docs/api-compare/*`
- `docs/database/*`
- `AGENTS.md`
- `city-mall-web/src/services/*`

目标：在不生成代码的前提下，判断哪些文档已足够驱动后端工程创建与模块生成、哪些需要补充，以及优先落地顺序。

## 1) 哪些现有文档可直接使用（as-is）

### 前端使用证据（可直接作为事实来源）

- `docs/frontend-analysis/api-list.md`
- `docs/frontend-analysis/page-api-mapping.md`
- `docs/frontend-analysis/field-usage.md`
- `docs/frontend-analysis/missing-api.md`

理由：以上文档以 `city-mall-web/src/services/*` 与页面调用为主线，能直接说明“当前前端真的在调用什么、消费哪些字段”。

### API 对照与收敛材料（总体可用）

- `docs/api-compare/conflict-report.md`
- `docs/api-compare/final-field-dictionary.md`
- `docs/api-compare/dto-vo-list.md`

理由：冲突点、字段口径、DTO/VO 颗粒度已具备，能支撑后端建模与接口输出。

### 数据库设计文档（可作为 V1 的直接依据）

- `docs/database/er-diagram.md`
- `docs/database/table-design.md`
- `docs/database/interface-field-mapping.md`
- `city-mall-api/db/migration/V1__init_schema.sql`
- `city-mall-api/db/migration/V2__seed_basic_data.sql`

理由：已覆盖前端闭环所需核心实体（分类/商品/SKU/用户/地址/购物车/订单/订单项/支付记录）并提供了“表字段到接口字段”的映射解释。

## 2) 哪些文档不完整，需要补充（补充点必须可验证）

### A. 最终接口合同不“最终”

`docs/api-compare/final-endpoint-contract.md` 当前缺失以下“前端已实际调用”的接口：

- 热门推荐：前端使用 `getHotRecommendAPI(url)` 动态请求（见 `city-mall-web/src/services/hot.ts`），实际页面会访问：
  - `/hot/preference`
  - `/hot/inVogue`
  - `/hot/oneStop`
  - `/hot/new`
  但 `final-endpoint-contract.md` 未纳入。
- 个人资料：前端已调用（见 `city-mall-web/src/services/profile.ts`）
  - `GET /member/profile`
  - `PUT /member/profile`
  且头像上传页面直传（见 `docs/frontend-analysis/api-list.md`）
  - `POST /member/profile/avatar`
  但 `final-endpoint-contract.md` 未纳入。

影响：后端若严格按该“最终合同”生成，将无法覆盖 `pages/hot/hot.vue` 与 `pagesMember/profile/profile.vue` 的真实接口调用。

最低补充要求：

- 把上述缺失接口补进 `final-endpoint-contract.md`
- 明确 `HotResult/SubTypeItem` 的返回结构（可直接复用 `docs/frontend-analysis/api-list.md` 的定义）
- 明确 `ProfileDetail/ProfileParams` 与头像上传返回结构（`result.avatar`）

### B. 文档间存在口径分裂，需要明确“唯一真相”

- `docs/api-compare/final-field-dictionary.md` 与 `docs/database/interface-field-mapping.md` 已覆盖 `/hot/*` 与 `/member/profile*`，但 `final-endpoint-contract.md` 没有。
- 结论：需要把 `final-endpoint-contract.md` 变成唯一真相（后端生成应只跟这个文件走）。

### C. 工程创建前的若干全局约定仍需定稿

这些不是“写代码”，但会影响工程骨架与后续模块生成的一致性：

- `id` 出参类型：前端合同里多处写 `string`，登录 `id` 又写 `number`；建议统一对外序列化为字符串（数据库内部用 `bigint`）。
- 空结果约定：写接口目前写 `result: null` 或 `{}`；建议统一一种。
- 时间字段格式：如 `createTime`、物流 `time`；需统一为 ISO 字符串或 `yyyy-MM-dd HH:mm:ss`。
- 金额字段口径：合同已倾向 `number`；需要明确后端序列化与精度（数据库 `decimal`）。
- `Authorization` 头：前端发送裸 token，不应强制 `Bearer`。

## 3) 创建 city-mall-api 之前，最小需要补齐哪些输入

在开始创建 `city-mall-api` 工程骨架前，建议最小补齐以下 4 项“输入”，否则会造成返工：

1. 更新 `docs/api-compare/final-endpoint-contract.md`：补齐 `/hot/*` 与 `/member/profile*`（含头像上传）。
2. 明确全局序列化约定：`id`、时间、金额、空结果（写入 `docs/api-compare/final-endpoint-contract.md` 的全局约定段落即可）。
3. 明确订单状态推进的最小规则：至少定义 `order_state` 在 `/pay/mock` 后进入哪个状态（待发货/待收货）。
4. 明确运费与倒计时的最小规则：
   - 运费 `postFee` 首版可固定 0，但需写明。
   - `countdown` 由 `pay_latest_time` 计算，首版可设 `create_time + 30min`。

## 4) 哪些后端模块可以低风险优先生成（按“依赖最少 + 读多写少”排序）

低风险优先顺序（建议）：

1. `home`（读接口）
   - `/home/banner`、`/home/category/mutli`、`/home/hot/mutli`、`/home/goods/guessLike`
2. `hot`（读接口）
   - `/hot/preference`、`/hot/inVogue`、`/hot/oneStop`、`/hot/new`
3. `category`（读接口）
   - `/category/top`
4. `product`（读接口）
   - `/goods`

中风险（需要登录态，但逻辑相对直观）：

- `address`：`/member/address*`
- `cart`：`/member/cart*`（注意操作主键是 `skuId`，删除体 `ids` 语义）
- `auth`：优先落地 `/login/wxMin/simple` 作为联调入口，再扩展微信登录

高风险（状态流转与幂等要求更高，建议在前面稳定后再做）：

- `order`：预订单/下单/取消/收货/列表/详情/物流
- `payment`：先实现 `/pay/mock`，正式微信支付后置

## Oracle 审计结论

Oracle 已完成对 `AGENTS.md`、`docs/frontend-analysis/*`、`docs/api-compare/*`、`docs/database/*` 以及 `city-mall-web/src/services/*` 的只读审计。结论要点如下（以 Oracle 结果为准，补充点已和本文件前文对齐）：

### 1) 可直接使用（as-is）

- `AGENTS.md`
- `docs/frontend-analysis/api-list.md`
- `docs/frontend-analysis/field-usage.md`
- `docs/frontend-analysis/page-api-mapping.md`
- `docs/frontend-analysis/missing-api.md`（作为 backlog/context，不作为第一阶段强制合同）
- `docs/api-compare/conflict-report.md`
- `docs/api-compare/dto-vo-list.md`（作为模型清单支撑）
- `docs/database/er-diagram.md`
- `docs/database/table-design.md`
- `docs/database/interface-field-mapping.md`

### 2) 需要补充

- `docs/api-compare/final-endpoint-contract.md`
  - 缺少前端已实际使用的会员资料相关接口：
    - `GET /member/profile`
    - `PUT /member/profile`
    - `POST /member/profile/avatar`
  - 这些接口在 `city-mall-web/src/services/profile.ts` 中已明确调用，头像上传在页面中使用 `uni.uploadFile` 直传。
- `docs/api-compare/final-field-dictionary.md`
  - 需要把以下字段类型/口径同步到“冻结后的合同口径”（或显式标注为待前端改动）：
    - `ProfileDetail.id`
    - `OrderPreGoods` 的金额字段类型
    - `GoodsResult.userAddresses`
    - `OrderLogisticResult.company/count`
    - `GoodsItem.discount/orderNum`

### 3) 创建 city-mall-api 之前的最小输入

- 把缺失的 member profile/avatar upload 三个接口写入 `docs/api-compare/final-endpoint-contract.md`
- 明确一条对外类型规则：member `id`、订单金额字段（string/number）
- 明确头像上传鉴权/请求头行为：因为 `uni.uploadFile` 绕过 `http.ts`，当前上传请求不一定携带 `Authorization`、`source-client`
- 冻结第一阶段范围；若第一阶段只做 `home/category/product`，其余业务输入不阻塞工程创建

### 4) 低风险优先生成模块

- 第一批（低风险）：`home`、`category`、`product`
- 第二批（在合同补齐后）：`member/profile`、`address`
- 后置（建议延后）：`auth login`、`cart`、`order`、`payment`（尤其真实支付）
