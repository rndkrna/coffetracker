☕

Coffee Budget Tracker

Product Requirements Document — v4.2

| Versi | Tanggal | Status | Platform |
| --- | --- | --- | --- |
| v4.2 | Juni 2026 | Final — Guided Menu Search + AI + GPS | Mobile (Android & iOS) |

🤖  v4.0: Tiga fitur AI baru (OCR AI, Coffeeshop Finder, Menu Recommendation) + migrasi ke Supabase

📍  v4.1: Spesifikasi GPS & Lokasi diperkuat — permission flow, reverse geocoding, fallback, & integrasi lintas fitur

🧭 **v4.2:** Guided Menu Search, form preferensi, hard filtering, katalog menu, dan validasi ketersediaan di coffeeshop terdekat.

# 1. Ringkasan Eksekutif

Coffee Budget Tracker adalah aplikasi mobile (Flutter) untuk mencatat, memantau, dan menganalisis pengeluaran kopi harian. Versi 4.2 mempertahankan fondasi GPS dan layanan lokasi dari v4.1, lalu memperluas fitur Menu Recommendation dengan pencarian mandiri berbasis preferensi, anggaran, radius, dan validasi ketersediaan menu pada coffeeshop terdekat.

## Riwayat Perubahan

### Perubahan Utama v4.1 vs v4.0

| Aspek | v4.0 | v4.1 (Update) |
| --- | --- | --- |
| GPS Spec | Disebutkan singkat (Geolocator) | Spesifikasi lengkap: permission, akurasi, fallback, reverse geocoding |
| Izin Lokasi | Tidak dirinci | Flow izin lengkap: Android & iOS, denied/permanently denied handling |
| Reverse Geocoding | Tidak ada | Koordinat → nama jalan/kota otomatis via Geocoding API |
| Fallback GPS | Tidak ada | 3-tier fallback: GPS → Network → IP Geolocation → Manual |
| Integrasi OCR | Lokasi diisi manual | OCR AI dapat auto-suggest nama kedai dari koordinat GPS |
| Integrasi Transaksi | Field lokasi manual | Lokasi otomatis dari GPS + konfirmasi user |
| Privasi Lokasi | Tidak dirinci | Data GPS tidak disimpan permanen di server, hanya session |

### Perubahan Utama v4.2 vs v4.1

| Aspek | v4.1 | v4.2 (Update) |
| --- | --- | --- |
| Mode Rekomendasi | Rekomendasi berdasarkan konteks lokasi | Rekomendasi Cepat + Cari Menu Sendiri |
| Input Preferensi | Belum dirinci | Jenis, rasa, suhu, kekuatan, susu, kemanisan, kondisi, anggaran, dan radius |
| Validasi Menu | Belum dirinci | Hard filtering dan katalog menu internal |
| Ketersediaan | Tidak memiliki model status | Tersedia, kemungkinan tersedia, tidak tersedia, belum diverifikasi |
| Database | Belum ada tabel menu recommendation | menu_items, menu_availability, recommendation_sessions |
| UX | Belum memiliki flow detail | Form preferensi, kartu alasan, alternatif, dan empty state |

# 2. Arsitektur Layanan Lokasi (GPS Service)

## 2.1 Stack Teknologi Lokasi

| Package / API | Versi | Fungsi |
| --- | --- | --- |
| geolocator | ^12.0.0 | Akses GPS device — koordinat lat/lng, akurasi, altitude, heading |
| geocoding | ^3.0.0 | Reverse geocoding: koordinat → alamat (nama jalan, kota, kecamatan) |
| permission_handler | ^11.0.0 | Kelola izin lokasi Android & iOS secara terpadu |
| google_maps_flutter | ^2.5.0 | Tampilkan peta interaktif di halaman Coffeeshop Finder |
| Google Places API | REST | Cari kedai kopi di sekitar koordinat user |
| Google Geocoding API | REST | Reverse geocoding akurat via server (fallback dari package) |
| ipapi.co | REST | IP Geolocation — fallback terakhir jika GPS & network gagal |

## 2.2 Permission Flow — Izin Lokasi

⚠️  Izin lokasi WAJIB diminta sebelum fitur Coffeeshop Finder dapat digunakan. Fitur lain (input transaksi, OCR) dapat berjalan tanpa GPS — lokasi menjadi opsional di sana.

### Diagram Flow Izin Lokasi

- App pertama kali dibuka atau user buka halaman Coffeeshop Finder
- Cek status izin saat ini via permission_handler
- Status: granted → langsung ambil koordinat GPS
- Status: denied (belum pernah diminta) → tampilkan rationale dialog
- "Untuk menemukan kedai kopi terdekat, app membutuhkan akses lokasi kamu."
- Tombol: "Izinkan Lokasi" | "Nanti Saja"
- User tap "Izinkan" → OS permission dialog → granted/denied
- Status: denied (sudah pernah ditolak sekali) → tampilkan gentle reminder
- Banner di atas hasil: "Aktifkan lokasi untuk hasil lebih akurat"
- Hasil fallback: gunakan kota/kecamatan dari profil user atau input manual
- Status: permanentlyDenied → tampilkan dialog buka Settings
- "Izin lokasi diblokir. Buka Settings untuk mengaktifkan?"
- Tombol: "Buka Settings" → openAppSettings() | "Masukkan Lokasi Manual"
- Status: restricted (iOS, kontrol parental) → langsung ke mode manual
### Konfigurasi Platform

| Platform | File Konfigurasi | Key yang Ditambahkan |
| --- | --- | --- |
| Android | AndroidManifest.xml | ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, ACCESS_BACKGROUND_LOCATION (opsional) |
| iOS | Info.plist | NSLocationWhenInUseUsageDescription, NSLocationAlwaysUsageDescription |
| Android | build.gradle | compileSdkVersion 34+ untuk targetSdk terbaru |
| iOS | Podfile | platform :ios, "12.0" minimum |

## 2.3 Tingkat Akurasi GPS

