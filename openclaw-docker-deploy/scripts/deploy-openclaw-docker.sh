#!/usr/bin/env bash
set -euo pipefail

TAG="2026.2.26"
USE_LATEST="false"
PORT="18789"
DEPLOY_DIR="/opt/openclaw-docker"
SERVER_IP=""
BIND_MODE="lan"
ALLOW_INSECURE_AUTH="true"
IMAGE_REPO="ghcr.io/openclaw/openclaw"

usage() {
  cat <<'EOF'
One-click OpenClaw Docker deployment for Linux cloud hosts.

Usage:
  deploy-openclaw-docker.sh [options]

Options:
  --tag <tag>                OpenClaw image tag (default: 2026.2.26)
  --latest                   Resolve and use newest stable OpenClaw version (npm) as image tag
  --port <port>              Gateway port (default: 18789)
  --dir <path>               Deployment directory (default: /opt/openclaw-docker)
  --server-ip <ip-or-host>   Public server IP/hostname for Control UI allowedOrigins
  --bind <mode>              Gateway bind mode: lan|loopback (default: lan)
  --allow-insecure-auth      Enable Control UI insecure auth (HTTP token mode)
  --no-allow-insecure-auth   Disable insecure auth
  -h, --help                 Show this help

Examples:
  bash deploy-openclaw-docker.sh
  bash deploy-openclaw-docker.sh --tag 2026.2.26 --port 18789 --server-ip 106.14.220.128
EOF
}

log() {
  printf '[deploy] %s\n' "$*"
}

die() {
  printf '[deploy][error] %s\n' "$*" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      TAG="${2:-}"; shift 2 ;;
    --latest)
      USE_LATEST="true"; shift ;;
    --port)
      PORT="${2:-}"; shift 2 ;;
    --dir)
      DEPLOY_DIR="${2:-}"; shift 2 ;;
    --server-ip)
      SERVER_IP="${2:-}"; shift 2 ;;
    --bind)
      BIND_MODE="${2:-}"; shift 2 ;;
    --allow-insecure-auth)
      ALLOW_INSECURE_AUTH="true"; shift ;;
    --no-allow-insecure-auth)
      ALLOW_INSECURE_AUTH="false"; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      die "Unknown option: $1" ;;
  esac
done

[[ "$BIND_MODE" == "lan" || "$BIND_MODE" == "loopback" ]] || die "--bind must be lan or loopback"
[[ "$PORT" =~ ^[0-9]+$ ]] || die "--port must be numeric"

if [[ -z "$SERVER_IP" ]]; then
  SERVER_IP="$(curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null || true)"
fi
if [[ -z "$SERVER_IP" ]]; then
  SERVER_IP="$(hostname -I 2>/dev/null | awk '{print $1}' || true)"
fi
[[ -n "$SERVER_IP" ]] || die "Cannot determine server IP automatically; pass --server-ip"

command -v docker >/dev/null 2>&1 || die "docker not found"
docker compose version >/dev/null 2>&1 || die "docker compose v2 not found"
command -v python3 >/dev/null 2>&1 || die "python3 not found"
command -v curl >/dev/null 2>&1 || die "curl not found"

if ! systemctl is-active docker >/dev/null 2>&1; then
  die "docker service is not active"
fi

STATE_DIR="${DEPLOY_DIR}/state"
COMPOSE_FILE="${DEPLOY_DIR}/docker-compose.yml"
TOKEN_FILE="${DEPLOY_DIR}/gateway.token"

resolve_latest_tag() {
  local latest_json
  latest_json="$(curl -fsSL "https://registry.npmjs.org/openclaw/latest")" || return 1
  python3 - "$latest_json" <<'PY'
import json
import re
import sys
payload = json.loads(sys.argv[1])
version = payload.get("version", "")
if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit(1)
print(version)
PY
}

if [[ "$USE_LATEST" == "true" ]]; then
  log "Resolving latest stable version from npm registry"
  TAG="$(resolve_latest_tag)" || die "Failed to resolve latest tag from npm registry"
  [[ -n "$TAG" ]] || die "Latest tag resolution returned empty"
