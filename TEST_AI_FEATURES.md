# 🧪 MANUAL TESTING: FITUR AI GEMINI

## 📋 CHECKLIST PRE-TESTING

Sebelum mulai testing, pastikan:

### 1. API Key Sudah Valid ✅
```bash
# Buka file .env dan verifikasi:
GEMINI_API_KEY="AIzaSy..." ← Harus dimulai dengan "AIza"
```

**Cara Cek:**
- [ ] Buka file `.env` di root project
- [ ] Lihat baris `GEMINI_API_KEY=`
- [ ] Pastikan value-nya dimulai dengan `AIza` dan panjang ~39 karakter
- [ ] Pastikan tidak ada quotes ganda atau spasi ekstra

### 2. Environment Sudah Di-Load ✅
```bash
# Restart aplikasi setelah edit .env
flutter run
# atau hot restart (R)
```

### 3. Internet Connection Active ✅
- [ ] WiFi atau data seluler ON
- [ ] Bisa akses https://aistudio.google.com

### 4. Check Console Log ✅
Saat app start, harus muncul di console:
```
🔑 Gemini API Key status: Found (AIzaSy...)
✅ Gemini model initialized successfully
```

Jika muncul:
```
❌ Gemini API Key tidak valid atau belum diset
```
→ **STOP! Fix API key dulu sebelum lanjut**

---

## 🎯 TEST SCENARIO 1: GENERATE COFFEE SHOP DATA

### Objektif
Verify bahwa Gemini AI bisa generate data coffee shop baru dari nama kota.

### Steps to Test

#### 1. Launch App
```
flutter run
```

#### 2. Login ke Aplikasi
- Email: test@example.com (atau buat account baru)
- Password: password123

#### 3. Navigate ke Tab "Cari Kedai"
- Tap tab ke-3 di bottom navigation (icon location/map)
- Anda sekarang di **CoffeeshopFinderScreen**

#### 4. Verify Seed Data Muncul
**Expected:**
- Muncul 3 kedai seed data:
  1. Samanko Coffee Roasters
  2. Satu Rasi Coffee & Space  
  3. Warkop Kunokini

**Jika kosong:**
- Go to tab "Rekomendasi"
- Data akan di-seed otomatis

#### 5. Tap "Generate via AI" Button
- Floating Action Button di kanan bawah
- Warna coklat dengan icon ✨

#### 6. Input Kota
Dialog muncul dengan TextField.

**Test Case 6a: Kota Besar**
- Input: `Jakarta`
- Tap "Generate"
- **Expected:**
  - Loading indicator muncul
  - Console log:
    ```
    🤖 Starting Gemini generation for location: Jakarta
    📤 Sending request to Gemini...
    📥 Received response from Gemini
    ✅ JSON parsed successfully, 3-5 shops found
    🎉 Successfully generated X coffee shops
    ```
  - Dialog close
  - SnackBar: "Data kedai berhasil di-generate AI!"
  - List refresh dan menampilkan 6-8 kedai (3 seed + 3-5 new)

**Test Case 6b: Kota Kecil**
- Input: `Tanjung Pinang`
- Tap "Generate"
- **Expected:** Sama seperti 6a

**Test Case 6c: Kota dengan Spasi**
- Input: `Bandung Barat`
- Tap "Generate"
- **Expected:** Sama seperti 6a

**Test Case 6d: Input Kosong**
- Input: ` ` (empty/space)
- Tap "Generate"
- **Expected:** 
  - Tidak ada loading
  - Atau error handling (tergantung implementasi)

**Test Case 6e: Multiple Generation**
- Generate "Jakarta"
- Wait sampai selesai
- Generate "Surabaya"
- **Expected:** Total kedai sekarang 9-13 (3 seed + 3-5 Jakarta + 3-5 Surabaya)

#### 7. Verify Data di List
Setiap coffee shop card harus menampilkan:
- [ ] Nama kedai (dari Gemini)
- [ ] Rating (4.0-5.0)
- [ ] Jarak (placeholder: 1500m)
- [ ] Price range (min-max dari menu)
- [ ] Status buka (placeholder: "Buka")
- [ ] Mood tags (vibes dari Gemini)
- [ ] Facilities (WiFi, Stopkontak)

#### 8. Tap Coffee Shop Card
- Tap salah satu kedai hasil generate
- **Expected:**
  - Navigate ke DetailCoffeeshopScreen
  - Tampil detail kedai

---

## 🎯 TEST SCENARIO 2: GUIDED SEARCH (AI RECOMMENDATION)

### Objektif
Verify bahwa AI matching algorithm memberikan rekomendasi menu berdasarkan preferensi user.

### Steps to Test

#### 1. Navigate ke Tab "Rekomendasi"
- Tap tab ke-4 di bottom navigation (icon auto_awesome)