| Mode | LocationAccuracy | Akurasi | Konsumsi Baterai | Digunakan Pada |
| --- | --- | --- | --- | --- |
| High | LocationAccuracy.high | ± 5–10 meter | Tinggi | Coffeeshop Finder aktif |
| Medium | LocationAccuracy.medium | ± 30–50 meter | Sedang | Saat input transaksi |
| Low | LocationAccuracy.low | ± 500 meter | Rendah | Background refresh cache kedai |
| Reduced | LocationAccuracy.reduced | ± 1–3 km | Sangat rendah | Estimasi kota/area untuk rekomendasi |

ℹ️  App TIDAK menggunakan background location secara terus-menerus. GPS hanya aktif saat user membuka Coffeeshop Finder atau menekan tombol "Deteksi Lokasi" di form transaksi. Ini menjaga baterai dan privasi user.

## 2.4 Fallback GPS — 3-Tier Strategy

Tidak semua user mengizinkan GPS atau berada di area dengan sinyal baik. Sistem dirancang dengan 3 lapis fallback agar fitur Coffeeshop Finder tetap berjalan dalam kondisi apapun.

| Tier | Metode | Akurasi | Kondisi | Implementasi |
| --- | --- | --- | --- | --- |
| 1 — Primary | GPS Device (Geolocator) | ± 5–50 m | GPS aktif & izin granted | Geolocator.getCurrentPosition() |
| 2 — Network | Cell Tower / WiFi Positioning | ± 100–500 m | GPS tidak tersedia, tapi ada network | LocationAccuracy.low via Geolocator |
| 3 — IP Geo | IP Geolocation (ipapi.co) | ± 1–10 km (level kota) | Semua lokasi device gagal | HTTP GET api.ipapi.co/api/check?fields=city,latitude,longitude |
| Manual | Input kota/area oleh user | N/A | User menolak semua izin | TextField + dropdown kota di UI |

```dart
// Contoh implementasi fallback chain (Dart pseudocode)
Future<LocationData> getLocation() async {
  // Tier 1: GPS Device
  if (await permission_handler.Permission.location.isGranted) {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      return LocationData.fromGPS(pos.latitude, pos.longitude, source: "gps");
    } catch (_) {}
  }
  // Tier 2: Network/Cell positioning
  try {
    final pos = await Geolocator.getLastKnownPosition();
    if (pos != null) return LocationData.fromGPS(pos.latitude, pos.longitude, source: "network");
  } catch (_) {}
  // Tier 3: IP Geolocation
  try {
    final ipData = await IpGeoService.fetchLocation();
    return LocationData.fromIP(ipData.lat, ipData.lng, city: ipData.city, source: "ip");
  } catch (_) {}
  // Manual fallback
  return LocationData.manual();
}
```

## 2.5 Reverse Geocoding — Koordinat → Nama Lokasi

Setelah koordinat GPS diperoleh, sistem melakukan reverse geocoding untuk mengonversi koordinat menjadi nama lokasi yang mudah dibaca manusia (nama jalan, kecamatan, kota).

| Input | Proses | Output Contoh |
| --- | --- | --- |
| lat: 0.9183, lng: 104.4690 (Batam) | Geocoding API reverse lookup | "Jl. Imam Bonjol, Nagoya, Batam" |
| lat: -0.9493, lng: 104.3593 (Tanjungpinang) | Geocoding API reverse lookup | "Jl. Teuku Umar, Tanjungpinang Kota" |

```dart
// Reverse geocoding (package geocoding)
Future<String> reverseGeocode(double lat, double lng) async {
  final placemarks = await placemarkFromCoordinates(lat, lng);
  if (placemarks.isNotEmpty) {
    final p = placemarks.first;
    return "${p.street}, ${p.subLocality}, ${p.locality}";
    // Output: "Jl. Imam Bonjol, Nagoya, Batam"
  }
  return "Lokasi tidak diketahui";
}
```

💡  Hasil reverse geocoding ditampilkan sebagai saran di field "Lokasi" pada form transaksi dan form Coffeeshop Finder. User tetap bisa mengedit atau mengganti secara manual.

# 3. Integrasi GPS ke Semua Fitur

## 3.1 Coffeeshop Finder — GPS sebagai Inti Fitur

**F21 — Priority 1**

Fitur Coffeeshop Finder sepenuhnya bergantung pada lokasi GPS untuk memberikan hasil yang relevan. Pencarian kedai menggunakan koordinat real-time user sebagai pusat radius pencarian.

### Flow Lengkap dengan GPS

- User buka halaman Coffeeshop Finder
- App cek izin lokasi via permission_handler
- Jika belum granted → jalankan Permission Flow (lihat Bab 2.2)
- Sistem ambil koordinat GPS (Tier 1–3 sesuai kondisi)
- Tampilkan loading: "Mendeteksi lokasi kamu..."
- Tampilkan badge sumber lokasi: 📍 GPS Aktif / 📶 Network / 🌐 Perkiraan IP
- Reverse geocoding → tampilkan area saat ini: "Kamu di: Nagoya, Batam"
- User set radius pencarian: 500m / 1km / 3km / 5km / 10km
- App query Google Places API: nearby search dengan lat/lng + radius + keyword "coffee"
- Parameter: location=lat,lng&radius=1000&type=cafe&keyword=coffee&key=API_KEY
- Hasil di-cache ke Supabase tabel coffeeshops (TTL: 24 jam)
- User set filter tambahan: mood, budget, fasilitas
- AI Edge Function re-ranking berdasarkan konteks user + filter aktif
- Tampilkan kartu kedai: nama, jarak dari posisi user, estimasi harga, badge mood
- User tap kartu → detail kedai + tombol "Buka di Maps" (deep link Google Maps)
### Komponen UI Lokasi di Coffeeshop Finder

