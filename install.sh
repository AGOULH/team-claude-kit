#!/usr/bin/env bash
# تثبيت حزمة الفريق لـ Claude Code — Mac / Linux
# الاستخدام:  bash install.sh
set -u
KIT="$(cd "$(dirname "$0")" && pwd)"
CL="$HOME/.claude"
ok(){ printf "\033[32m✔\033[0m %s\n" "$1"; }
warn(){ printf "\033[33m!\033[0m %s\n" "$1"; }

echo "== تثبيت حزمة الفريق =="

# 1) Claude Code
if ! command -v claude >/dev/null 2>&1; then
  echo "تثبيت Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || warn "فشل التثبيت التلقائي — جرّب: npm install -g @anthropic-ai/claude-code"
  export PATH="$HOME/.local/bin:$PATH"
fi
command -v claude >/dev/null 2>&1 && ok "Claude Code: $(claude --version 2>/dev/null)"

# 2) السكلات
mkdir -p "$CL/skills"
STAMP=$(date +%Y%m%d-%H%M%S)
for d in "$KIT"/skills/*/; do
  n=$(basename "$d")
  [ -d "$CL/skills/$n" ] && mv "$CL/skills/$n" "$CL/skills/$n.bak-$STAMP"
  cp -R "$d" "$CL/skills/$n"
  ok "سكل: $n"
done

# رابط صفحة المتبرعين (اختياري)
if [ -f "$CL/skills/blood-donor-whatsapp/SKILL.md" ]; then
  URL=""
  if [ -n "${DONOR_URL:-}" ]; then URL="$DONOR_URL"
  elif (: < /dev/tty) 2>/dev/null; then read -r -p "رابط صفحة رسائل المتبرعين (Enter للتخطي): " URL < /dev/tty || true; fi
  if [ -n "${URL:-}" ]; then
    URL="$URL" perl -pi -e 's/\{\{DONOR_SITE_URL\}\}/$ENV{URL}/g' "$CL/skills/blood-donor-whatsapp/SKILL.md" \
      && ok "تم ضبط الرابط" || warn "تعذّر ضبط الرابط"
  else
    warn "لم يُضبط الرابط — عدّله لاحقاً في $CL/skills/blood-donor-whatsapp/SKILL.md"
  fi
fi

# 3) CLAUDE.md العام (بدون حذف ما عند الزميل)
touch "$CL/CLAUDE.md"
if grep -q "team-claude-kit:start" "$CL/CLAUDE.md"; then
  sed -i.tmp '/team-claude-kit:start/,/team-claude-kit:end/d' "$CL/CLAUDE.md" && rm -f "$CL/CLAUDE.md.tmp"
fi
printf "\n" >> "$CL/CLAUDE.md"; cat "$KIT/claude/CLAUDE.md" >> "$CL/CLAUDE.md"
ok "إعدادات CLAUDE.md"

# 4) الإضافات الرسمية (plugins)
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add anthropics/skills >/dev/null 2>&1
  claude plugin marketplace add anthropics/knowledge-work-plugins >/dev/null 2>&1
  for p in document-skills@anthropic-agent-skills example-skills@anthropic-agent-skills \
           productivity@knowledge-work-plugins design@knowledge-work-plugins \
           marketing@knowledge-work-plugins sales@knowledge-work-plugins \
           figma@knowledge-work-plugins datarobot-agent-skills@knowledge-work-plugins; do
    if claude plugin install "$p" >/dev/null 2>&1; then ok "إضافة: ${p%@*}"; else warn "تعذّرت: ${p%@*} (ثبّتها من /plugin داخل Claude)"; fi
  done
fi

# 5) الخطوط (إن وُجدت في مجلد fonts)
shopt -s nullglob; F=("$KIT"/fonts/*.{ttf,otf,TTF,OTF})
if [ ${#F[@]} -gt 0 ]; then
  if [ "$(uname)" = "Darwin" ]; then FD="$HOME/Library/Fonts"; else FD="$HOME/.local/share/fonts"; fi
  mkdir -p "$FD"; cp "${F[@]}" "$FD/"; command -v fc-cache >/dev/null && fc-cache -f >/dev/null
  ok "الخطوط: ${#F[@]} ملف"
else
  warn "خط GE SS Two غير مضمّن (مرخّص) — ثبّته من حزمة هوية الوزارة"
fi

echo; ok "تم. شغّل:  claude   ثم سجّل دخولك بحسابك."