fi

IMAGE="${IMAGE_REPO}:${TAG}"

if ! docker manifest inspect "$IMAGE" >/dev/null 2>&1; then
  die "Resolved tag ${TAG} has no corresponding image: ${IMAGE}"
fi

log "Preparing directories"
mkdir -p "$STATE_DIR"
chown -R 1000:1000 "$STATE_DIR"

log "Pulling image ${IMAGE}"
docker pull "$IMAGE"

TOKEN="$(openssl rand -hex 32)"
printf '%s\n' "$TOKEN" > "$TOKEN_FILE"
chmod 600 "$TOKEN_FILE"

log "Running non-interactive onboard"
docker run --rm -u node \
  -v "${STATE_DIR}:/home/node/.openclaw" \
  "$IMAGE" \
  node /app/openclaw.mjs onboard \
    --non-interactive --accept-risk \
    --flow quickstart --mode local \
    --auth-choice skip \
    --gateway-port "$PORT" \
    --gateway-bind "$BIND_MODE" \
    --gateway-auth token \
    --gateway-token "$TOKEN" \
    --skip-channels --skip-skills --skip-ui --skip-health --no-install-daemon

log "Patching config for docker runtime"
python3 - "$STATE_DIR/openclaw.json" "$SERVER_IP" "$PORT" "$ALLOW_INSECURE_AUTH" <<'PY'
import json
import sys
cfg_path, server_ip, port, allow_insecure = sys.argv[1:]
with open(cfg_path, "r", encoding="utf-8") as f:
    cfg = json.load(f)

cfg.setdefault("agents", {}).setdefault("defaults", {})["workspace"] = "/home/node/.openclaw/workspace"
gateway = cfg.setdefault("gateway", {})
gateway["port"] = int(port)
gateway.setdefault("auth", {})["mode"] = "token"
control_ui = gateway.setdefault("controlUi", {})
control_ui["allowedOrigins"] = [
    f"http://{server_ip}:{port}",
    f"http://127.0.0.1:{port}",
    f"http://localhost:{port}",
]
control_ui["dangerouslyAllowHostHeaderOriginFallback"] = True
control_ui["allowInsecureAuth"] = (allow_insecure.lower() == "true")

with open(cfg_path, "w", encoding="utf-8") as f:
    json.dump(cfg, f, ensure_ascii=False, indent=2)
PY

log "Writing docker-compose.yml"
cat > "$COMPOSE_FILE" <<YAML
services:
  openclaw:
    image: ${IMAGE}
    container_name: openclaw
    restart: unless-stopped
    user: '1000:1000'
    ports:
      - '${PORT}:${PORT}'
    volumes:
      - ${STATE_DIR}:/home/node/.openclaw
    command:
      - node
      - /app/openclaw.mjs
      - gateway
      - --allow-unconfigured
      - --port
      - '${PORT}'
YAML

mkdir -p "${STATE_DIR}/workspace"
chown -R 1000:1000 "$STATE_DIR"

log "Starting compose service"
(
  cd "$DEPLOY_DIR"
  docker compose up -d
)

log "Waiting for health check on http://127.0.0.1:${PORT}/"
ok="false"
for _ in {1..30}; do
  if curl -fsS -o /dev/null "http://127.0.0.1:${PORT}/"; then
    ok="true"
    break
  fi
  sleep 1
done
[[ "$ok" == "true" ]] || die "Gateway health check failed"

cat <<EOF

OpenClaw Docker deploy completed.

Image:          ${IMAGE}
Deploy dir:     ${DEPLOY_DIR}
Gateway URL:    ws://${SERVER_IP}:${PORT}
UI URL:         http://${SERVER_IP}:${PORT}
Token file:     ${TOKEN_FILE}

Quick checks:
  cd ${DEPLOY_DIR} && docker compose ps
  cd ${DEPLOY_DIR} && docker compose logs -f openclaw
EOF
