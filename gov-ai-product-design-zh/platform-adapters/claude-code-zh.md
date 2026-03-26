# Claude Code 适配

## 官方能力映射

Claude Code 官方支持：

- Skills：`.claude/skills/<name>/SKILL.md`
- Project / personal / plugin 级 skills
- Subagents：`.claude/agents/`
- MCP：`claude mcp add`、`.mcp.json`、`~/.claude.json`
- Plugins：插件根目录下可包含 `skills/`、`agents/`、`.mcp.json`、`settings.json`

官方资料：

- Skills: https://code.claude.com/docs/en/skills
- Subagents: https://code.claude.com/docs/en/sub-agents
- MCP: https://code.claude.com/docs/en/mcp
- Plugins: https://code.claude.com/docs/en/plugins

## 推荐落地方式

对这个仓库，推荐以“插件”方式适配，而不是直接把整个集合平铺到 `.claude/skills`。

原因：

- 你有一个技能集合，而不是单个 skill
- Claude 插件可以把 skills、agents、MCP、settings 一起打包
- 技能会自动带命名空间，避免和其他 skill 冲突

## 推荐插件结构

```text
my-gov-ai-plugin/
  .claude-plugin/
    plugin.json
  skills/
    using-gov-ai-product-design-zh/
      SKILL.md
    gov-ai-discovery-zh/
      SKILL.md
    gov-ai-agent-prd-zh/
      SKILL.md
  .mcp.json
  settings.json
```

## 连接方式

### 1. 本地开发测试

```bash
claude --plugin-dir ./my-gov-ai-plugin
```

然后在 Claude Code 里：

```text
/reload-plugins
```

### 2. MCP 连接

项目共享型服务器优先用 project scope，这样会写到项目根的 `.mcp.json`。例如：

```bash
claude mcp add --transport http --scope project openai-docs https://developers.openai.com/mcp
```

Claude 官方说明：project scope 会写到项目根的 `.mcp.json`，适合团队共享；local/user scope 则写到 `~/.claude.json`。

### 3. 推荐绑定的 MCP

至少建议：

- OpenAI Docs MCP
- GitHub MCP
- Playwright MCP
- Figma MCP（如果有设计稿）

## 建议的技能路由

- 统一入口：`/my-plugin:using-gov-ai-product-design-zh`
- discovery：`/my-plugin:gov-ai-discovery-zh`
- prd：`/my-plugin:gov-ai-agent-prd-zh`

如果只想保留一个对外入口，就把 `using-gov-ai-product-design-zh` 放给用户直接调用，其他两个留给模型自动加载或由总入口调用。

## 模板

见：`templates/claude-plugin/`