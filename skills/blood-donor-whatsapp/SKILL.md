---
name: "blood-donor-whatsapp"
description: "When the user says 'تم اضافة قائمة جديدة' or asks to send WhatsApp donor messages, run the full extraction-and-send workflow automatically."
---

# Blood Donor WhatsApp Messenger

Fully automated workflow: extract template + donor list from the website, open WhatsApp Web, send all messages, report results. **No questions asked** — only stop if WhatsApp shows a QR code (not logged in).

## Step 0 — Load Chrome tools

Single ToolSearch call:
```
select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__tabs_close_mcp,mcp__claude-in-chrome__javascript_tool
```

## Step 1 — Extract template and donor list

1. Open a new tab → navigate to `{{DONOR_SITE_URL}}`
2. Wait for page load, then run JS to extract the message template from the textarea:
```js
document.querySelector('textarea').value
```
3. Store the template — replace `{اسم}` with `{N}` as the name placeholder.
4. Extract donor list with JS:
```js
const btns=[...document.querySelectorAll('button')].filter(b=>b.textContent.includes('إرسال رسالة'));
btns.map((b,i)=>{
  const c=b.closest('div').parentElement;
  const L=c.innerText.split('\n').map(s=>s.trim()).filter(Boolean);
  const p=(c.innerText.match(/\+966\d+/)||[''])[0];
  const n=L.find(l=>/[-ۿ]/.test(l)&&l.length>4&&!l.includes('+966')&&!l.includes('إرسال')&&!l.includes('لا ترسل'));
  return i+'|'+n+'|'+p.replace('+','');
});
```
5. Parse results into array of `{name, phone}`. Skip entries with missing phone.

## Step 2 — Open WhatsApp Web

1. In the SAME tab, navigate to `https://web.whatsapp.com`
2. Wait for load. Check page content:
   - If QR code visible → **STOP**, tell user: "واتساب يحتاج تسجيل دخول — امسح QR code وأعطني خبر"
   - If "Use Here" / "استخدم هنا" dialog → click it
   - If chat list visible → proceed
3. Store the template in sessionStorage:
```js
sessionStorage.setItem('BBT', `<full template with {N} placeholder>`);
```

## Step 3 — Send messages

Process **2 donors per `browser_batch`** call (3 causes timeout).

For each donor, the sequence is:
```js
// If name is a placeholder/missing, remove the greeting line entirely
const msg = sessionStorage.getItem('BBT').replace('{N}','DONOR_NAME');
// OR if name looks like a placeholder:
const msg = sessionStorage.getItem('BBT').replace('تحية طيبة {N}','تحية طيبة');

location.href='https://web.whatsapp.com/send?phone=PHONE&text='+encodeURIComponent(msg);
```
Then: `wait 9000ms` → `key Return` → `wait 9000ms`

### Obstacle handling during send:
| Obstacle | Detection | Action |
|----------|-----------|--------|
| "الرقم غير موجود على واتساب" dialog | Page text contains this phrase | Click close/OK button, log as failed, continue |
| Name is placeholder (numbers, empty, or non-Arabic) | Check before send | Use `.replace('تحية طيبة {N}','تحية طيبة')` |
| Timeout / page not loading | No chat input after 15s | Retry once, then log as failed |
| Text appears in input but not sent | Message bubble not created | Press Return again |

## Step 4 — Verify sent messages

After all sends, verify a sample (first, middle, last) by navigating to:
```
https://web.whatsapp.com/send?phone=PHONE
```
(without text) and checking that the sent message bubble is visible.

## Step 5 — Final report

Send a single summary message in Arabic:
```
✅ تم الإرسال
- إجمالي: XX
- نجح: XX  
- فشل: XX

التفاصيل:
✅ اسم المتبرع - 966XXXXXXXXX
❌ اسم الفاشل - 966XXXXXXXXX (السبب)
```

**Do NOT** try to update the website's sent status — the counter will stay at 0; note this in the report if relevant.