# 平台适配总览

本目录用于把 `gov-ai-product-design-zh` 这个技能集合适配到不同官方客户端或运行环境。

当前集合包含 3 个并列 skill：

- `using-gov-ai-product-design-zh`：总入口 / 路由
- `gov-ai-discovery-zh`：前置 discovery 与 gating
- `gov-ai-agent-prd-zh`：Product Brief / PRD / Agent Spec

## 推荐适配方式

### Claude Code

Claude Code 原生支持 Skills、Subagents、Plugins 和 MCP。

最贴近官方的适配方式是把这 3 个 skill 打包成一个 Claude 插件：

- 插件根目录放 `.claude-plugin/plugin.json`
- 插件根目录放 `skills/`，里面是 3 个 skill 目录
- 如需统一工具连接，可在插件根目录放 `.mcp.json` 和 `settings.json`

见：
- `claude-code-zh.md`
- `templates/claude-plugin/`

### Codex / OpenAI

Codex 原生支持 Skills、AGENTS.md、Subagents 和 MCP。

最贴近官方的适配方式是：

- 把 3 个 skill 目录复制或软链接到 `.agents/skills/`
- 用 `AGENTS.md` 指示优先走 `using-gov-ai-product-design-zh`
- 用 `.codex/config.toml` 连接 MCP

见：
- `codex-openai-zh.md`
- `templates/codex/`

### Cursor

Cursor 没有与 Claude/Codex 完全同构的 `SKILL.md` 体系；官方主路径是 Project Rules、AGENTS.md 和 MCP。

推荐适配方式：

- 把总入口转成 `.cursor/rules/*.mdc`
- 用 `AGENTS.md` 说明什么时候走 discovery，什么时候走 PRD
- 用 `.cursor/mcp.json` 连接需要的 MCP 服务

见：
- `cursor-zh.md`
- `templates/cursor/`

### OpenCode

OpenCode 原生支持 Agent Skills、Agents、Commands、Plugins 和 MCP 配置。

推荐适配方式：

- 直接把 3 个 skill 目录复制或软链接到 `.opencode/skills/`
- 用 `opencode.json` 配权限、模型、MCP
- 如需治理能力，可在 `.opencode/plugins/` 放项目级插件

见：
- `opencode-zh.md`
- `templates/opencode/`

## 官方资料

- Claude Code Skills: https://code.claude.com/docs/en/skills
- Claude Code MCP: https://code.claude.com/docs/en/mcp
- Claude Code Plugins: https://code.claude.com/docs/en/plugins
- Codex Skills: https://developers.openai.com/codex/skills
- Codex MCP: https://developers.openai.com/codex/mcp
- OpenAI Docs MCP: https://developers.openai.com/learn/docs-mcp
- Cursor Rules: https://docs.cursor.com/context/rules
- Cursor MCP: https://docs.cursor.com/context/model-context-protocol
- Cursor CLI MCP: https://docs.cursor.com/cli/mcp
- OpenCode Config: https://opencode.ai/docs/config/
- OpenCode Skills: https://opencode.ai/docs/skills
- OpenCode Agents: https://opencode.ai/docs/agents/
- OpenCode Plugins: https://opencode.ai/docs/plugins/