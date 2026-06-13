# 城代商城 Codex 协作流程

状态：planned。用于指导 Codex 在城代商城项目中的读取、修改、验证和汇报方式。

## 读取顺序

1. 先读 AGENTS.md，确认当前仓库规则。
2. 再读 README.md，确认目录结构和当前进度。
3. 涉及业务规则时，读取 docs/city-mall-doc-index.md 与 docs/city-mall-business-rules.md。
4. 涉及前端时，读取 city-mall-h5 的 README、package.json、src/services、src/types、src/pages。
5. 涉及后端时，读取 city-mall-api 的 pom.xml、src/main、src/main/resources、db/migration。

## 修改边界

- 只修改任务明确指定的仓库和目录。
- 跨前后端任务先分析接口契约，再修改代码。
- 数据库结构变更必须补迁移脚本。
- 不写入真实账号、密码、token、生产连接地址。
- 历史文档可作为参考，最终以真实代码、SQL、接口和用户确认结论为准。

## 输出要求

每次任务结束必须说明：

- 修改了哪些文件。
- 是否运行验证命令。
- 验证结果如何。
- 哪些内容仍未确认。
- 是否涉及前后端接口同步。
- 是否涉及数据库迁移。

## 常用验证

前端：

- npm --prefix city-mall-web run lint
- npm --prefix city-mall-web run tsc
- npm --prefix city-mall-web run build:h5

后端：

- mvn test
- mvn spring-boot:run

如果当前仓库没有对应脚本，必须说明未执行原因，不得编造测试结果。
