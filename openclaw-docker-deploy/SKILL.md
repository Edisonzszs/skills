---
name: openclaw-docker-deploy
description: Deploy, repair, and operate OpenClaw on Linux cloud servers using Docker/Compose (especially low-memory hosts where npm global install fails). Use when users ask to install OpenClaw in Docker, upgrade to a specific OpenClaw image tag, fix Control UI HTTPS/identity issues, approve paired devices, or run OpenClaw CLI commands inside containers.
---

# OpenClaw Docker Deploy

Use this skill to perform production-style OpenClaw Docker deployment on Linux hosts and to troubleshoot common failures after install.

## Quick Workflow

1. Validate host and Docker.
2. Pull a known OpenClaw image tag.
3. Initialize `/home/node/.openclaw/openclaw.json` via containerized onboarding.
4. Create `docker-compose.yml` with persistent state volume.
5. Start container and validate `18789` health.
6. Fix post-deploy issues (Control UI secure context, pairing, token mismatch, workspace permission).

## Commands and Details

Load [docker-linux.md](references/docker-linux.md) and follow it exactly for:
- First-time deployment
- Redeploy/upgrade to new image tag
- Day-2 operations (logs/restart/plugins/devices)
- Known error playbooks

## One-Command Deploy Script

Use [deploy-openclaw-docker.sh](scripts/deploy-openclaw-docker.sh) when the user wants automated deployment.

Run on target Linux host:

```bash
bash scripts/deploy-openclaw-docker.sh --tag 2026.2.26 --port 18789 --server-ip <server-ip>
bash scripts/deploy-openclaw-docker.sh --latest --port 18789 --server-ip <server-ip>
```

The script automatically:
- Pulls image
- Generates token
- Initializes config
- Writes compose file
- Starts container
- Verifies HTTP health

## Guardrails

- Prefer Docker image deploy over `npm -g openclaw` on small memory servers.
- Persist OpenClaw state to host path (example: `/opt/openclaw-docker/state`).
- Run OpenClaw CLI inside container with `node /app/openclaw.mjs`.
- For interactive commands, always use `docker exec -it`.
- If `gateway.bind=lan`, set Control UI origin policy fields before exposing port publicly.
