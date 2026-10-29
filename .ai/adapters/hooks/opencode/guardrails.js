/**
 * ai-agent-relay guardrail plugin for OpenCode.
 *
 * Blocks destructive bash commands and secret file reads/edits before they run.
 * This is enforcement (tool.execute.before), not advice.
 *
 * Install:
 *   mkdir -p .opencode/plugins
 *   cp .ai/adapters/hooks/opencode/guardrails.js .opencode/plugins/
 *
 * @type {import("@opencode-ai/plugin").Plugin}
 */
const DESTRUCTIVE = [
  /\brm\s+-rf\b/,
  /\bgit\s+push\s+(-f|--force)\b/,
  /\bgit\s+reset\s+--hard\b/,
  /\bgit\s+clean\s+-[a-z]*[fxd]/,
  /\bterraform\s+(apply|destroy)\b/,
  /\btofu\s+(apply|destroy)\b/,
  /\bkubectl\s+(apply|delete)\b/,
  /\bdocker\s+(system\s+prune|volume\s+rm)\b/,
  /\b(DROP\s+(TABLE|DATABASE)|TRUNCATE\s+TABLE)\b/i,
]

const SECRET_READ = /\b(cat|less|more|head|tail)\s+.*(\.env|\.aws\/credentials|\.ssh\/id_)/

const SECRET_PATH = /(^|\/)(\.env(\..*)?|secrets?|credentials?)(\/|$|\.)/i

export const GuardrailsPlugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "bash") {
        const cmd = String(output.args?.command ?? "")
        for (const pattern of DESTRUCTIVE) {
          if (pattern.test(cmd)) {
            throw new Error(
              "Blocked by ai-agent-relay guardrails: destructive or mutating command. See .ai/GUARDRAILS.md and request explicit authorization.",
            )
          }
        }
        if (SECRET_READ.test(cmd)) {
          throw new Error(
            "Blocked by ai-agent-relay guardrails: reading secrets or credentials. See .ai/GUARDRAILS.md and request explicit authorization.",
          )
        }
      }
      if (input.tool === "read" || input.tool === "edit" || input.tool === "write") {
        const path = String(output.args?.filePath ?? output.args?.file_path ?? "")
        if (SECRET_PATH.test(path) && !path.endsWith(".env.example")) {
          throw new Error(
            "Blocked by ai-agent-relay guardrails: secrets or credentials. See .ai/GUARDRAILS.md and request explicit authorization.",
          )
        }
      }
    },
  }
}
