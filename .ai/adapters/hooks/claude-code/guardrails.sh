#!/usr/bin/env sh
# Claude Code PreToolUse hook: block destructive commands and secret edits.
#
# Reads the event JSON on stdin, inspects the tool call, and returns a deny
# decision for dangerous patterns. This is enforcement, not advice: the tool
# call is blocked.
#
# Install via .ai/adapters/hooks/claude-code/install.sh, or add manually to
# .claude/settings.json under hooks.PreToolUse with matcher "Bash|Edit|Write".
set -eu

input=$(cat)

deny() {
  reason=$1
  cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"$reason"}}
EOF
  exit 0
}

# Extract the command or file path without jq dependency by simple pattern checks
case "$input" in
  *'"command"'*)
    case "$input" in
      *"rm -rf"*|*"rm -fr"*|*"git push --force"*|*"git push -f"*|\
      *"git reset --hard"*|*"git clean -f"*|*"git clean -x"*|*"git clean -d"*|\
      *"terraform apply"*|*"terraform destroy"*|*"tofu apply"*|*"tofu destroy"*|\
      *"kubectl delete"*|*"kubectl apply"*|*"docker system prune"*|*"docker volume rm"*|\
      *"DROP TABLE"*|*"DROP DATABASE"*|*"TRUNCATE TABLE"*)
        deny "Blocked by ai-agent-relay guardrails: destructive or mutating command. Request explicit authorization."
        ;;
      *"cat .env"*|*"cat ~/.aws/credentials"*|*"cat ~/.ssh/id_"*)
        deny "Blocked by ai-agent-relay guardrails: reading secrets or credentials. Request explicit authorization."
        ;;
    esac
    ;;
esac

case "$input" in
  *'.env"'*|*'secrets'*|*'credentials'*)
    case "$input" in
      *'"file_path"'*|*'"filePath"'*)
        deny "Blocked by ai-agent-relay guardrails: editing secrets or credentials. Request explicit authorization."
        ;;
    esac
    ;;
esac

exit 0
