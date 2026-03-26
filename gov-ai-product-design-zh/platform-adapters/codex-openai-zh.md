# Codex / OpenAI 适配

## 官方能力映射

Codex 官方支持：

- Skills：仓库级 `.agents/skills/`
- `AGENTS.md`
- MCP：`codex mcp add` 或 `.codex/config.toml`
- Subagents / custom agents

官方资料：

- Codex Skills: https://developers.openai.com/codex/skills
- Codex MCP: https://developers.openai.com/codex/mcp
- Codex Overview: https://developers.openai.com/codex
- Docs MCP: https://developers.openai.com/learn/docs-mcp
- Introducing Codex: https://openai.com/index/introducing-codex/

## 推荐落地方式

Codex 最贴近官方的适配方式不是“嵌套集合目录直接识别”，而是把集合中的具体 skill 放到仓库的 `.agents/skills/` 下。

### 推荐映射

- `using-gov-ai-product-design-zh` -> `.agents/skills/using-gov-ai-product-design-zh/`
- `gov-ai-discovery-zh` -> `.agents/skills/gov-ai-discovery-zh/`
- `gov-ai-agent-prd-zh` -> `.agents/skills/gov-ai-agent-prd-zh/`

## 最小连接方案

### 1. AGENTS.md

在仓库根目录加一个 `AGENTS.md`，明确：

- 政企 AI 产品规划优先使用 `using-gov-ai-product-design-zh`
- 信息不充分先走 discovery
- discovery 充分后再写 Product Brief / PRD / Agent Spec

### 2. MCP

用 `codex mcp add` 添加共享工具：

```bash
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
```

或直接写到 `.codex/config.toml`：

```toml
[mcp_servers.openaiDeveloperDocs]
url = "https://developers.openai.com/mcp"
```

Codex 官方说明：CLI 和 IDE extension 共用同一份 MCP 配置；默认配置文件是 `~/.codex/config.toml`，trusted project 也可以用项目级 `.codex/config.toml`。

## 推荐 MCP

- OpenAI Docs MCP
- GitHub MCP
- Playwright MCP
- Figma MCP

## 技能启用建议

如果只想让用户走总入口，可以把总入口以外的 skill 设为不默认触发，主要通过 `AGENTS.md` 做软约束。

## 模板

见：`templates/codex/`
