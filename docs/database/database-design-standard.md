# 全局数据库设计规范

> 本文件是数据库设计的全局规范源。GitHub 仓库内本文件优先级高于 Notion 归档、历史分析文档和旧版 ER 说明。Notion 只作归档，不作为 Codex / Agent 判断数据库规范的主依据。

## 1. 适用范围

本规范适用于本项目所有业务数据库设计、Flyway migration、SQL 初始化脚本、Entity / Mapper / DTO 字段设计，以及后续由 Codex、OpenCode、Hermes 等 Agent 生成或修改的数据库相关代码。

凡涉及新增表、修改表、补充字段、状态机落库、资金流水、订单履约、客户主体、合同、商品、库存、支付、结算等模块，均必须先按本规范设计数据库结构，再生成 Flyway migration。

## 2. 规范优先级

当不同资料存在冲突时，按以下顺序判断：

1. 本文件：`docs/database/database-design-standard.md`
2. 根目录 `AGENTS.md` 中对数据库规范的引用
3. 当前真实数据库结构、已执行 Flyway migration、线上/测试环境实际表结构
4. 领域专项设计文档，例如订单、资金、客户、合同、商品等模块文档
5. 历史文档，例如 `docs/database/table-design.md`、`docs/database/er-diagram.md`
6. Notion 归档资料

历史文档中出现的 `id`、`create_time`、`update_time`、`deleted` 等旧字段口径，仅作为历史参考；新设计统一使用本文件规定的 `f_*` 字段。

## 3. 主键规范

### 3.1 主键字段

所有业务表主键字段统一命名为：

```sql
f_id varchar(50) not null comment '主键' primary key
```

### 3.2 ID 生成规则

- 主键使用雪花 ID。
- 数据库存储类型统一为 `varchar(50)`。
- 业务代码中可按字符串处理，避免前端 JavaScript 数字精度问题。
- 禁止新业务表使用数据库自增主键作为主键。
- 禁止新业务表使用 `id` 作为主键字段名。
- 外键 / 关联字段应保存被关联表的 `f_id` 值，字段类型统一使用 `varchar(50)`。

示例：

```sql
f_customer_id varchar(50) null comment '客户主体id',
f_order_id    varchar(50) null comment '订单id'
```

## 4. 所有业务表必须包含的字段

所有业务表必须包含以下基础字段。除特殊说明外，不得随意删除、改名或改类型。

```sql
f_id                  varchar(50)  not null comment '主键' primary key,
f_tenant_id           varchar(50)  null comment '租户id',
f_delete_mark         int          null comment '删除标志',
f_delete_time         datetime     null comment '删除时间',
f_delete_user_id      varchar(50)  null comment '删除用户',
f_version             int          null comment '乐观锁',
f_flow_id             varchar(50)  null comment '流程id',
f_flow_task_id        varchar(50)  null comment '流程任务主键',
f_flow_state          int          null comment '流程任务状态',
f_creator_user_id     varchar(50)  null comment '创建用户',
f_last_modify_user_id varchar(50)  null comment '修改用户',
f_creator_time        datetime     null comment '创建时间',
f_last_modify_time    datetime     null comment '修改时间'
```

字段说明：

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `f_id` | `varchar(50)` | 是 | 主键，雪花 ID |
| `f_tenant_id` | `varchar(50)` | 否 | 租户 id，多租户隔离字段 |
| `f_delete_mark` | `int` | 否 | 删除标志，逻辑删除使用 |
| `f_delete_time` | `datetime` | 否 | 删除时间 |
| `f_delete_user_id` | `varchar(50)` | 否 | 删除用户 |
| `f_version` | `int` | 否 | 乐观锁版本号 |
| `f_flow_id` | `varchar(50)` | 否 | 流程 id |
| `f_flow_task_id` | `varchar(50)` | 否 | 流程任务主键 |
| `f_flow_state` | `int` | 否 | 流程任务状态 |
| `f_creator_user_id` | `varchar(50)` | 否 | 创建用户 |
| `f_last_modify_user_id` | `varchar(50)` | 否 | 修改用户 |
| `f_creator_time` | `datetime` | 否 | 创建时间 |
| `f_last_modify_time` | `datetime` | 否 | 修改时间 |

## 5. 逻辑删除规范

