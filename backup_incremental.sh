#!/bin/bash

# === Настройки ===
USER="username"
SRC="/$USER/" #Только для пользователя root. Другие пользователи относительно /home
REMOTE_USER="remoteuser"
REMOTE_HOST="remote_server"
REMOTE_BACKUP_DIR="/backups/$USER"
TODAY=$(date +%Y-%m-%d_%H-%M-%S)
LATEST_LINK="$REMOTE_BACKUP_DIR/latest"
NEW_BACKUP="$REMOTE_BACKUP_DIR/$TODAY"

ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $NEW_BACKUP"

rsync -az --delete \
  --link-dest=$LATEST_LINK \
  -e ssh $SRC $REMOTE_USER@$REMOTE_HOST:$NEW_BACKUP

# === Обновление ссылки "latest" на свежий бэкап ===
ssh $REMOTE_USER@$REMOTE_HOST "ln -sfn $NEW_BACKUP $LATEST_LINK"

# === Удаление старых резервных копий (оставляем 5 последних) ===
ssh $REMOTE_USER@$REMOTE_HOST "
  cd $REMOTE_BACKUP_DIR && \
  ls -d 20* | grep -v latest | sort | head -n -5 | xargs -d '\n' rm -rf --
"
