#!/usr/bin/env bash
# Backup the sites database (PostgreSQL).
# Usage:
#   ./scripts/backup-sites-db.sh
#   DB_NAME=myapp ./scripts/backup-sites-db.sh
#
# Optional env vars:
#   DB_NAME     database name (default: sites)
#   DB_USER     user (default: postgres or $USER)
#   DB_HOST     host (default: localhost)
#   PGPASSWORD  password (set if auth required)
#   OUT_DIR     where to write the dump (default: ./backups)

set -euo pipefail

DB_NAME="${DB_NAME:-sites}"
DB_USER="${DB_USER:-postgres}"
DB_HOST="${DB_HOST:-localhost}"
OUT_DIR="${OUT_DIR:-./backups}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DUMP_FILE="${OUT_DIR}/sites-db-${TIMESTAMP}.sql.gz"

mkdir -p "$OUT_DIR"

echo "Backing up database '${DB_NAME}' to ${DUMP_FILE} ..."
pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" | gzip > "$DUMP_FILE"
echo "Done. Size: $(du -h "$DUMP_FILE" | cut -f1)"
