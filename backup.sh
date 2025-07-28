#!/bin/bash

SRC="/root/"
DEST="/tmp/backup"

rsync -av --delete "$SRC" "$DEST"

if [ $? -eq 0 ]; then
    logger "Backup successful: содержимое $SRC скопировано в $DEST"
else
    logger "Backup failed: ошибка при копировании $SRC в $DEST"
fi