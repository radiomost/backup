#!/bin/bash

# === Настройки ===
USER="your_username"
REMOTE_USER="remoteuser"
REMOTE_HOST="remote_server"
REMOTE_BACKUP_DIR="/backups/$USER"
RESTORE_TO="/$USER"  #Только для пользователя root. Другие пользователи относительно /home

# === Получить список резервных копий ===
echo "Список доступных резервных копий:"
ssh $REMOTE_USER@$REMOTE_HOST "ls -1 $REMOTE_BACKUP_DIR | grep -v latest"

echo
read -p "Введите дату резервной копии для восстановления (например: 2025-07-29_03-00-00): " BACKUP_DATE

BACKUP_PATH="$REMOTE_BACKUP_DIR/$BACKUP_DATE"

# === Создание каталога восстановления ===
mkdir -p "$RESTORE_TO"

# === Восстановление с удалённого сервера ===
rsync -az -e ssh $REMOTE_USER@$REMOTE_HOST:$BACKUP_PATH/ "$RESTORE_TO"

echo "Восстановление завершено в $RESTORE_TO"
