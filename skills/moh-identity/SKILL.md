---
name: moh-identity
description: Apply the Saudi Ministry of Health visual identity (colors + Arabic fonts) to any slide, dashboard, document, web page or report. Use for every design or UI task.
---

# هوية وزارة الصحة — الألوان والخطوط

طبّق هذه الهوية تلقائياً في أي عرض، لوحة بيانات، مستند، صفحة ويب أو تقرير.

## الألوان

| الاستخدام | اللون | HEX |
|---|---|---|
| الأساسي (عناوين، أزرار، شريط علوي) | أخضر الوزارة | `#168F52` |
| مُساند (أيقونات، رسوم، حدود) | أخضر فاتح | `#5BC49A` |
| تمييز (أرقام مهمة، شارات، خط فاصل) | ذهبي | `#C9A227` |
| خلفية بطاقات | أخضر باهت | `#EAF6F0` |
| خلفية تمييز | ذهبي باهت | `#FBF5E3` |
| الخلفية العامة | أبيض | `#FFFFFF` |
| النص الأساسي | رمادي غامق | `#1F2A24` |
| النص الثانوي | رمادي | `#5B6B63` |

### قواعد صارمة
- الخلفيات دائماً بيضاء أو فاتحة. **ممنوع** الخلفيات الداكنة أو الكتل اللونية الداكنة.
- الذهبي للتمييز فقط (لا يُستخدم كخلفية كبيرة).
- الرسوم البيانية: ابدأ بـ `#168F52` ثم `#5BC49A` ثم `#C9A227` ثم درجات فاتحة منها.

## الخطوط

- العربي: **GE SS Two** (الخط الرسمي للوزارة).
- اللاتيني فقط (أرقام إنجليزية، رموز): **Arial**.
- البديل المجاني إذا الخط غير مثبت: **Tajawal** (Google Fonts).

### CSS جاهز
```css
:root{
  --moh-green:#168F52; --moh-green-soft:#5BC49A; --moh-gold:#C9A227;
  --moh-tint-green:#EAF6F0; --moh-tint-gold:#FBF5E3;
  --text:#1F2A24; --text-2:#5B6B63; --bg:#FFFFFF;
}
body{
  direction:rtl; background:var(--bg); color:var(--text);
  font-family:"GE SS Two","Tajawal",Arial,sans-serif;
}
```
وأضف في `<head>` للبديل:
```html
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
```

### PowerPoint / Word / Excel
- خط العناوين والنص العربي: `GE SS Two`، والنص اللاتيني: `Arial`.
- لون العناوين `#168F52`، الخط الفاصل ذهبي `#C9A227`، الخلفية بيضاء.
