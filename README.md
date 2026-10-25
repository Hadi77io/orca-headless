# orca-headless

Headless Orca runtime (`orca serve`) packaged for Dokploy.

- Pinned Orca version: 1.4.240 (bump `ARG ORCA_VERSION`)
- AppImage is extracted at build time (no FUSE in containers)
- Runs under Xvfb as uid 1000, data lives in `/home/orca`
- Env: `ORCA_PORT` (default 6768), `ORCA_PAIRING_ADDRESS`, `ORCA_SERVE_EXTRA_ARGS`
