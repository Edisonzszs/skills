export const GovAIGuardrails = async () => {
  return {
    "tool.execute.before": async (input) => {
      if (input.tool === "read" && String(input.args?.filePath || "").includes(".env")) {
        throw new Error("Do not read .env files in government and enterprise AI planning sessions")
      }
    },
    "shell.env": async (_input, output) => {
      output.env.GOV_AI_MODE = "true"
    }
  }
}