- 业务表默认使用逻辑删除，禁止直接物理删除业务数据。
- 逻辑删除统一使用 `f_delete_mark`。
- 删除时应同步写入：
  - `f_delete_mark`
  - `f_delete_time`
  - `f_delete_user_id`
- 查询业务有效数据时，必须默认过滤已删除数据。
- 如某些日志表、流水表、审计表原则上不可删除，也仍应保留基础字段，是否开放删除由业务规则决定。

建议口径：

| 值 | 含义 |
| --- | --- |
| `0` 或 `null` | 未删除 |
| `1` | 已删除 |

具体以基础框架 / MyBatis-Plus / JNPF 约定为准，但新表字段名必须保持本规范。

## 6. 多租户规范

- 所有业务表必须保留 `f_tenant_id`。
- 当前即使暂不启用多租户，也不得省略该字段。
- 多租户查询、写入、导入、导出、统计、报表均应考虑 `f_tenant_id` 隔离。
- 跨租户后台管理能力必须有明确权限边界，不得通过普通业务接口绕过租户隔离。

## 7. 审计字段规范

新增数据时，应写入：

- `f_creator_user_id`
- `f_creator_time`

修改数据时，应写入：

- `f_last_modify_user_id`
- `f_last_modify_time`

删除数据时，应写入：

- `f_delete_user_id`
- `f_delete_time`
- `f_delete_mark`

Agent 生成 Entity、Mapper XML、Service、SQL 时，必须考虑这些字段的写入与更新策略。

## 8. 乐观锁规范

- 需要防止并发覆盖的业务表，应使用 `f_version` 做乐观锁。
- 订单、资金账户、余额、库存、结算、合同额度等强一致场景必须重点考虑乐观锁或其他并发控制。
- 更新时不得无条件覆盖关键金额、库存、状态字段。

## 9. 流程字段规范

涉及审批流、业务流程、工作流任务的表，使用以下字段记录流程信息：

- `f_flow_id`
- `f_flow_task_id`
- `f_flow_state`

没有接入流程的业务表也必须保留这些字段，以便后续扩展。

## 10. 表命名规范

- 表名使用小写英文和下划线。
- 表名应表达业务语义，不使用无意义缩写。
- 表名建议使用领域前缀，例如：
  - `goods_`：商品域
  - `customer_`：客户域
  - `contract_`：合同域
  - `order_`：订单域
  - `payment_`：支付域
  - `settlement_`：结算域
  - `logistics_`：物流域
- 中间表、关联表应体现两端关系，例如：`customer_contract_relation`、`order_split_relation`。
- 禁止使用数据库关键字作为表名。

## 11. 字段命名规范

- 字段名使用小写英文和下划线。
- 平台基础字段统一使用 `f_*`。
- 业务字段不强制使用 `f_*` 前缀，优先表达业务含义。
- 关联字段统一使用 `<业务对象>_id`，类型为 `varchar(50)`，保存目标表 `f_id`。
- 时间字段建议使用 `_time` 后缀。
- 金额字段建议使用 `_amount`、`_money`、`_fee` 等明确后缀。
- 状态字段建议使用 `_status`，业务状态优先使用英文编码而不是纯数字。

示例：

```sql
order_status      varchar(50) null comment '订单状态',
pay_status        varchar(50) null comment '支付状态',
settlement_status varchar(50) null comment '结算状态',
customer_id       varchar(50) null comment '客户主体id'
```

说明：`f_flow_state` 是平台流程字段，可按框架要求使用 `int`；业务状态字段不等同于 `f_flow_state`。

## 12. 状态机字段规范

业务状态机字段必须满足：

- 字段名明确，例如 `order_status`、`pay_status`、`delivery_status`、`fund_status`、`settlement_status`。
- 新业务状态优先使用英文单词编码，例如 `pending`、`paid`、`cancelled`、`finished`。
- 同一状态字段必须在文档中列出：中文名、英文编码、触发条件、可流转目标状态。
- 数据库字段注释不能只写“状态”，必须写明状态含义或引用状态机文档。
- 代码枚举、数据库注释、接口文档、前端展示必须保持一致。

## 13. 金额与数量字段规范