#### 2. Tap "Cari Menu Sendiri"
- Card kedua dari atas
- Navigate ke GuidedSearchScreen

#### 3. Step 1 - Dasar

**Input:**
- Jenis Minuman: **Coffee**
- Rasa Dominan: **Chocolate**
- Suhu: **Iced**

**Verify:**
- [ ] Selected chip berubah warna (primary)
- [ ] Non-selected tetap putih
- [ ] Button "Lanjut" aktif

**Tap "Lanjut"**

#### 4. Step 2 - Detail

**Input:**
- Kekuatan Kopi: **4** (geser slider ke kanan)
- Tingkat Manis: **2** (agak pahit)
- Pilihan Susu: **Oat Milk**

**Verify:**
- [ ] Slider berfungsi dengan smooth
- [ ] Label berubah sesuai value (Ringan/Sedang/Kuat)
- [ ] Chip susu selected dengan benar

**Tap "Lanjut"**

#### 5. Step 3 - Kondisi

**Input:**
- Budget: **Rp 50,000** (geser slider)
- Mood: **Nugas**
- Buka Sekarang: **ON** (toggle)

**Verify:**
- [ ] Budget value update real-time (Rp XX,XXX)
- [ ] Mood chip selected
- [ ] Switch toggle aktif (hijau)

**Tap "Temukan Rekomendasi"**

#### 6. Verify Recommendation Results

Navigate ke RecommendationResultScreen.

**Expected Display:**
- List of menu items ranked by match score
- Setiap card menampilkan:
  - [ ] Nama menu (e.g., "Iced Latte")
  - [ ] Nama kedai
  - [ ] Harga (Rp XX,XXX)
  - [ ] Match score (%)
  - [ ] Match score color:
    - 🟢 Hijau (80-100%)
    - 🟡 Kuning (60-79%)
    - 🟠 Orange (40-59%)
  - [ ] Rating kedai (⭐ X.X)

**Verify Sorting:**
- [ ] Menu di posisi #1 punya match score tertinggi
- [ ] Menu terakhir punya match score terendah (≥40%)

**Console Log Expected:**
```
🔍 Guided search criteria:
  - Drink: Coffee
  - Flavor: Chocolate
  - Temp: Iced
  - Strength: 4
  - Milk: Oat Milk
  - Sweet: 2
  - Vibe: Nugas
  - Budget: 50000
✅ Found X matching items
```

#### 7. Test Different Scenarios

**Scenario A: Low Budget**
- Budget: Rp 15,000
- **Expected:** Hanya menu murah yang muncul (Kopi O, Teh)

**Scenario B: High Standard**
- Strength: 5 (sangat kuat)
- Sweetness: 1 (pahit)
- **Expected:** Espresso, Americano dengan match score tinggi

**Scenario C: Specific Vibe**
- Vibe: Nongkrong
- **Expected:** Hanya kedai dengan vibe "nongki" atau "nongkrong"

**Scenario D: No Match**
- Budget: Rp 10,000
- Vibe: Meeting (jika tidak ada di data)
- **Expected:** Empty state "Tidak ada rekomendasi"

#### 8. Tap Menu Card
- Tap salah satu menu dari hasil
- **Expected:**
  - Navigate ke DetailMenuScreen
  - Tampil detail menu lengkap

---

## 🎯 TEST SCENARIO 3: SIMPLE SEARCH

### Objektif
Verify simple search by budget dan vibe.

### Steps to Test

#### 1. Dari Tab Rekomendasi
- Tap "Cari Cepat" card (pertama)

#### 2. Select Budget
- Tap chip budget: **Rp 50k**

#### 3. Select Vibe
- Tap chip vibe: **Nugas**

#### 4. Tap "Cari"

**Expected:**
- Filter coffee shops yang:
  - Punya menu ≤ Rp 50,000
  - Punya vibe "nugas"
- List coffee shops muncul

#### 5. Try "No Limit" Budget
- Select: **No Limit**
- Select: **All** vibe

**Expected:**
- Tampil semua kedai (no filter)

---

## 🐛 ERROR SCENARIOS TO TEST

### Error 1: Invalid API Key
**Setup:**
```env
GEMINI_API_KEY="invalid_key_123"
```

**Test:**
- Tap "Generate via AI"
- Input kota
- Tap "Generate"

**Expected:**
- SnackBar error: "API Key Gemini belum diatur di .env atau tidak valid"
- Console: `❌ Gemini API Key tidak valid atau belum diset`

### Error 2: No Internet
**Setup:**
- Turn off WiFi dan mobile data

**Test:**
- Tap "Generate via AI"
- Input kota
- Tap "Generate"

**Expected:**
- Loading indicator (timeout)
- SnackBar error: "Gagal men-generate data dari Gemini: ..."
- Console: `❌ Error during generation: ...`