| Komponen | Fungsi | Interaksi User |
| --- | --- | --- |
| Location Bar | Tampilkan "Kamu di: [area saat ini]" + ikon sumber GPS | Tap → refresh lokasi manual |
| Radius Slider | Pilih radius pencarian: 500m, 1km, 3km, 5km, 10km | Geser → hasil diperbarui otomatis |
| GPS Source Badge | Ikon & label sumber: GPS / Network / IP / Manual | Informatif, tidak interaktif |
| Map Preview | Peta kecil (Google Maps Flutter) dengan pin kedai & posisi user | Tap → expand ke full-screen map |
| Sort by Distance | Urutkan hasil: terdekat / rating terbaik / harga terendah | Toggle tombol sorting |
| Manual Location | Input kota/area jika GPS tidak tersedia | TextField dengan autocomplete |

## 3.2 Input Transaksi — Lokasi Opsional dari GPS

**F4 — Priority 0**

GPS bersifat opsional di form transaksi. Jika user mengizinkan, sistem akan otomatis mengisi field lokasi. Jika tidak, user tetap bisa mengisi manual atau mengosongkan.

| Skenario | Behavior App |
| --- | --- |
| GPS granted & aktif | Field "Lokasi" terisi otomatis dari reverse geocoding saat form dibuka. Akurasi: medium (LocationAccuracy.medium) untuk hemat baterai. |
| GPS granted tapi lemot (>5 detik) | Gunakan getLastKnownPosition() sebagai fallback cepat. Tampilkan label "(Lokasi terakhir diketahui)" |
| GPS denied | Field "Lokasi" kosong dengan placeholder: "Opsional — ketik nama kedai" |
| User punya Favorite Coffeeshop | Tampilkan chip autocomplete dari daftar kedai favorit user |
| OCR scan aktif | Jika OCR mendeteksi nama kedai di struk → prefill field lokasi dari nama kedai tersebut |

💡  Field lokasi di form transaksi juga memiliki autocomplete dari riwayat 10 lokasi terakhir yang pernah user input, terlepas dari GPS aktif atau tidak.

## 3.3 OCR AI — Konteks Lokasi untuk Identifikasi Kedai

**F4a+ — Priority 0**

Ketika user melakukan scan struk, sistem dapat menggunakan koordinat GPS saat ini untuk membantu AI mengidentifikasi nama kedai dengan lebih akurat — terutama jika nama di struk ambigu atau tidak lengkap.

| Skenario | Tanpa GPS | Dengan GPS |
| --- | --- | --- |
| Struk bertuliskan "Kopi Kita" | AI hanya tahu "Kopi Kita", lokasi null | AI + GPS lookup → "Kopi Kita, Nagoya, Batam" (dari Places API nearby) |
| Struk hanya ada harga, tanpa nama | Nama kosong, user isi manual | Sistem cari kedai terdekat dari GPS → suggest nama sebagai pilihan |
| Nama kedai di struk: "KK" | AI tidak bisa expand singkatan | GPS + Places API → cocokkan dengan "Kopitown Kavling" 150m dari user |

```json
// Payload OCR dengan konteks GPS (dikirim ke Edge Function)
{
  "image_base64": "...",
  "gps_context": {
    "latitude": 1.1301,
    "longitude": 104.0529,
    "accuracy_meters": 12,
    "area_name": "Nagoya, Batam",
    "nearby_cafes": ["Kopi Kita Nagoya", "Kopitown", "Kedai Bencoolen"]
  },
  "prompt": "Ekstrak nama kopi & harga dari struk. Gunakan nearby_cafes untuk bantu identifikasi nama kedai jika ada di struk."
}
```

## 3.4 Menu Recommendation dan Guided Menu Search

**F22 — Priority 1**

Fitur **Menu Recommendation** membantu pengguna menemukan menu kopi berdasarkan preferensi pribadi, anggaran, kondisi atau suasana, lokasi, serta ketersediaan menu pada coffeeshop di sekitar pengguna. Lokasi menjadi konteks penting, tetapi fitur tetap dapat digunakan dalam mode umum ketika GPS tidak aktif.

### 3.4.1 Mode Rekomendasi

Fitur menyediakan dua mode utama:

1. **Rekomendasi Cepat**  
   Sistem secara otomatis memberikan rekomendasi berdasarkan riwayat transaksi, menu favorit, anggaran kopi, waktu, konteks penggunaan, dan lokasi pengguna.

2. **Cari Menu Sendiri**  
   Sistem menampilkan pilihan preferensi yang dapat diisi pengguna. Setelah form terisi, sistem mencari menu yang paling sesuai dan memastikan menu tersebut tercatat tersedia pada coffeeshop terdekat.

### 3.4.2 Form Pencarian Menu

| Kriteria | Pilihan / Input |
| --- | --- |
| Jenis minuman | Espresso, Americano, Latte, Cappuccino, Mocha, Manual Brew, Non-Coffee |
| Rasa yang diinginkan | Pahit, manis, creamy, fruity, nutty, chocolate |
| Suhu minuman | Panas, dingin, bebas |
| Kekuatan kopi | Ringan, sedang, kuat |
| Kandungan susu | Tanpa susu, susu biasa, oat milk, almond milk, bebas |
| Tingkat kemanisan | Tanpa gula, sedikit manis, normal, sangat manis |
| Kondisi pengguna | Butuh fokus, santai, bekerja, begadang, nongkrong |
| Batas anggaran | Harga maksimum menu dalam Rupiah |
| Jarak coffeeshop | 500 m, 1 km, 3 km, 5 km, atau 10 km |
| Preferensi tambahan | Rendah kalori, tanpa gula, non-dairy, decaf |
| Buka sekarang | Aktif / nonaktif |

Tidak semua pilihan wajib diisi. Pengguna minimal mengisi satu preferensi agar pencarian dapat dijalankan.

**Contoh input pengguna:**

- Rasa: creamy dan sedikit manis
- Suhu: dingin
- Kekuatan kopi: sedang
- Kondisi: sedang mengerjakan tugas
- Anggaran: maksimal Rp30.000
- Radius: 3 km

**Contoh hasil:**

