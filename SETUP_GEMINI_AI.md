# 🤖 PANDUAN SETUP & TESTING GEMINI AI

## ⚠️ MASALAH YANG DITEMUKAN

API Key Gemini di file `.env` Anda **TIDAK VALID**:
```
❌ GEMINI_API_KEY="REDACTED_INVALID_GEMINI_KEY"
```

Format API key yang benar harus dimulai dengan **`AIza`**, contoh:
```
✅ GEMINI_API_KEY="AIzaSyD-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 🔧 PERBAIKAN TERBARU

### Update Model Name ✅
**Date:** 9 Juni 2026

**Problem:** 
- Error: `gemini-1.5-flash is not found for API version v1beta`
- Model name tidak tersedia atau tidak didukung

**Solution:**
- Changed model from `gemini-1.5-flash` to `gemini-pro`
- Model `gemini-pro` adalah model stabil dan widely available

**File Changed:**
- `lib/services/gemini_data_service.dart`

**Code:**
```dart
// Before
model: 'gemini-1.5-flash'

// After  
model: 'gemini-pro'
```

---

## 🚀 CARA SETUP SEKARANG

### ⚡ Quick Steps:
Kunjungi: **https://aistudio.google.com/app/apikey**

### 2️⃣ Login dengan Akun Google
- Gunakan akun Google Anda
- Jika belum punya, buat akun baru di https://accounts.google.com

### 3️⃣ Create API Key
1. Klik tombol **"Get API Key"** atau **"Create API Key"**
2. Pilih project Google Cloud (atau buat project baru)
3. Copy API Key yang dihasilkan (format: `AIzaSy...`)

### 4️⃣ Paste ke File .env
Edit file `.env` di root project:
```env
GEMINI_API_KEY="AIzaSyD-your-actual-key-here"
```

**⚠️ PENTING:**
- Jangan share API key Anda ke publik
- Jangan commit file `.env` ke git
- File `.env` sudah ada di `.gitignore`

---

## 🔧 KONFIGURASI FILE .env

File `.env` lengkap Anda sekarang:

```env
SUPABASE_URL="https://your-project.supabase.co"
SUPABASE_ANON_KEY="your_supabase_anon_key_here"
GEMINI_API_KEY="your_gemini_api_key_here"
```

**Ganti `your_gemini_api_key_here` dengan API key asli Anda!**

---

## 🧪 CARA TESTING FITUR AI GEMINI

### ✅ Fitur 1: Generate Coffee Shop Data (AI Training)

**Lokasi di Aplikasi:**
- Buka tab **"Cari Kedai"** (Finder)
- Klik tombol **"Generate via AI"** (Floating Action Button)

**Langkah Testing:**
1. Tap tombol **"Generate via AI"**
2. Masukkan nama kota, contoh: **"Jakarta"**, **"Bandung"**, **"Surabaya"**
3. Tap **"Generate"**
4. Tunggu beberapa detik
5. **Expected Result:** 
   - Loading indicator muncul
   - Data 3-5 kedai kopi baru muncul di list
   - Setiap kedai punya 3 menu item
   - SnackBar muncul: "Data kedai berhasil di-generate AI!"

**Jika Gagal:**
- Error message akan muncul di SnackBar
- Periksa API key di `.env`
- Periksa koneksi internet
- Lihat log di console

---

### ✅ Fitur 2: Guided Search (AI Recommendation)

**Lokasi di Aplikasi:**
- Buka tab **"Rekomendasi"**
- Tap **"Cari Menu Sendiri"**

**Langkah Testing:**
1. **Step 1 - Dasar:**
   - Pilih Jenis Minuman: Coffee / Non-Coffee / Tea / Pastry
   - Pilih Rasa: Chocolate / Fruity / Nutty / Caramel / Floral / Vanilla
   - Pilih Suhu: Hot / Iced
   - Tap **"Lanjut"**

2. **Step 2 - Detail:**
   - Atur Kekuatan Kopi (slider 1-5)
   - Atur Tingkat Manis (slider 1-5)
   - Pilih Susu: Regular / Oat / Almond / Soy / No Milk
   - Tap **"Lanjut"**

3. **Step 3 - Kondisi:**
   - Atur Budget (slider Rp 15k - 100k)
   - Pilih Mood: Nugas / Nongkrong / Meeting / Me Time / Date
   - Toggle: Buka Sekarang (on/off)
   - Tap **"Temukan Rekomendasi"**

4. **Expected Result:**
   - Halaman hasil rekomendasi muncul
   - Menu items ter-ranking berdasarkan **Match Score**
   - Match score tertinggi di atas (warna hijau 80-100%)
   - Setiap card menampilkan:
     - Nama menu
     - Nama kedai
     - Harga
     - Match score dengan color indicator
     - Rating kedai

**AI Matching Algorithm:**
Sistem menggunakan 5 faktor untuk scoring:
1. ✅ Temperature Match (Hot/Iced)
2. ✅ Milk Type Match
3. ✅ Flavor Match
4. ✅ Strength Level Similarity
5. ✅ Sweetness Level Similarity

Score ≥ 40% akan ditampilkan, diurutkan dari tertinggi.

---

### ✅ Fitur 3: Simple Search (Budget + Vibe)

**Lokasi di Aplikasi:**
- Buka tab **"Rekomendasi"**
- Tap **"Cari Cepat"**

**Langkah Testing:**
1. Pilih Budget: Rp 50k, 100k, 150k, atau No Limit
2. Pilih Vibe: Nugas, Nongkrong, Me Time, atau All
3. Tap **"Cari"**
4. **Expected Result:**
   - List coffee shops yang match dengan filter
   - Hanya tampilkan kedai yang punya menu <= budget
   - Filter by vibe jika dipilih

---

## 🐛 TROUBLESHOOTING

### ❌ Error: "API Key Gemini belum diatur di .env"
**Solusi:**
1. Pastikan file `.env` ada di root project
2. Pastikan API key valid dan dimulai dengan `AIza`
3. Restart aplikasi setelah edit `.env`

### ❌ Error: "Gagal men-generate data dari Gemini: ..."
**Kemungkinan Penyebab:**
1. **API Key tidak valid** → Generate API key baru
2. **Quota habis** → Cek quota di Google AI Studio
3. **Network error** → Cek koneksi internet
4. **API rate limit** → Tunggu beberapa menit

**Debug Steps:**
1. Buka terminal/console di aplikasi
2. Lihat error message detail
3. Cek log Flutter dengan: `flutter logs`

### ❌ Tidak Ada Data Kedai
**Solusi:**
1. Pertama kali buka app, akan ada 3 kedai seed data:
   - Samanko Coffee Roasters
   - Satu Rasi Coffee & Space
   - Warkop Kunokini
2. Jika kosong, gunakan fitur **"Generate via AI"** untuk menambah data

### ❌ Guided Search Tidak Ada Hasil
**Kemungkinan Penyebab:**
1. Budget terlalu rendah (< harga menu termurah)
2. Vibe tidak match dengan data kedai
3. Database masih kosong

**Solusi:**
1. Coba naikkan budget slider
2. Pilih vibe yang tersedia: Nugas, Nongkrong, Me Time
3. Generate data kedai baru via AI

---

## 📊 TESTING CHECKLIST

### Pre-Testing
- [ ] API Key Gemini sudah diisi di `.env`
- [ ] API Key valid (dimulai dengan `AIza`)
- [ ] File `.env` sudah di-load (restart app)
- [ ] Koneksi internet aktif

### Test Case 1: Generate Coffee Shop
- [ ] Tombol "Generate via AI" bisa diklik
- [ ] Dialog input kota muncul
- [ ] Loading indicator muncul saat generate
- [ ] Data kedai baru muncul di list
- [ ] Success message muncul
- [ ] Total kedai bertambah 3-5

### Test Case 2: Guided Search
- [ ] 3 step wizard berfungsi
- [ ] Semua input form bisa diisi
- [ ] Button "Lanjut" navigasi ke step berikutnya
- [ ] Button "Temukan Rekomendasi" navigate ke hasil
- [ ] Hasil rekomendasi muncul
- [ ] Match score ditampilkan dengan benar
- [ ] Sorting by match score (tertinggi di atas)
- [ ] Tap card navigate ke detail menu

### Test Case 3: Simple Search
- [ ] Filter budget berfungsi
- [ ] Filter vibe berfungsi
- [ ] Hasil sesuai filter
- [ ] Empty state jika tidak ada match

### Test Case 4: Edge Cases
- [ ] Generate dengan kota kosong → error message
- [ ] Generate dengan kota random → tetap generate (AI kreatif)
- [ ] Search dengan budget 0 → empty result
- [ ] Search tanpa data kedai → empty state

---

## 🔍 VERIFIKASI DATA DI DATABASE

### Cek Coffee Shops di Database:
```dart
// Di console/debug, jalankan:
final shops = await DatabaseHelper.instance.getAllCoffeeShops();
print('Total shops: ${shops.length}');
for (var shop in shops) {
  print('- ${shop.name}: ${shop.menu.length} items');
}
```

### Expected Output (Setelah Generate AI):
```
Total shops: 8
- Samanko Coffee Roasters: 3 items
- Satu Rasi Coffee & Space: 3 items
- Warkop Kunokini: 3 items
- [Kedai AI 1]: 3 items
- [Kedai AI 2]: 3 items
...
```

---

## 📱 UI FLOW TESTING

### Flow 1: First Time User
```
Launch App → Login → Home Tab → Tap "Rekomendasi" 
→ See 3 seed shops → Tap "Cari Menu Sendiri" 
→ Complete 3 steps → See recommendations
```

### Flow 2: Add More Data via AI
```
Home Tab → Tap "Cari Kedai" → Tap "Generate via AI" 
→ Input "Bandung" → Wait → See 3-5 new shops 
→ Go back to "Rekomendasi" → Search again → See more results
```

### Flow 3: Test Different Cities
```
Generate "Jakarta" → 3-5 shops
Generate "Surabaya" → 3-5 more shops
Generate "Bali" → 3-5 more shops
Total: 9-15 shops + 3 seed = 12-18 shops
```

---

## 💡 TIPS & BEST PRACTICES

### 1. Generate Data Gradually
- Jangan generate terlalu banyak sekaligus (rate limit)
- Generate 1 kota per request
- Tunggu sampai selesai sebelum generate lagi

### 2. Test dengan Data Realistis
- Gunakan nama kota nyata di Indonesia
- Coba kota besar: Jakarta, Bandung, Surabaya, Bali
- Coba kota kecil: Tanjung Pinang, Solo, Yogyakarta

### 3. Verify API Response
- Jika response kosong, cek prompt di `gemini_data_service.dart`
- Pastikan Gemini mengembalikan JSON valid
- Cek console log untuk debugging

### 4. Clean Database (Jika Perlu)
Untuk reset database:
1. Uninstall app
2. Install ulang
3. Seed data akan otomatis terisi
4. Generate data baru via AI

---

## 📞 SUPPORT & DOKUMENTASI

### Dokumentasi Gemini AI:
- **Google AI Studio:** https://aistudio.google.com
- **API Docs:** https://ai.google.dev/docs
- **Dart Package:** https://pub.dev/packages/google_generative_ai

### Jika Masih Bermasalah:
1. Screenshot error message
2. Copy console log
3. Periksa kode di `lib/services/gemini_data_service.dart`
4. Test API key di Google AI Studio playground

---

## ✅ KONFIRMASI SETUP BERHASIL

Anda siap testing jika:
- [x] File `.env` sudah diupdate dengan API key valid
- [x] App sudah di-restart
- [x] Seed data (3 kedai) muncul di tab Rekomendasi
- [x] Tombol "Generate via AI" bisa diklik
- [x] Koneksi internet stabil

**Selamat testing! 🎉**

---

**Catatan Penting:**
- Gemini AI free tier punya quota limit
- Jika quota habis, tunggu sampai reset (biasanya harian)
- Untuk production, consider upgrade ke paid plan
- Simpan API key dengan aman, jangan share ke publik

---

Last Updated: 9 Juni 2026