- 金额字段必须使用定点小数，禁止使用 `float` / `double`。
- MySQL 推荐使用 `decimal(18,2)`；涉及高精度计量、单价、汇率时可按业务扩大精度。
- 订单、支付、退款、结算、余额、授信、手续费等资金字段必须保留可追溯流水。
- 数量字段应根据业务选择 `int`、`bigint` 或 `decimal`，涉及重量、体积、计量换算时优先使用 `decimal`。

## 14. 索引规范

- 主键索引统一由 `f_id` 提供。
- 高频查询字段必须建立普通索引。
- 唯一业务约束必须建立唯一索引。
- 关联字段建议建立索引。
- 多租户表常用查询应考虑 `f_tenant_id` 与业务字段的组合索引。
- 逻辑删除表的唯一索引设计必须考虑 `f_delete_mark`，避免软删除后无法重新创建同名业务数据。

命名建议：

| 类型 | 命名 |
| --- | --- |
| 普通索引 | `idx_<表名>_<字段名>` |
| 唯一索引 | `uk_<表名>_<字段名>` |
| 组合索引 | `idx_<表名>_<字段1>_<字段2>` |

## 15. Flyway 迁移规范

- 所有表结构变更必须通过 Flyway migration 管理。
- 禁止只改实体类或 Mapper，不提交数据库 migration。
- migration 文件必须可重复审查、可追溯、可在干净库执行。
- 已提交并执行过的 migration 原则上不得修改历史内容，应新增版本修正。
- 迁移脚本必须包含字段注释。
- 涉及已有数据的字段变更，应包含数据修复或默认值处理策略。
- 执行失败的 Flyway 状态必须先专项处理，禁止继续叠加不确定 migration。

## 16. 建表示例模板

新建业务表时，建议按以下结构组织字段：

```sql
create table example_business_table (
    f_id                  varchar(50)  not null comment '主键' primary key,
    f_tenant_id           varchar(50)  null comment '租户id',

    -- 业务字段
    name                  varchar(100) null comment '名称',
    status                varchar(50)  null comment '状态',

    -- 平台基础字段
    f_delete_mark         int          null comment '删除标志',
    f_delete_time         datetime     null comment '删除时间',
    f_delete_user_id      varchar(50)  null comment '删除用户',
    f_version             int          null comment '乐观锁',
    f_flow_id             varchar(50)  null comment '流程id',
    f_flow_task_id        varchar(50)  null comment '流程任务主键',
    f_flow_state          int          null comment '流程任务状态',
    f_creator_user_id     varchar(50)  null comment '创建用户',
    f_last_modify_user_id varchar(50)  null comment '修改用户',
    f_creator_time        datetime     null comment '创建时间',
    f_last_modify_time    datetime     null comment '修改时间'
) comment '示例业务表';
```

## 17. Agent 执行要求

Codex、OpenCode、Hermes 或其他 Agent 处理数据库任务时，必须遵守：

1. 先读取本文件，再做数据库设计。
2. 新表必须使用 `f_id varchar(50)` 作为主键。
3. 新表必须包含本规范列出的所有基础字段。
4. 所有关联 ID 字段必须使用 `varchar(50)`。
5. 所有 schema 变更必须生成 Flyway migration。
6. 生成 SQL 时必须写字段注释和表注释。
7. 涉及状态机时，必须同步更新状态机文档或在设计文档中列出状态流转。
8. 涉及资金、库存、订单、结算时，必须考虑幂等、并发、流水追溯。
9. 不得继续沿用旧文档中的 `id/create_time/update_time/deleted` 作为新表标准。

## 18. 设计检查清单

每次新增或修改表结构前，检查：

- [ ] 是否使用 `f_id varchar(50)` 作为主键？
- [ ] 是否使用雪花 ID？
- [ ] 是否包含全部基础字段？
- [ ] 是否包含字段注释和表注释？
- [ ] 是否需要租户隔离？
- [ ] 是否需要逻辑删除过滤？
- [ ] 是否需要乐观锁？
- [ ] 是否涉及流程字段？
- [ ] 关联字段是否为 `varchar(50)`？
- [ ] 金额字段是否使用 `decimal`？
- [ ] 状态字段是否有明确枚举和流转说明？
- [ ] 是否创建必要索引和唯一约束？
- [ ] 是否生成 Flyway migration？
- [ ] 是否同步更新相关 docs？
