# OpenCode 适配

## 官方能力映射

OpenCode 官方支持：

- Skills：`.opencode/skills/`，也兼容 `.claude/skills/` 和 `.agents/skills/`
- Agents：`.opencode/agents/`
- Commands：`.opencode/commands/`
- Plugins：`.opencode/plugins/`
- Config：`opencode.json`

官方资料：

- Intro: https://opencode.ai/docs/
- Config: https://opencode.ai/docs/config/
- Skills: https://opencode.ai/docs/skills
- Agents: https://opencode.ai/docs/agents/
- Commands: https://opencode.ai/docs/commands/
- Plugins: https://opencode.ai/docs/plugins/

## 推荐落地方式

OpenCode 和 Claude/Codex 的技能目录结构最接近，所以适配最直接。

### 推荐映射

把这 3 个 skill 复制或软链接到：

- `.opencode/skills/using-gov-ai-product-design-zh/`
- `.opencode/skills/gov-ai-discovery-zh/`
- `.opencode/skills/gov-ai-agent-prd-zh/`

OpenCode 官方还说明它兼容 `.claude/skills/` 和 `.agents/skills/`，因此如果团队同时兼容多平台，也可以复用同一套 skill 目录。

## 配置建议

### 1. opencode.json

在项目根目录增加：

- provider / model
- permission
- mcp
- default_agent（如果需要）

### 2. 插件

如果你要给这个技能集合加治理能力，例如：

- 阻止读取 `.env`
- 记录审计日志
- 注入项目级环境变量
- 增加自定义审批钩子

可以在 `.opencode/plugins/` 写项目插件。

## 推荐 MCP / 插件组合

- MCP：OpenAI Docs / GitHub / Playwright / Figma
- 插件：基础 guardrails 插件

## 模板

见：`templates/opencode/`