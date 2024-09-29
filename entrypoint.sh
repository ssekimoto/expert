# entrypoint.sh
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# データベースが存在しない場合のみマイグレーションを実行
bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
