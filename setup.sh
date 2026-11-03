#!/usr/bin/env bash
# أمر واحد للتثبيت الكامل (Mac / Linux):
#   curl -fsSL https://raw.githubusercontent.com/AGOULH/team-claude-kit/main/setup.sh | bash
set -e
TMP="$(mktemp -d)"
echo "تحميل الحزمة..."
curl -fsSL https://codeload.github.com/AGOULH/team-claude-kit/tar.gz/refs/heads/main | tar -xz -C "$TMP"
bash "$TMP/team-claude-kit-main/install.sh"
rm -rf "$TMP"