> **Iced Café Latte — Rp25.000**  
> Tersedia di Kopi Senja, berjarak 850 meter.  
> Alasan rekomendasi: creamy, dingin, tingkat kafein sedang, dan sesuai anggaran.

### 3.4.3 Flow Pencarian Menu

1. Pengguna membuka halaman **Rekomendasi Menu**.
2. Pengguna memilih **Rekomendasi Cepat** atau **Cari Menu Sendiri**.
3. Sistem menggunakan lokasi aktif pengguna atau meminta input lokasi manual.
4. Pengguna mengisi preferensi dan menekan tombol **Cari Menu**.
5. Sistem mencari coffeeshop dalam radius yang dipilih.
6. Sistem mengambil katalog menu dari coffeeshop yang ditemukan.
7. Sistem melakukan hard filtering berdasarkan ketersediaan, harga, radius, jam operasional, dan preferensi wajib.
8. AI memberikan skor kecocokan pada menu yang lolos.
9. Sistem menampilkan menu dengan skor tertinggi beserta alasan rekomendasi.
10. Pengguna dapat melihat detail, membuka rute, menyimpan favorit, atau mencatat pembelian.

### 3.4.4 Hard Filtering

Menu dikeluarkan dari hasil utama apabila:

- berstatus tidak tersedia atau habis;
- harga melebihi anggaran pengguna;
- coffeeshop berada di luar radius;
- coffeeshop sedang tutup saat filter **Buka Sekarang** aktif;
- menu bertentangan dengan preferensi wajib, misalnya pengguna memilih tanpa susu;
- data menu sudah tidak aktif;
- data ketersediaan kedaluwarsa dan tidak dapat diverifikasi.

Menu yang sedikit melampaui anggaran dapat ditampilkan pada bagian **Alternatif Terdekat**, bukan pada hasil utama.

### 3.4.5 Skor Rekomendasi

| Komponen | Bobot Default |
| --- | ---: |
| Kecocokan rasa | 25% |
| Kecocokan jenis minuman | 20% |
| Kesesuaian anggaran | 20% |
| Ketersediaan menu | 15% |
| Jarak coffeeshop | 10% |
| Kecocokan dengan riwayat pengguna | 10% |

```text
recommendation_score =
(taste_match × 0.25) +
(menu_type_match × 0.20) +
(budget_match × 0.20) +
(availability_score × 0.15) +
(distance_score × 0.10) +
(history_match × 0.10)
```

Bobot dapat disesuaikan berdasarkan eksperimen produk dan hasil evaluasi pengguna.

### 3.4.6 Validasi Ketersediaan Menu

Google Places API digunakan untuk menemukan coffeeshop, tetapi tidak menjamin stok menu secara real-time. Oleh karena itu, ketersediaan menu harus berasal dari katalog internal atau sumber terverifikasi.

Sumber status ketersediaan:

1. Dashboard pemilik atau pegawai coffeeshop.
2. Integrasi API atau POS partner.
3. Pembaruan oleh admin aplikasi.
4. Laporan pengguna.
5. Data transaksi atau OCR terbaru sebagai indikasi pendukung.

| Status | Penjelasan |
| --- | --- |
| Tersedia | Diverifikasi oleh coffeeshop, partner, atau admin dan belum kedaluwarsa |
| Kemungkinan tersedia | Menu terdaftar, tetapi verifikasi terakhir sudah cukup lama |
| Tidak tersedia | Menu habis, dinonaktifkan, atau dihentikan sementara |
| Belum diverifikasi | Sistem belum memiliki data ketersediaan yang memadai |

Sistem tidak boleh menampilkan label **Tersedia** apabila hanya mengetahui nama menu tanpa validasi terbaru.

Contoh label:

```text
Tersedia — diperbarui 15 menit lalu
```

```text
Kemungkinan tersedia — konfirmasi ke coffeeshop
```

### 3.4.7 Integrasi Lokasi

- Jika GPS aktif, rekomendasi diprioritaskan dari coffeeshop dalam radius default 3 km.
- Jika GPS tidak aktif, pengguna dapat memilih kota atau area secara manual.
- Jika pengguna memilih coffeeshop dari Coffeeshop Finder, rekomendasi hanya menampilkan menu dari coffeeshop tersebut.
- Jarak dihitung menggunakan koordinat pengguna dan koordinat coffeeshop.
- Lokasi tidak disimpan permanen di server dan mengikuti kebijakan privasi pada Bab 5.

### 3.4.8 Isi Kartu Rekomendasi

Setiap kartu minimal menampilkan:

- foto dan nama menu;
- nama coffeeshop;
- harga;
- jarak;
- rating coffeeshop;
- persentase kecocokan;
- status ketersediaan;
- waktu pembaruan status;
- alasan rekomendasi;
- tombol **Lihat Kedai**, **Buka Maps**, **Simpan**, dan **Catat Pembelian**.

Contoh:

```text
Iced Caramel Latte
Kopi Kita Nagoya

Rp28.000
1,2 km dari lokasi kamu
92% cocok

✓ Tersedia
Diperbarui 20 menit lalu

Cocok karena kamu memilih:
creamy, dingin, sedikit manis, dan maksimal Rp30.000.
```

### 3.4.9 Empty State dan Relaksasi Kriteria

Apabila tidak ditemukan menu yang memenuhi semua kriteria, sistem menampilkan:

> Belum ada menu yang sesuai dengan seluruh pilihanmu.

Pilihan tindakan:

- **Naikkan anggaran**
- **Perluas jarak**
- **Izinkan menu serupa**
- **Ubah preferensi**
- **Lihat rekomendasi umum**

Contoh:

> Tidak ada hasil di bawah Rp20.000. Terdapat Iced Americano seharga Rp22.000 pada kedai berjarak 700 meter.

### 3.4.10 Acceptance Criteria

