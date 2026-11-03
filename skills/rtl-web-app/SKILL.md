---
name: rtl-web-app
description: Build or edit a single-file Arabic RTL HTML web app (GitHub Pages hosting, optional Firebase backend, Excel import/export, PWA). Use when asked to make a tool, page or system for the team.
---

# تطبيق ويب عربي بملف واحد

## البنية
- ملف واحد `index.html` (HTML + CSS + JS) — سهل النشر على GitHub Pages.
- `<html lang="ar" dir="rtl">` دائماً.
- الهوية من سكل `moh-identity`، والحسابات من سكل `app-accounts-permissions`.
- التاريخ: عرض هجري + ميلادي عند الحاجة (`Intl.DateTimeFormat('ar-SA-u-ca-islamic')`).

## المكتبات (CDN بإصدار محدد)
- Excel: SheetJS `https://cdn.sheetjs.com/xlsx-0.20.3/package/dist/xlsx.full.min.js`
- رسوم: Chart.js `https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js`
- Firebase: `https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js` (+ auth/firestore)

## قبل البدء اسأل
1. من سيستخدم الأداة وما الأدوار؟
2. هل البيانات حساسة؟ (حساسة ← خادم داخلي، غير حساسة ← Firebase)
3. هل يوجد ملف Excel مصدر؟

## النشر على GitHub Pages
```bash
git init && git add . && git commit -m "first version"
gh repo create <اسم-المشروع> --public --source=. --push
gh api -X POST repos/{owner}/<اسم-المشروع>/pages -f "source[branch]=main" -f "source[path]=/"
```

## عادات عمل
- ملف `CLAUDE.md` داخل كل مشروع يحتوي: الهدف، الرابط، مشروع Firebase، الأدوار، آخر التعديلات.
- جلسات قصيرة لكل مهمة لتوفير الاستهلاك.
- اختبر على الجوال (عرض 375px) قبل التسليم.
