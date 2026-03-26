# Docker Linux Playbook

## 0. One-Click Script (Recommended)

If you want full automation, run:

```bash
bash scripts/deploy-openclaw-docker.sh --tag 2026.2.26 --port 18789 --server-ip <server-ip>
bash scripts/deploy-openclaw-docker.sh --latest --port 18789 --server-ip <server-ip>
```

Use the manual sections below when you need granular control or troubleshooting.

## 1. Preconditions

```bash
whoami
cat /etc/os-release | sed -n '1,8p'
docker --version
docker compose version
systemctl is-active docker
```

Expected:
- Docker service `active`
- Compose v2 available

## 2. Deploy Directory and Image Pull

```bash
sudo mkdir -p /opt/openclaw-docker/state
sudo chown -R 1000:1000 /opt/openclaw-docker/state

# Example tag (replace as needed)
sudo docker pull ghcr.io/openclaw/openclaw:2026.2.26
```

## 3. Initialize OpenClaw Config in Container

Generate a gateway token and run non-interactive onboarding into persistent state path.

```bash
TOKEN="$(openssl rand -hex 32)"
echo "$TOKEN" | sudo tee /opt/openclaw-docker/gateway.token >/dev/null
sudo chmod 600 /opt/openclaw-docker/gateway.token

sudo docker run --rm -u node \
  -v /opt/openclaw-docker/state:/home/node/.openclaw \
  ghcr.io/openclaw/openclaw:2026.2.26 \
  node /app/openclaw.mjs onboard \
    --non-interactive --accept-risk \
    --flow quickstart --mode local \
    --auth-choice skip \
    --gateway-port 18789 \
    --gateway-bind lan \
    --gateway-auth token \
    --gateway-token "$TOKEN" \
    --skip-channels --skip-skills --skip-ui --no-install-daemon
```

## 4. Compose File

Create `/opt/openclaw-docker/docker-compose.yml`:

```yaml
services:
  openclaw:
    image: ghcr.io/openclaw/openclaw:2026.2.26
    container_name: openclaw
    restart: unless-stopped
    user: '1000:1000'
    ports:
      - '18789:18789'
    volumes:
      - /opt/openclaw-docker/state:/home/node/.openclaw
    command:
      - node
      - /app/openclaw.mjs
      - gateway
      - --allow-unconfigured
      - --port
      - '18789'
```

Start:

```bash
cd /opt/openclaw-docker
sudo docker compose up -d
sudo docker compose ps
```

## 5. Required Control UI Policy (for bind=lan)

OpenClaw versions with strict non-loopback policy require explicit Control UI settings.

Edit `/opt/openclaw-docker/state/openclaw.json` under `gateway.controlUi`:

```json
{
  "allowedOrigins": [
    "http://106.14.220.128:18789",
    "http://127.0.0.1:18789",
    "http://localhost:18789"
  ],
  "dangerouslyAllowHostHeaderOriginFallback": true,
  "allowInsecureAuth": true
}
```

Then restart:

```bash
cd /opt/openclaw-docker
sudo docker compose restart openclaw
```

## 6. Health Checks

```bash
curl -I --max-time 10 http://127.0.0.1:18789/
curl -I --max-time 10 http://<server-ip>:18789/
sudo docker compose logs --tail 120 openclaw
```

Success indicators:
- HTTP 200
- Log contains `listening on ws://0.0.0.0:18789`

## 7. Localhost Tunnel Access (avoid secure-context issues)

Run on local Windows terminal (not on server):

```powershell
ssh -i "C:\path\to\key.pem" -L 18789:127.0.0.1:18789 root@<server-ip>
```

Open browser:
- `http://127.0.0.1:18789`

## 8. Operations

Restart:

```bash
cd /opt/openclaw-docker
sudo docker compose restart openclaw
```

Logs:

```bash
cd /opt/openclaw-docker
sudo docker compose logs -f openclaw
```

Upgrade image tag:

```bash
cd /opt/openclaw-docker
sudo sed -i 's#ghcr.io/openclaw/openclaw:.*#ghcr.io/openclaw/openclaw:2026.2.26#' docker-compose.yml
sudo docker compose pull
sudo docker compose up -d
```

## 9. Run OpenClaw CLI in Docker

Base pattern:

```bash
sudo docker exec -u node openclaw node /app/openclaw.mjs <subcommand>
```

Interactive wizard:

```bash
sudo docker exec -it -u node openclaw node /app/openclaw.mjs config
```

Examples:

```bash
sudo docker exec -u node openclaw node /app/openclaw.mjs devices list
sudo docker exec -u node openclaw node /app/openclaw.mjs plugins list
```

## 10. Common Failures

### A) `openclaw: command not found` on host
Cause: Docker deployment has no host binary.
Fix: Use `docker exec ... node /app/openclaw.mjs`.

### B) `control ui requires HTTPS or localhost secure context`
Fix: access via SSH tunnel and `http://127.0.0.1:18789`, or keep insecure auth override enabled for HTTP token-only mode.

### C) `pairing required`
Approve request:

```bash
sudo docker exec -u node openclaw node /app/openclaw.mjs devices list
sudo docker exec -u node openclaw node /app/openclaw.mjs devices approve <requestId>
```

### D) `EACCES ... mkdir '/home/<user>'`
Cause: `agents.defaults.workspace` points to non-container path.
Fix: set to `/home/node/.openclaw/workspace` in persisted `openclaw.json`, then restart container.

### E) Token mismatch in UI
Paste current token from:

```bash
sudo cat /opt/openclaw-docker/gateway.token
```

### F) SSH host key changed after server rebuild
Run on local machine:

```bash
ssh-keygen -R <server-ip>
```
