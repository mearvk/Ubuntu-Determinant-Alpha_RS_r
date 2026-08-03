#!/bin/bash
# Green.Durham.Grass.and.Herb™ — Start Frontend (deploy webapp)
cd "$(dirname "$0")" || exit 1
bash servlets/deploy-local.sh "$@"
echo "[OK] Green.Durham.Grass.and.Herb™ frontend started."
