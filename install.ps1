# تثبيت حزمة الفريق لـ Claude Code — Windows
# الاستخدام:  powershell -ExecutionPolicy Bypass -File install.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = 'Continue'
$KIT = Split-Path -Parent $MyInvocation.MyCommand.Path
$CL  = Join-Path $HOME '.claude'
function Ok($m){ Write-Host "✔ $m" -ForegroundColor Green }
function Warn($m){ Write-Host "! $m" -ForegroundColor Yellow }

Write-Host "== تثبيت حزمة الفريق =="

# 1) Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Host "تثبيت Claude Code..."
  try { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression } catch { Warn "فشل التثبيت — جرّب: npm install -g @anthropic-ai/claude-code" }
  $env:Path += ";$HOME\.local\bin"
}
if (Get-Command claude -ErrorAction SilentlyContinue) { Ok "Claude Code: $(claude --version)" }

# 2) السكلات
$SK = Join-Path $CL 'skills'; New-Item -ItemType Directory -Force -Path $SK | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
Get-ChildItem (Join-Path $KIT 'skills') -Directory | ForEach-Object {
  $dst = Join-Path $SK $_.Name
  if (Test-Path $dst) { Rename-Item $dst "$($_.Name).bak-$stamp" }
  Copy-Item $_.FullName $dst -Recurse
  Ok "سكل: $($_.Name)"
}

$wa = Join-Path $SK 'blood-donor-whatsapp\SKILL.md'
if (Test-Path $wa) {
  $url = Read-Host "رابط صفحة رسائل المتبرعين (Enter للتخطي)"
  if ($url) {
    $t = [IO.File]::ReadAllText($wa, [Text.Encoding]::UTF8).Replace('{{DONOR_SITE_URL}}', $url)
    [IO.File]::WriteAllText($wa, $t, (New-Object Text.UTF8Encoding $false)); Ok "تم ضبط الرابط"
  } else { Warn "لم يُضبط الرابط — عدّله لاحقاً في $wa" }
}

# 3) CLAUDE.md العام
$md = Join-Path $CL 'CLAUDE.md'
$old = if (Test-Path $md) { [IO.File]::ReadAllText($md, [Text.Encoding]::UTF8) } else { '' }
$old = [regex]::Replace($old, '(?s)<!-- team-claude-kit:start -->.*?<!-- team-claude-kit:end -->\r?\n?', '')
$new = [IO.File]::ReadAllText((Join-Path $KIT 'claude\CLAUDE.md'), [Text.Encoding]::UTF8)
[IO.File]::WriteAllText($md, ($old.TrimEnd() + "`n`n" + $new), (New-Object Text.UTF8Encoding $false))
Ok "إعدادات CLAUDE.md"

# 4) الإضافات الرسمية
if (Get-Command claude -ErrorAction SilentlyContinue) {
  claude plugin marketplace add anthropics/skills *> $null
  claude plugin marketplace add anthropics/knowledge-work-plugins *> $null
  $plugins = 'document-skills@anthropic-agent-skills','example-skills@anthropic-agent-skills',
             'productivity@knowledge-work-plugins','design@knowledge-work-plugins',
             'marketing@knowledge-work-plugins','sales@knowledge-work-plugins',
             'figma@knowledge-work-plugins','datarobot-agent-skills@knowledge-work-plugins'
  foreach ($p in $plugins) {
    claude plugin install $p *> $null
    if ($LASTEXITCODE -eq 0) { Ok "إضافة: $($p.Split('@')[0])" } else { Warn "تعذّرت: $($p.Split('@')[0]) (ثبّتها من /plugin داخل Claude)" }
  }
}

# 5) الخطوط (للمستخدم الحالي بدون صلاحية مدير)
$fonts = Get-ChildItem (Join-Path $KIT 'fonts') -Include *.ttf,*.otf -Recurse -ErrorAction SilentlyContinue
if ($fonts) {
  $FD = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"; New-Item -ItemType Directory -Force -Path $FD | Out-Null
  foreach ($f in $fonts) {
    Copy-Item $f.FullName $FD -Force
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -Name "$($f.BaseName) (TrueType)" -Value (Join-Path $FD $f.Name) -Force | Out-Null
  }
  Ok "الخطوط: $($fonts.Count) ملف"
} else { Warn "لا توجد خطوط في fonts\ — ضع ملفات GE SS Two هناك وأعد التشغيل" }

Write-Host ""; Ok "تم. شغّل:  claude   ثم سجّل دخولك بحسابك."
