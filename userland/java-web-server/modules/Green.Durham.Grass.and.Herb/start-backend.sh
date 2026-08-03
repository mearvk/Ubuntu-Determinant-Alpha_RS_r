#!/bin/bash
# Green.Durham.Grass.and.Herb™ — Start Backend
cd "$(dirname "$0")" || exit 1
echo "[*] Green.Durham.Grass.and.Herb™ — Starting backend..."
bash servlets/setup-db.sh 2>/dev/null || echo "[WARN] DB setup skipped."
echo "[OK] Green.Durham.Grass.and.Herb™ backend ready."
