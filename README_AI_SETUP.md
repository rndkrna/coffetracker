# ⚡ QUICK START: FIX FITUR AI GEMINI

## 🚨 MASALAH TERIDENTIFIKASI

API Key Gemini Anda **TIDAK VALID**. Karena itu fitur AI tidak berfungsi.

```env
❌ GEMINI_API_KEY="REDACTED_INVALID_GEMINI_KEY"
```

Format yang benar harus dimulai dengan **`AIza`**

---

## ✅ SOLUSI CEPAT (5 MENIT)

### 1️⃣ Dapatkan API Key Baru
Buka: **https://aistudio.google.com/app/apikey**
- Login dengan Google Account
- Klik "Get API Key" atau "Create API Key"
- Copy key yang dihasilkan (format: `AIzaSy...`)

### 2️⃣ Update File .env
Buka file: `c:\Users\renda\ALFIN RIFALDY SIREGAR\New folder\coffee_budget_tracker\.env`

Edit baris ini:
```env
GEMINI_API_KEY="your_gemini_api_key_here"
```

Ganti dengan API key yang baru:
```env
GEMINI_API_KEY="AIzaSy-paste-your-key-here"
```

### 3️⃣ Restart Aplikasi
```bash
flutter run
```
Atau tekan `R` untuk hot restart

### 4️⃣ Test Fitur AI
1. Buka tab **"Cari Kedai"**
2. Tap tombol **"Generate via AI"**
3. Input nama kota: **"Jakarta"**
4. Tap **"Generate"**
5. Tunggu beberapa detik
6. ✅ Data kedai baru muncul!

---

## 📚 DOKUMENTASI LENGKAP

Untuk panduan detail, baca:

1. **FINAL_AI_AUDIT_REPORT.md** - Root cause & fixes
2. **SETUP_GEMINI_AI.md** - Complete setup guide  
3. **TEST_AI_FEATURES.md** - Testing procedures

---

## ✅ VERIFIKASI SUCCESS

Setelah setup, console harus menampilkan:
```
🔑 Gemini API Key status: Found (AIzaSy...)
✅ Gemini model initialized successfully
```

Jika muncul:
```
❌ Gemini API Key tidak valid atau belum diset
```
→ API key masih salah, ulangi step 1-3

---

## 🎯 FITUR AI YANG AKAN BEKERJA

Setelah setup API key:
- ✅ Generate coffee shop by city (via Gemini AI)
- ✅ Auto-create menu items dengan properties lengkap
- ✅ Realistic Indonesian cafe names & prices

Tanpa API key (sudah berfungsi):
- ✅ Guided search (3-step recommendation)
- ✅ AI match score algorithm
- ✅ Simple search (budget + vibe)

---

**Questions?** Lihat troubleshooting di `SETUP_GEMINI_AI.md`

**Last Updated:** 9 Juni 2026
