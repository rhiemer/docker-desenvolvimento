#!/bin/bash
set -o errexit

SHARE_APPS="/usr/share/applications"

FILE_NAME_DESKTOP="google-chrome.desktop"

PARAM_1="${1}"
DESKTOP_DEFAULT="/headless/Desktop"
DESKTOP="${PARAM_1:-$DESKTOP_DEFAULT}"

FILE_DESKTOP="$DESKTOP/$FILE_NAME_DESKTOP"
FILE_SHARE_APPS="$SHARE_APPS/$FILE_NAME_DESKTOP"

#cria atalho no desktop
ln -sfv "$FILE_SHARE_APPS" "$FILE_DESKTOP"
chmod +x "$FILE_DESKTOP"

FILE_EXEC="/usr/bin/google-chrome-stable"

#configura o chrome para rodar como root.
sed -i.bak "s#Exec=$FILE_EXEC#Exec=$FILE_EXEC --user-data-dir --no-sandbox #g" "$FILE_SHARE_APPS"
cat $FILE_SHARE_APPS

