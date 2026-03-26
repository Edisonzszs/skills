# Cursor 适配

## 官方能力映射

Cursor 官方主路径是：

- Project Rules：`.cursor/rules/*.mdc`
- AGENTS.md
- MCP：`mcp.json` / `~/.cursor/mcp.json`
- CLI MCP：`cursor-agent mcp ...`

官方资料：

- Rules: https://docs.cursor.com/context/rules
- MCP: https://docs.cursor.com/context/model-context-protocol
- CLI MCP: https://docs.cursor.com/cli/mcp

## 推荐落地方式

Cursor 没有和 Claude/Codex 同构的 `SKILL.md` 生态，所以最稳的适配方式是“规则化”：

- 用一条总入口 rule 表达 `using-gov-ai-product-design-zh`
- 用 AGENTS.md 补业务分流规则
- 用 MCP 连接外部工具

## 推荐映射

### 1. 总入口 Rule

把 `using-gov-ai-product-design-zh` 转成一个 Agent Requested rule：

- 文件位置：`.cursor/rules/using-gov-ai-product-design.mdc`
- 作用：先判断当前请求该走 discovery 还是 PRD

### 2. AGENTS.md

在项目根目录添加 `AGENTS.md`，明确：

- 政企 AI 场景先判断是否需要 AI / Agent
- 信息不足优先 discovery
- discovery 完整后再写 Product Brief / PRD / Agent Spec

### 3. MCP

Cursor 官方支持 `mcp.json`，Agent 会自动发现可用工具。

示例：

```json
{
  "mcpServers": {
    "openaiDeveloperDocs": {
      "url": "https://developers.openai.com/mcp"
    }
  }
}
```

## 推荐 MCP

- OpenAI Docs MCP
- GitHub MCP
- Playwright MCP
- Figma MCP

## 模板

见：`templates/cursor/`