1. Pengguna dapat memilih mode pencarian mandiri.
2. Pengguna dapat mengisi satu atau lebih preferensi.
3. Sistem hanya menampilkan coffeeshop dalam radius yang dipilih.
4. Sistem tidak menampilkan menu melebihi anggaran pada hasil utama.
5. Setiap hasil menampilkan nama menu, harga, coffeeshop, jarak, alasan, dan status ketersediaan.
6. Menu berstatus tidak tersedia tidak masuk rekomendasi utama.
7. Label **Tersedia** hanya digunakan untuk data yang masih valid.
8. Data yang belum dapat diverifikasi diberi label **Kemungkinan tersedia** atau **Belum diverifikasi**.
9. Pengguna dapat membuka lokasi coffeeshop melalui Maps.
10. Pengguna dapat mengubah preferensi tanpa mengisi ulang seluruh form.
11. Sistem tetap memberikan rekomendasi umum saat GPS tidak aktif.
12. Jika tidak ada hasil, sistem menawarkan relaksasi kriteria.

# 4. Skema Database — Data Lokasi

## 4.1 Tabel: user_locations (Session Cache)

🔒  Koordinat GPS tidak disimpan permanen di server. Tabel ini hanya menyimpan lokasi terakhir user untuk keperluan UX (agar tidak perlu detect GPS ulang setiap buka app). Data otomatis expired setelah 1 jam.

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| id | UUID (PK) | Auto-generated |
| user_id | UUID (FK → users.id) | Pemilik data lokasi |
| latitude | FLOAT8 | Koordinat terakhir (sementara) |
| longitude | FLOAT8 | Koordinat terakhir (sementara) |
| accuracy_meters | FLOAT4 | Akurasi GPS dalam meter |
| area_name | TEXT | Hasil reverse geocoding: "Nagoya, Batam" |
| location_source | TEXT | "gps" \| "network" \| "ip" \| "manual" |
| updated_at | TIMESTAMPTZ | Waktu update terakhir — expired jika > 1 jam |

## 4.2 Update Tabel transactions — Kolom Lokasi

| Kolom | Tipe | Update v4.2 |
| --- | --- | --- |
| location | TEXT | Nama lokasi yang tampil (tidak berubah) |
| location_lat | FLOAT8 NULLABLE | 🆕 Latitude saat transaksi dicatat (opsional, jika GPS aktif) |
| location_lng | FLOAT8 NULLABLE | 🆕 Longitude saat transaksi dicatat (opsional, jika GPS aktif) |
| location_source | TEXT NULLABLE | 🆕 Sumber: "gps" \| "network" \| "manual" \| "ocr" |
| coffeeshop_id | UUID NULLABLE | Referensi ke tabel coffeeshops (tidak berubah) |

ℹ️  Kolom location_lat dan location_lng bersifat opsional dan hanya diisi jika GPS aktif saat transaksi dicatat. Data ini tidak ditampilkan ke user secara langsung, tetapi digunakan untuk analitik (misalnya: peta sebaran lokasi pembelian di halaman Statistik — fitur masa depan).

## 4.3 Update Tabel coffeeshops — Data Lokasi Lengkap

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| latitude | FLOAT8 NOT NULL | Koordinat presisi dari Google Places |
| longitude | FLOAT8 NOT NULL | Koordinat presisi dari Google Places |
| place_id | TEXT UNIQUE | Google Places ID — digunakan untuk deep link Maps |
| maps_url | TEXT | 🆕 URL Google Maps langsung ke kedai |
| distance_cache | FLOAT4 NULLABLE | 🆕 Jarak terakhir yang dihitung (dalam meter) — di-update per user session, bukan disimpan permanen |

## 4.4 Tabel: `menu_items`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| id | UUID (PK) | ID menu |
| coffeeshop_id | UUID (FK → coffeeshops.id) | Pemilik menu |
| name | TEXT | Nama menu |
| category | TEXT | coffee, non_coffee, food |
| description | TEXT NULLABLE | Deskripsi menu |
| price | NUMERIC | Harga menu |
| temperature | TEXT | hot, iced, both |
| strength_level | TEXT NULLABLE | light, medium, strong |
| sweetness_level | TEXT NULLABLE | none, low, normal, high |
| milk_types | TEXT[] | Pilihan susu |
| flavor_tags | TEXT[] | creamy, fruity, chocolate, nutty, bitter |
| caffeine_level | TEXT NULLABLE | low, medium, high |
| dietary_tags | TEXT[] | sugar_free, non_dairy, low_calorie, decaf |
| image_url | TEXT NULLABLE | Foto menu |
| is_active | BOOLEAN | Menu masih dijual atau tidak |
| updated_at | TIMESTAMPTZ | Waktu pembaruan terakhir |

## 4.5 Tabel: `menu_availability`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| id | UUID (PK) | ID status |
| menu_item_id | UUID (FK → menu_items.id) | Referensi menu |
| status | TEXT | available, likely_available, unavailable, unverified |
| stock_status | TEXT | in_stock, low_stock, sold_out, unknown |
| source | TEXT | coffeeshop, partner_api, admin, user_report, transaction_signal |
| verified_at | TIMESTAMPTZ NULLABLE | Waktu verifikasi |
| expires_at | TIMESTAMPTZ NULLABLE | Batas validitas |
| confidence_score | FLOAT4 NULLABLE | Nilai keyakinan 0–1 |
| updated_by | UUID NULLABLE | Pihak yang memperbarui |
| notes | TEXT NULLABLE | Catatan status |

## 4.6 Tabel: `recommendation_sessions`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| id | UUID (PK) | ID sesi rekomendasi |
| user_id | UUID (FK → users.id) | Pemilik sesi |
| latitude | FLOAT8 NULLABLE | Lokasi sementara |
| longitude | FLOAT8 NULLABLE | Lokasi sementara |
| area_name | TEXT NULLABLE | Nama area |
| radius_meters | INTEGER | Radius pencarian |
| max_budget | NUMERIC NULLABLE | Anggaran maksimum |
| preferences | JSONB | Jawaban pengguna |
| result_count | INTEGER | Jumlah hasil |
| created_at | TIMESTAMPTZ | Waktu pencarian |

