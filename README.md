# حزمة Claude للفريق

إعداد جاهز: سكلات + إعدادات + هوية الوزارة. بدون أي بيانات شخصية.

## التثبيت (أمر واحد — بدون تحميل أي ملف)

**Mac:** افتح Terminal والصق:
```bash
curl -fsSL https://raw.githubusercontent.com/AGOULH/team-claude-kit/main/setup.sh | bash
```

**Windows:** افتح PowerShell والصق:
```powershell
irm https://raw.githubusercontent.com/AGOULH/team-claude-kit/main/setup.ps1 | iex
```

أو من ملف مضغوط: `bash install.sh` (Mac) · `powershell -ExecutionPolicy Bypass -File install.ps1` (Windows)

بعدها: `claude` وسجّل دخولك **بحسابك أنت** (كل شخص حسابه الخاص).

> شبكة الوزارة تحجب الاتصال أحياناً؟ استخدم `claude.ai/code` من المتصفح.

## ماذا يثبّت؟

**سكلات الفريق** (في `~/.claude/skills`):
| السكل | وظيفته |
|---|---|
| `moh-identity` | ألوان وخطوط هوية الوزارة لأي تصميم |
| `app-accounts-permissions` | الحسابات والأدوار والصلاحيات في المواقع |
| `rtl-web-app` | بناء أداة ويب عربية بملف واحد ونشرها |
| `blood-donor-whatsapp` | إرسال رسائل المتبرعين عبر واتساب ويب (يحتاج Claude in Chrome) |

**الإضافات الرسمية:** document-skills (Word/Excel/PowerPoint/PDF)، example-skills، productivity، design، marketing، sales، figma، datarobot.

**الإعدادات العامة:** `~/.claude/CLAUDE.md` — رد بالعربي مختصر، هوية الوزارة، قواعد الأمان. (يُضاف لما عندك ولا يحذفه.)

## الحسابات والصلاحيات (ملخص)

| الدور | يقدر |
|---|---|
| مدير النظام `admin` | كل شيء + إدارة الحسابات |
| مشرف `supervisor` | عرض الكل، تعديل، اعتماد، تقارير |
| موظف `staff` | إضافة وتعديل سجلاته فقط |
| مشاهد `viewer` | عرض فقط |

- الدخول عبر Firebase Authentication، ودور كل مستخدم في `users/{uid}`.
- الحماية الحقيقية في **قواعد Firestore** وليس في إخفاء الأزرار.
- ممنوع وضع كلمات مرور أو PIN داخل الكود.
- **للوصول لمشاريع قائمة:** صاحب المشروع يضيفك عضواً (Firebase Console ← Project settings ← Users and permissions، وGitHub ← Settings ← Collaborators). لا تتشاركوا حساباً واحداً.

## الهوية والخطوط

| | |
|---|---|
| أخضر أساسي | `#168F52` |
| أخضر فاتح | `#5BC49A` |
| ذهبي (تمييز) | `#C9A227` |
| خلفيات | أبيض / تدرجات فاتحة — بدون ألوان داكنة |
| خط عربي | GE SS Two |
| خط لاتيني | Arial |
| بديل مجاني | Tajawal |

**الخطوط:** GE SS Two خط مرخّص فلا يُرفع هنا — ثبّته من حزمة هوية الوزارة (أو ضع ملفاته في `fonts/` عند استخدام الملف المضغوط).

## تحديث لاحقاً
استلم نسخة جديدة من الحزمة وشغّل نفس الأمر — يحتفظ بنسخة احتياطية من القديم (`.bak-التاريخ`).