### Error 3: API Rate Limit
**Setup:**
- Generate 10+ times in rapid succession

**Expected:**
- Error from Gemini API
- SnackBar: "Gagal: quota exceeded" atau similar

---

## ✅ PASSING CRITERIA

Test dianggap **PASS** jika:

### Generate Coffee Shop ✅
- [ ] API key valid ter-detect di console
- [ ] Generate berhasil untuk minimal 3 kota berbeda
- [ ] Setiap generate menambah 3-5 kedai baru
- [ ] Data tersimpan di database (persist setelah restart)
- [ ] UI update setelah generate
- [ ] No crashes atau force close

### Guided Search ✅
- [ ] 3-step wizard berfungsi sempurna
- [ ] Semua input (slider, chip, toggle) responsive
- [ ] Match score calculation benar
- [ ] Results ter-sort by score (tertinggi di atas)
- [ ] Score color coding sesuai (hijau/kuning/orange)
- [ ] Detail menu navigable

### Simple Search ✅
- [ ] Filter budget bekerja
- [ ] Filter vibe bekerja
- [ ] Empty state muncul jika no match
- [ ] "All" dan "No Limit" menampilkan semua data

### Error Handling ✅
- [ ] Invalid API key → proper error message
- [ ] No internet → proper error message
- [ ] Empty database → seed data auto-load
- [ ] No search results → empty state view

---

## 📊 TEST RESULTS TEMPLATE

Copy template ini dan isi setelah testing:

```
==================================================
COFFEE BUDGET TRACKER - AI FEATURES TEST REPORT
==================================================

Tester: [Nama Anda]
Date: [Tanggal]
Build: 1.0.0+1
Device: [e.g., Pixel 6 Android 13]

--------------------------------------------------
PRE-TEST SETUP
--------------------------------------------------
[ ] API Key valid (dimulai dengan AIza)
[ ] .env file loaded
[ ] Internet connected
[ ] Console log shows initialization success

--------------------------------------------------
TEST SCENARIO 1: GENERATE COFFEE SHOP
--------------------------------------------------
6a. Kota Besar (Jakarta):         [ PASS / FAIL ]
6b. Kota Kecil (Tanjung Pinang):  [ PASS / FAIL ]
6c. Kota dengan Spasi:            [ PASS / FAIL ]
6d. Input Kosong:                 [ PASS / FAIL ]
6e. Multiple Generation:          [ PASS / FAIL ]

Total Shops After Generate: _____ shops

Issues Found:
[Tulis bug/issue di sini jika ada]

--------------------------------------------------
TEST SCENARIO 2: GUIDED SEARCH
--------------------------------------------------
Basic Flow (Coffee/Chocolate/Iced):  [ PASS / FAIL ]
Low Budget Scenario:                 [ PASS / FAIL ]
High Standard Scenario:              [ PASS / FAIL ]
Specific Vibe Scenario:              [ PASS / FAIL ]
No Match Scenario:                   [ PASS / FAIL ]

Match Score Range: ___% - ___%
Top Result Score: ____%

Issues Found:
[Tulis bug/issue di sini jika ada]

--------------------------------------------------
TEST SCENARIO 3: SIMPLE SEARCH
--------------------------------------------------
Budget Filter:    [ PASS / FAIL ]
Vibe Filter:      [ PASS / FAIL ]
"All" Option:     [ PASS / FAIL ]
Empty State:      [ PASS / FAIL ]

Issues Found:
[Tulis bug/issue di sini jika ada]

--------------------------------------------------
ERROR SCENARIOS
--------------------------------------------------
Invalid API Key:     [ PASS / FAIL ]
No Internet:         [ PASS / FAIL ]
API Rate Limit:      [ PASS / FAIL / NOT TESTED ]

--------------------------------------------------
OVERALL RESULT
--------------------------------------------------
Total Tests:    ___
Passed:         ___
Failed:         ___
Pass Rate:      ___%

Final Verdict:  [ PASS / FAIL ]

Recommendation:
[ APPROVE FOR PRODUCTION / NEEDS FIXES ]

==================================================
```

---

## 📞 JIKA ADA MASALAH

### 1. Check Logs
```bash
flutter logs
```
Cari log dengan emoji: 🔑 🤖 📤 📥 ✅ ❌

### 2. Verify API Key
```bash
cat .env | grep GEMINI
```
Pastikan output dimulai dengan `AIza`

### 3. Test API Key Manual
Buka: https://aistudio.google.com/app/prompts/new_chat
- Paste API key
- Try prompt: "Generate 3 coffee shops in Jakarta as JSON"

### 4. Clear Cache & Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### 5. Re-install App
```bash
flutter run --uninstall-first
```

---

**Good Luck Testing! 🎉**

Last Updated: 9 Juni 2026