Koordinat pada sesi rekomendasi mengikuti kebijakan cache lokasi dan tidak disimpan permanen melebihi kebutuhan sesi.

# 5. Privasi & Keamanan Data Lokasi

| Prinsip | Implementasi |
| --- | --- |
| Minimal Data | GPS hanya diakses saat user aktif membuka fitur lokasi — tidak ada background tracking |
| No Persistent GPS | Koordinat tidak disimpan permanen di Supabase. Cache lokasi expired otomatis setelah 1 jam |
| Transparency | Banner "Lokasi kamu sedang digunakan" saat GPS aktif. Sumber lokasi selalu ditampilkan di UI |
| User Control | User bisa matikan lokasi kapan saja via Settings app. App tetap berjalan tanpa GPS (degraded mode) |
| Opsional di Transaksi | Field lokasi di form transaksi tidak wajib. User bisa menyimpan transaksi tanpa data lokasi |
| IP Geolocation | Hanya digunakan sebagai fallback Tier 3. Tidak menyimpan IP address di Supabase |
| HTTPS only | Semua request ke Google Places API, Geocoding API, dan ipapi.co via HTTPS |

# 6. Komponen UI/UX Lokasi

## 6.1 Halaman Coffeeshop Finder — Wireframe Deskriptif

| Area UI | Konten | Catatan UX |
| --- | --- | --- |
| Header Bar | "Cari Kedai Kopi" + ikon refresh GPS | Tap ikon → refresh koordinat GPS |
| Location Strip | 📍 "Kamu di: Nagoya, Batam" + badge sumber GPS | Tap → modal ganti lokasi manual |
| Search Bar | Cari nama kedai spesifik (opsional) | Autocomplete dari cache Supabase |
| Filter Row (scroll horizontal) | Chip: Mood \| Budget \| Fasilitas \| Jarak \| Buka Sekarang | Chip aktif berwarna cokelat |
| Radius Picker | Segmented: 500m • 1km • 3km • 5km • 10km | Default: 3km |
| Map Toggle | Switch antara List View dan Map View | Map View gunakan google_maps_flutter |
| Result Cards | Foto • Nama • Jarak • Estimasi Harga • Badge Mood • Rating | Sorted by: closest / rating / price |
| Empty State | "Tidak ada kedai dalam radius [X]. Coba perluas jarak." | Tombol: "Perluas ke 5km" |
| GPS Error State | "Lokasi tidak terdeteksi. Masukkan lokasi manual." | Tampil TextField input kota |

## 6.2 Indikator Sumber Lokasi

User perlu tahu seberapa akurat lokasi yang digunakan. App menampilkan badge sumber secara transparan:

| Badge | Ikon | Makna | Ditampilkan Di |
| --- | --- | --- | --- |
| GPS Aktif | 📍 Hijau | Koordinat dari GPS device, akurasi ± 5–50m | Coffeeshop Finder, form transaksi |
| Sinyal Jaringan | 📶 Kuning | Dari cell tower/WiFi, akurasi ± 100–500m | Coffeeshop Finder |
| Perkiraan IP | 🌐 Oranye | Dari IP address, akurasi ± kota | Coffeeshop Finder (dengan disclaimer) |
| Manual | ✍️ Abu-abu | Diketik manual oleh user | Coffeeshop Finder, form transaksi |

## 6.3 Notifikasi & Pesan Lokasi

| Kondisi | Pesan yang Ditampilkan | Jenis |
| --- | --- | --- |
| GPS detecting... | "Mendeteksi lokasi kamu..." | Loading indicator |
| GPS berhasil | "Lokasi ditemukan: Nagoya, Batam" | SnackBar hijau, 2 detik |
| GPS timeout (>10 detik) | "GPS lambat, menggunakan lokasi jaringan..." | Banner kuning |
| GPS denied | "Aktifkan lokasi untuk hasil lebih akurat" | Banner atas, dismissible |
| GPS permanently denied | "Buka Settings → Izin Lokasi untuk mengaktifkan GPS" | Dialog dengan tombol Settings |
| IP Geolocation aktif | "Menggunakan perkiraan lokasi berdasarkan jaringan internet kamu" | Banner oranye ringan |
| Tidak ada kedai ditemukan | "Tidak ada kedai dalam radius ini. Coba perluas jarak pencarian." | Empty state illustration |

## 6.4 Halaman Menu Recommendation — Wireframe Deskriptif

| Area UI | Konten | Catatan UX |
| --- | --- | --- |
| Header | “Temukan Kopi yang Cocok Untukmu” | Menjelaskan bahwa hasil mempertimbangkan preferensi dan lokasi |
| Location Strip | Area saat ini + badge sumber lokasi | Dapat diganti manual |
| Mode Selector | Rekomendasi Cepat / Cari Menu Sendiri | Segmented control |
| Preference Form | Jenis, rasa, suhu, susu, kemanisan, kebutuhan, anggaran | Progressive disclosure agar tidak terasa panjang |
| Radius Picker | 500 m, 1 km, 3 km, 5 km, 10 km | Default 3 km |
| Open Now Toggle | Hanya tampilkan kedai yang sedang buka | Opsional |
| Search Button | “Cari Menu” | Aktif setelah minimal satu preferensi dipilih |
| Result Summary | Jumlah hasil, lokasi, radius, filter aktif | Dapat diubah tanpa kembali |
| Recommendation Card | Foto, menu, kedai, harga, jarak, skor, status | Menampilkan waktu verifikasi |
| Alternative Section | Menu serupa atau sedikit di atas anggaran | Tidak bercampur dengan hasil utama |
| Empty State | Saran menaikkan anggaran atau memperluas radius | Tidak berhenti pada pesan kosong |

### 6.4.1 Status Ketersediaan pada UI

| Status | Badge | Perilaku |
| --- | --- | --- |
| Tersedia | Hijau | Dapat masuk hasil utama |
| Kemungkinan tersedia | Kuning | Masuk hasil dengan catatan konfirmasi |
| Tidak tersedia | Merah | Tidak ditampilkan pada hasil utama |
| Belum diverifikasi | Abu-abu | Ditampilkan hanya jika hasil terverifikasi tidak mencukupi |

