---
name: app-accounts-permissions
description: Add user accounts, roles and permissions to an Arabic web app (login, admin/staff roles, per-page and per-action access, Firebase rules). Use when building or changing who can see or do what in a site.
---

# الحسابات والصلاحيات في المواقع

النمط الموحّد لكل مواقع الفريق: كل مستخدم له **حساب** و**دور**، وكل دور له **صلاحيات** محددة.

## 1) الأدوار الافتراضية

| الدور | المفتاح | الصلاحيات |
|---|---|---|
| مدير النظام | `admin` | كل شيء + إدارة الحسابات والأدوار + الإعدادات |
| مشرف | `supervisor` | عرض الكل، اعتماد، تقارير، تعديل بيانات القسم |
| موظف | `staff` | إضافة وتعديل سجلاته فقط، عرض ما يخصه |
| مشاهد | `viewer` | عرض فقط بدون تعديل |

اسأل المستخدم عن الأدوار الخاصة بالموقع (مثل: استقبال، مطبخ، مستودع) وأضفها بنفس الجدول.

## 2) الصلاحيات كقائمة مفاتيح
```js
const PERMISSIONS = {
  admin:      ['*'],
  supervisor: ['view_all','edit_all','approve','export','reports'],
  staff:      ['view_own','create','edit_own'],
  viewer:     ['view_all']
};
const can = (user, perm) =>
  user && (PERMISSIONS[user.role]||[]).some(p => p==='*' || p===perm);
```
- أخفِ الأزرار والصفحات حسب `can()` في الواجهة.
- **ولكن** التحقق الحقيقي يكون في قواعد قاعدة البيانات (الخطوة 4)، لأن إخفاء الزر وحده لا يحمي البيانات.

## 3) تسجيل الدخول
- الأفضل: **Firebase Authentication** (بريد + كلمة مرور، أو رقم وظيفي يتحول لبريد داخلي).
- وثيقة لكل مستخدم في `users/{uid}`:
```json
{ "name": "...", "role": "staff", "dept": "...", "active": true, "createdAt": "..." }
```
- شاشة "إدارة الحسابات" للمدير فقط: إضافة، تعطيل، تغيير الدور، إعادة تعيين كلمة المرور.
- سجل عمليات `logs/` (من غيّر ماذا ومتى) للعمليات الحساسة.

## 4) قواعد Firestore (الحماية الفعلية)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    function signedIn() { return request.auth != null; }
    function role() { return get(/databases/$(db)/documents/users/$(request.auth.uid)).data.role; }
    function isAdmin() { return signedIn() && role() == 'admin'; }
    function isSup()   { return signedIn() && role() in ['admin','supervisor']; }

    match /users/{uid} {
      allow read:  if signedIn() && (request.auth.uid == uid || isSup());
      allow write: if isAdmin();
    }
    match /records/{id} {
      allow read:   if signedIn();
      allow create: if signedIn() && request.resource.data.owner == request.auth.uid;
      allow update: if isSup() || resource.data.owner == request.auth.uid;
      allow delete: if isAdmin();
    }
  }
}
```

## 5) قواعد مهمة
- **لا** تكتب كلمات مرور أو أرقام PIN داخل كود HTML/JS (أي أحد يقدر يقرأها من المتصفح).
- إذا لزم PIN بسيط: خزّنه مُشفّراً (SHA-256) في قاعدة البيانات وتحقق منه هناك.
- مفاتيح Firebase في الواجهة طبيعية، لكن الحماية تأتي من القواعد أعلاه.
- البيانات الحساسة للوزارة (بيانات متبرعين/مرضى) تكون على خادم داخلي، لا على خدمات عامة.
- كل واجهة عربية RTL، بهوية الوزارة (سكل `moh-identity`).