# 7. Flow Diagram Lengkap — GPS & Lokasi

## 7.1 Flow Utama Coffeeshop Finder dengan GPS

- User buka tab "Cari Kedai" di Bottom Navigation
- GPS Service diinisialisasi → cek izin
- Jika belum ada izin → tampilkan rationale → minta izin OS
- Jika ditolak permanen → mode manual aktif
- Ambil koordinat (Tier 1 GPS → Tier 2 Network → Tier 3 IP → Manual)
- Reverse geocoding → tampilkan nama area
- User memilih filter (mood, budget, fasilitas, radius)
- Query Google Places API: nearby cafes dalam radius dari koordinat
- Cek cache Supabase: jika data < 24 jam → gunakan cache; jika tidak → fetch & cache baru
- Hitung jarak setiap kedai dari koordinat user (Haversine formula)
- Kirim [list kedai + filter + konteks user] ke Edge Function coffeeshop-rank
- AI re-rank → kembalikan urutan final + alasan tiap kedai
- Render kartu kedai dengan jarak real-time dari GPS user
- User pilih kedai → detail page → tombol: "Catat Kunjungan" | "Buka di Maps"
## 7.2 Flow GPS di Form Transaksi

- User buka form "Tambah Transaksi" (FAB atau dari Coffeeshop Finder)
- Jika datang dari Coffeeshop Finder: field lokasi sudah prefilled nama kedai
- Jika buka langsung: sistem ambil getLastKnownPosition() (≤ 5 detik)
- Jika tersedia: reverse geocoding → isi field lokasi otomatis
- Jika tidak: field lokasi kosong, tampilkan autocomplete riwayat lokasi
- User bisa edit, ganti, atau kosongkan field lokasi
- Simpan transaksi → jika GPS aktif, simpan juga lat/lng ke kolom location_lat/lng
## 7.3 Flow GPS di OCR Scan

- User tap "Scan Struk"
- Sistem ambil koordinat GPS saat ini (jika tersedia)
- Query Places API: cari kedai terdekat dalam 500m dari koordinat
- Ambil foto struk → compress → base64
- Kirim ke Edge Function ocr-receipt dengan payload: gambar + daftar kedai terdekat
- AI Vision parse struk + cocokkan nama dengan nearby cafes
- Form diisi otomatis: nama kopi, harga, lokasi (dari GPS + struk), tanggal
- User koreksi jika perlu → simpan
## 7.4 Flow Menu Recommendation dan Guided Search

1. Pengguna membuka tab **Rekomendasi**.
2. Sistem membaca lokasi aktif atau meminta lokasi manual.
3. Pengguna memilih **Rekomendasi Cepat** atau **Cari Menu Sendiri**.
4. Pada mode pencarian mandiri, pengguna mengisi preferensi.
5. Sistem mengambil coffeeshop dalam radius.
6. Sistem mengambil `menu_items` aktif dari coffeeshop tersebut.
7. Sistem menggabungkan data `menu_availability`.
8. Hard filtering dijalankan untuk harga, jarak, jam buka, preferensi wajib, dan status stok.
9. Menu yang lolos dikirim ke Edge Function `menu-recommend`.
10. AI memberi skor dan alasan rekomendasi.
11. Sistem menampilkan hasil utama dan alternatif.
12. Pengguna memilih menu, membuka Maps, menyimpan favorit, atau mencatat transaksi.
13. Feedback klik, simpan, dan pembelian dapat digunakan untuk meningkatkan personalisasi berikutnya.

# 8. Testing Strategy — GPS & Lokasi

| Skenario Test | Tipe | Expected Result |
| --- | --- | --- |
| GPS granted, akurasi tinggi | Integration | Koordinat diperoleh < 5 detik, kartu kedai tampil diurutkan jarak |
| GPS denied (sekali) | Manual | Banner reminder muncul, hasil fallback ke IP geo atau manual |
| GPS permanently denied | Manual | Dialog Settings muncul, mode manual tersedia |
| GPS timeout (simulasi GPS lemot) | Integration | App berpindah ke Tier 2 Network dalam 10 detik |
| Tidak ada internet + GPS aktif | Manual | Coffeeshop Finder load dari Supabase cache lokal |
| Tidak ada internet + GPS denied | Manual | Empty state dengan pesan informatif, bukan crash |
| Reverse geocoding gagal | Unit | Fallback ke koordinat mentah, tidak crash |
| Radius diubah oleh user | Widget | Hasil diperbarui dalam ≤ 2 detik |
| Tombol refresh GPS | Widget | Lokasi diperbarui dan kartu kedai di-re-render |
| Koordinat di luar Indonesia | Integration | Hasil Places API tetap ditampilkan sesuai lokasi aktual |
| Pencarian dengan satu preferensi | Widget | Tombol Cari Menu aktif dan hasil sesuai preferensi |
| Anggaran maksimum diterapkan | Integration | Menu di atas anggaran tidak masuk hasil utama |
| Menu berstatus unavailable | Integration | Menu tidak ditampilkan pada rekomendasi utama |
| Status availability kedaluwarsa | Unit | Label turun menjadi likely_available atau unverified |
| GPS tidak aktif | Integration | User dapat memilih lokasi manual dan tetap mendapat hasil |
| Tidak ada hasil sesuai | Widget | Empty state menawarkan perluasan radius, anggaran, atau menu serupa |
| Coffeeshop tutup + filter buka sekarang | Integration | Menu dari kedai tersebut tidak ditampilkan |
| Alasan rekomendasi | Unit | Setiap hasil memiliki alasan yang sesuai dengan preferensi |

# 9. Non-Functional Requirements — Lokasi

| Aspek | Requirement |
| --- | --- |
| Waktu Deteksi GPS | ≤ 5 detik pada kondisi normal (ruangan terbuka) |
| Timeout GPS | 10 detik — setelah itu otomatis fallback ke Tier 2 |
| Akurasi Minimum | Tier 1: ≤ 50m; Tier 2: ≤ 500m; Tier 3: level kota (± 5km) |
| Konsumsi Baterai | GPS hanya aktif saat foreground — tidak ada background location service |
| Cache Places API | Data kedai di-cache 24 jam di Supabase untuk kurangi API calls |
| Offline Graceful | App tidak crash tanpa GPS atau internet; semua error state punya UI yang informatif |
| Privacy | Koordinat GPS tidak dikirim ke server kecuali diperlukan (query Places API via Edge Function); tidak disimpan permanen |
| Waktu Respons Rekomendasi | Hasil awal tampil ≤ 3 detik setelah data kedai dan menu tersedia |
| Freshness Ketersediaan | Status available wajib memiliki verified_at dan expires_at yang masih valid |
| Transparansi AI | Setiap rekomendasi wajib menampilkan alasan singkat yang dapat dipahami user |
| Fallback Rekomendasi | Jika AI gagal, sistem tetap dapat mengurutkan menu dengan rule-based scoring |
| Keamanan API | API key dan query partner dijalankan melalui Supabase Edge Functions, bukan dari client |

# 10. Tech Stack Lengkap v4.2

| Layer | Teknologi | Fungsi |
| --- | --- | --- |
| Frontend | Flutter (Dart) | UI cross-platform Android & iOS |
| Backend / DB | Supabase (PostgreSQL) | Auth, data, realtime, storage, Edge Functions |
| GPS Device | geolocator ^12.0.0 | Koordinat lat/lng dari GPS/Network |
| Reverse Geocoding | geocoding ^3.0.0 + Google Geocoding API | Koordinat → nama jalan/area |
| Permissions | permission_handler ^11.0.0 | Kelola izin lokasi Android & iOS |
| Peta | google_maps_flutter ^2.5.0 | Map view di Coffeeshop Finder |
| Kedai Terdekat | Google Places API (Nearby Search) | Cari cafe dalam radius dari koordinat |
| IP Fallback | ipapi.co REST API | Estimasi kota jika GPS & network gagal |
| AI — OCR | GPT-4o Vision / Gemini 1.5 Flash | Scan struk + konteks GPS nearby cafes |
| AI — Ranking | Claude Haiku / GPT-4o Mini | Re-rank kedai berdasarkan konteks user |
| AI — Rekomendasi | Claude Haiku / GPT-4o Mini + pgvector | Menu recommendation personal |
| Local DB | SQLite (drift) | Offline-first cache transaksi & lokasi |
| State Mgmt | Riverpod | State management termasuk GPS state |
| Grafik | fl_chart | Visualisasi statistik pengeluaran |
| Katalog Menu | Supabase PostgreSQL | Menyimpan menu, atribut rasa, harga, dan relasi coffeeshop |
| Availability | Supabase Realtime + Edge Functions | Pembaruan status stok dan kedaluwarsa verifikasi |
| Recommendation Rules | Dart + Supabase Edge Function | Hard filtering sebelum AI ranking |

# 11. Risiko & Mitigasi — GPS & Lokasi

| # | Risiko | Dampak | Mitigasi |
| --- | --- | --- | --- |
| 1 | User menolak izin GPS | Coffeeshop Finder tidak akurat | Fallback 3-tier + mode manual; fitur tetap berjalan tapi degraded |
| 2 | GPS sangat lambat (indoor/basement) | UX buruk, loading lama | Timeout 10 detik → auto-fallback ke last known position |
| 3 | Google Places API quota habis | Tidak bisa cari kedai baru | Cache 24 jam di Supabase; alert quota monitoring di dashboard admin |
| 4 | Reverse geocoding gagal | Nama lokasi tidak muncul | Fallback ke koordinat mentah "Lat: X, Lng: Y" + opsi input manual |
| 5 | Biaya Google Maps API membengkak | Overbudget API | Cache agresif, rate limit query per user per menit, pakai SKU yang tepat |
| 6 | Privasi — user khawatir dilacak | User uninstall | Transparansi penuh: banner aktif GPS, tidak ada background tracking, tidak simpan permanen |
| 7 | iOS permission lebih ketat dari Android | Feature gap | Test intensif di iOS simulator; gunakan NSLocationWhenInUseUsageDescription yang jelas |
| 8 | Data menu coffeeshop tidak lengkap | Rekomendasi sedikit atau tidak akurat | Onboarding partner, import katalog, kurasi admin, dan user report |
| 9 | Status ketersediaan sudah kedaluwarsa | User datang tetapi menu habis | expires_at, label transparan, konfirmasi pengguna, dan refresh berkala |
| 10 | AI memberi rekomendasi tidak sesuai | Kepercayaan user menurun | Hard filtering, rule-based fallback, alasan rekomendasi, dan feedback pengguna |
| 11 | Coffeeshop tidak memiliki integrasi POS | Stok tidak real-time | Gunakan status kemungkinan tersedia dan hindari klaim pasti |

# 12. Referensi

- Flutter geolocator package — pub.dev/packages/geolocator
- Flutter geocoding package — pub.dev/packages/geocoding
- Flutter permission_handler — pub.dev/packages/permission_handler
- Google Maps Flutter — pub.dev/packages/google_maps_flutter
- Google Places API (Nearby Search) — developers.google.com/maps/documentation/places/web-service/nearby-search
- Google Geocoding API — developers.google.com/maps/documentation/geocoding
- IP Geolocation API — ipapi.co/api
- Supabase Documentation — supabase.com/docs
- Supabase pgvector — supabase.com/docs/guides/ai/vector-columns
- OpenAI Vision API — platform.openai.com/docs/guides/vision
- Anthropic Claude API — docs.anthropic.com
- Flutter Documentation — flutter.dev
- Material Design 3 — m3.material.io
PRD v4.2 — Coffee Budget Tracker · AI Features + GPS & Location Services

Juni 2026  |  Final
