# MASTER PROMPT — REBUILD COFFEE BUDGET TRACKER

Saya memiliki aplikasi **Coffee Budget Tracker** yang sudah pernah dibuat sebelumnya. Tugas kamu adalah **menganalisis, merapikan, dan melakukan rebuild aplikasi yang sudah ada** agar seluruh tampilan, struktur halaman, alur pengguna, komponen, fitur, dan arsitekturnya sesuai dengan dokumen berikut:

1. `Coffee_Budget_Tracker_PRD_v4.2.md`
2. `Coffee_Budget_Tracker_Design_System_v1.md`
3. `Coffee_Budget_Tracker_Wireframe_Per_Halaman_v1.md`

Gunakan ketiga dokumen tersebut sebagai **sumber kebenaran utama**. Jangan membuat arah desain, fitur, nama halaman, warna, atau flow baru yang bertentangan dengan dokumen.

---

## 1. TUJUAN UTAMA

Rebuild aplikasi lama menjadi aplikasi mobile Coffee Budget Tracker yang:

- menggunakan Flutter dan Dart;
- mendukung Android dan iOS;
- menggunakan Supabase untuk authentication, database, storage, dan Edge Functions;
- memiliki tampilan bertema kopi dengan warna cream dan roasted brown;
- memiliki struktur UI yang konsisten;
- menerapkan fitur pencatatan transaksi kopi;
- mendukung OCR struk;
- mendukung GPS dan pencarian coffeeshop terdekat;
- mendukung rekomendasi menu kopi berdasarkan preferensi, anggaran, radius, dan ketersediaan menu;
- memiliki statistik pengeluaran;
- memiliki state loading, empty, error, offline, dan permission;
- responsif pada berbagai ukuran layar;
- tidak menghilangkan fungsi lama yang masih relevan dan masih bekerja dengan baik.

---

## 2. ATURAN SEBELUM MULAI CODING

Sebelum mengubah kode:

1. Baca seluruh struktur folder proyek.
2. Identifikasi:
   - framework dan versi Flutter;
   - pola arsitektur yang digunakan;
   - state management;
   - routing;
   - struktur database;
   - integrasi Supabase;
   - service GPS;
   - OCR;
   - komponen yang sudah reusable;
   - halaman yang sudah tersedia;
   - halaman yang masih belum sesuai;
   - bug dan technical debt.
3. Jangan langsung menghapus file lama.
4. Jangan melakukan rewrite total tanpa alasan.
5. Pertahankan kode yang:
   - masih berfungsi;
   - aman;
   - mudah dipelihara;
   - sesuai kebutuhan terbaru.
6. Refactor bagian yang:
   - duplikat;
   - terlalu besar;
   - mencampur UI dan business logic;
   - menggunakan hard-coded value;
   - tidak memiliki error handling;
   - tidak sesuai design system.
7. Buat backup atau daftar perubahan sebelum mengganti struktur besar.
8. Jika terdapat konflik antara implementasi lama dan dokumen, ikuti dokumen versi terbaru.
9. Jangan menggunakan data dummy pada fitur produksi kecuali untuk development preview.
10. Jangan menyimpan API key langsung di source code.

---

## 3. OUTPUT AWAL YANG WAJIB DIBERIKAN

Sebelum implementasi, tampilkan hasil audit dalam format berikut:

### A. Ringkasan Proyek Saat Ini

- teknologi yang digunakan;
- struktur utama folder;
- daftar halaman yang tersedia;
- daftar service yang tersedia;
- daftar package utama;
- integrasi backend yang sudah berjalan.

### B. Gap Analysis

Buat tabel:

| Area | Kondisi Saat Ini | Target Berdasarkan Dokumen | Tindakan |
| --- | --- | --- | --- |
| Tema warna | ... | Cream dan roasted brown | Refactor |
| Navigation | ... | 5 bottom navigation | Update |
| Recommendation | ... | Guided search 3 langkah | Build |
| GPS | ... | Permission dan fallback | Update |

### C. Rencana Rebuild

Bagi menjadi beberapa tahap:

1. Foundation dan design system.
2. Routing dan navigasi.
3. Authentication.
4. Home dan budget.
5. Transactions.
6. OCR.
7. GPS dan Coffeeshop Finder.
8. Menu Recommendation.
9. Statistik dan favorites.
10. Testing dan final cleanup.

Jangan mulai implementasi besar sebelum audit dan rencana selesai.

---

## 4. TARGET ARSITEKTUR

Gunakan struktur modular dan feature-first.

Contoh struktur:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   └── constants/
├── core/
│   ├── config/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   ├── services/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── budget/
│   ├── transactions/
│   ├── ocr/
│   ├── location/
│   ├── coffeeshop_finder/
│   ├── recommendations/
│   ├── statistics/
│   ├── favorites/
│   └── profile/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
└── main.dart
```

Setiap feature minimal memiliki:

```text
feature_name/
├── data/
├── domain/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── providers/
└── services/
```

Apabila proyek lama sudah memiliki pola arsitektur yang baik, sesuaikan tanpa memaksakan perubahan yang tidak perlu.

---

## 5. STATE MANAGEMENT

Gunakan **Riverpod** jika proyek sudah atau akan menggunakan Riverpod.

Pisahkan state berikut:

- authentication state;
- user profile state;
- budget state;
- transaction state;
- OCR state;
- GPS/location state;
- coffeeshop finder state;
- recommendation form state;
- recommendation result state;
- favorites state;
- statistics state.

Setiap state harus mendukung:

- initial;
- loading;
- success;
- empty;
- error;
- refreshing jika diperlukan.

Jangan menaruh request API langsung di widget.

---

## 6. DESIGN SYSTEM

Gunakan design system berikut sebagai token utama.

### Warna

```dart
class AppColors {
  static const background = Color(0xFFFAF5EE);
  static const surface = Color(0xFFFFFDF9);
  static const primary = Color(0xFF5C3A21);
  static const secondary = Color(0xFF8B5E3C);
  static const accent = Color(0xFFC49A6C);
  static const cream = Color(0xFFF4E9DA);
  static const warmBeige = Color(0xFFEBD7BE);
  static const textPrimary = Color(0xFF3A2416);
  static const textSecondary = Color(0xFF8A8178);
  static const border = Color(0xFFDCCAB5);
  static const success = Color(0xFF7C9A62);
  static const warning = Color(0xFFD1A054);
  static const error = Color(0xFFB85C4A);
  static const info = Color(0xFF7A8FA6);
}
```

### Radius

```dart
class AppRadius {
  static const small = 14.0;
  static const medium = 16.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
}
```

### Spacing

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
```

### Typography

- heading: Playfair Display atau DM Serif Display;
- body: Poppins atau Inter;
- heading utama: espresso brown;
- body utama: dark roast;
- secondary text: warm gray.

### Karakter UI

- card-based layout;
- rounded corners;
- cream background;
- roasted brown CTA;
- shadow ringan bernuansa coklat;
- banyak whitespace;
- tidak menggunakan warna terlalu ramai;
- tidak menggunakan gradient berlebihan;
- tidak menggunakan layout yang padat dan sulit dibaca.

---

## 7. KOMPONEN REUSABLE

Buat atau rapikan komponen berikut:

```text
CoffeeAppBar
CoffeeBottomNavigation
PrimaryButton
SecondaryButton
GhostButton
CoffeeTextField
CoffeeDropdown
CoffeeSearchBar
FilterChipGroup
BudgetSummaryCard
TransactionCard
CoffeeshopCard
RecommendationCard
MenuCard
AvailabilityBadge
LocationStatusBadge
RatingBadge
PriceTag
EmptyStateView
ErrorStateView
OfflineStateView
LoadingSkeleton
StepProgressHeader
PriceInputField
RadiusSelector
SectionHeader
ConfirmationBottomSheet
PermissionDialog
```

Aturan:

- jangan menduplikasi style;
- jangan hard-code warna pada setiap halaman;
- gunakan theme, token, dan reusable widget;
- semua tombol harus memiliki loading dan disabled state;
- semua input harus memiliki validation dan helper/error text.

---

## 8. ROUTING DAN NAVIGASI

Gunakan routing terstruktur, disarankan `go_router`.

Bottom navigation:

1. Home
2. Transaksi
3. Cari Kedai
4. Rekomendasi
5. Profil

Route minimal:

```text
/splash
/onboarding
/login
/register
/setup-budget
/home
/transactions
/transactions/add
/transactions/:id
/ocr/scan
/ocr/result
/finder
/finder/map
/coffeeshop/:id
/recommendations
/recommendations/guided
/recommendations/results
/menu/:id
/statistics
/favorites
/profile
/profile/edit
/profile/preferences
/profile/privacy-location
/budget
/notifications
```

Gunakan route guard untuk authentication.

---

## 9. DAFTAR HALAMAN WAJIB

Implementasikan halaman sesuai wireframe.

### Authentication dan Setup

- Splash Screen
- Onboarding 3 halaman
- Login
- Register
- Setup Budget Awal

### Home dan Budget

- Home Dashboard
- Notifikasi
- Detail Budget
- Edit Budget

### Transaksi

- Daftar Transaksi
- Tambah Transaksi Manual
- Detail Transaksi
- Edit Transaksi
- Konfirmasi Hapus

### OCR

- Scan Struk
- OCR Processing
- Hasil OCR
- Konfirmasi sebelum simpan

### Coffeeshop Finder

- Permission Location
- Finder List View
- Finder Map View
- Detail Coffeeshop
- Manual Location Input
- GPS Error State

### Menu Recommendation

- Pilih Mode
- Rekomendasi Cepat
- Guided Search Langkah 1
- Guided Search Langkah 2
- Guided Search Langkah 3
- Loading Rekomendasi
- Hasil Rekomendasi
- Detail Menu
- Empty State dan alternatif

### Lainnya

- Favorites
- Statistik
- Profil
- Edit Profil
- Preferensi Minuman
- Privasi & Lokasi

---

## 10. HOME DASHBOARD

Home harus menampilkan:

- greeting user;
- tanggal;
- notification icon;
- avatar;
- budget bulan ini;
- total terpakai;
- sisa budget;
- progress budget;
- shortcut Tambah Transaksi;
- shortcut Scan Struk;
- shortcut Cari Kedai;
- shortcut Rekomendasi;
- insight mingguan;
- transaksi terbaru.

Jangan membuat dashboard terlalu padat.

---

## 11. FITUR TRANSAKSI

Field:

- nama minuman;
- harga;
- coffeeshop/lokasi;
- tanggal;
- waktu;
- kategori;
- catatan;
- source: manual atau OCR;
- koordinat opsional.

Fitur wajib:

- create;
- read;
- update;
- delete;
- validation;
- local cache;
- offline sync;
- sorting;
- filtering;
- pencarian.

Jangan menyimpan nominal sebagai string. Gunakan tipe numerik yang tepat.

---

## 12. OCR STRUK

Flow:

1. User membuka scanner.
2. User mengambil gambar atau memilih dari galeri.
3. Gambar dikompres.
4. Ambil konteks GPS jika tersedia.
5. Ambil nearby coffeeshop dalam radius kecil.
6. Kirim gambar dan konteks ke Edge Function.
7. AI mengekstrak:
   - nama minuman;
   - harga;
   - nama coffeeshop;
   - tanggal;
   - waktu jika tersedia.
8. Tampilkan hasil yang dapat diedit.
9. User mengonfirmasi.
10. Simpan transaksi.

Tambahkan:

- permission kamera;
- loading state;
- error OCR;
- retry;
- manual correction;
- preview gambar;
- confidence atau catatan jika data tidak pasti.

Jangan menyimpan base64 gambar secara permanen jika tidak diperlukan.

---

## 13. GPS DAN LOCATION SERVICE

Gunakan:

- `geolocator`;
- `geocoding`;
- `permission_handler`;
- Google Maps;
- Google Places;
- fallback manual.

Permission flow:

- granted;
- denied;
- denied sekali;
- permanently denied;
- restricted;
- service disabled.

Fallback:

1. GPS device.
2. Network/last known position.
3. IP geolocation.
4. Manual location.

Aturan:

- GPS hanya aktif saat dibutuhkan;
- tidak melakukan background tracking terus-menerus;
- tampilkan sumber lokasi;
- tampilkan akurasi jika tersedia;
- cache lokasi maksimal satu jam;
- user harus dapat mengganti lokasi manual;
- seluruh error harus memiliki UI yang jelas.

---

## 14. COFFEESHOP FINDER

Fitur:

- lokasi saat ini;
- source badge;
- refresh lokasi;
- search bar;
- filter mood;
- filter budget;
- filter fasilitas;
- filter jarak;
- filter buka sekarang;
- radius 500 m, 1 km, 3 km, 5 km, 10 km;
- list view;
- map view;
- sorting;
- detail coffeeshop;
- deep link Google Maps.

Coffeeshop card menampilkan:

- foto;
- nama;
- rating;
- jarak;
- estimasi harga;
- mood;
- fasilitas;
- status buka.

---

## 15. MENU RECOMMENDATION

Sediakan dua mode:

1. Rekomendasi Cepat.
2. Cari Menu Sendiri.

### Guided Search

Langkah 1:

- jenis minuman;
- rasa;
- suhu.

Langkah 2:

- kekuatan kopi;
- pilihan susu;
- kemanisan;
- preferensi tambahan.

Langkah 3:

- kondisi pengguna;
- budget;
- lokasi;
- radius;
- buka sekarang.

Minimal satu preferensi wajib dipilih.

### Hard Filtering

Sebelum AI ranking, filter menu berdasarkan:

- menu aktif;
- status tidak unavailable;
- harga;
- radius;
- jam buka;
- preferensi wajib;
- freshness status ketersediaan.

### Ranking

Gunakan komponen default:

```text
taste_match             25%
menu_type_match         20%
budget_match            20%
availability_score      15%
distance_score          10%
history_match           10%
```

### Recommendation Card

Tampilkan:

- foto;
- menu;
- coffeeshop;
- harga;
- jarak;
- match score;
- availability;
- waktu update;
- alasan;
- Detail;
- Maps;
- Simpan.

### Availability Status

- available;
- likely_available;
- unavailable;
- unverified.

Jangan menampilkan label **Tersedia** jika data verifikasi sudah kedaluwarsa.

Jika AI gagal, gunakan rule-based scoring sebagai fallback.

---

## 16. DATABASE SUPABASE

Pastikan tabel berikut tersedia atau dimigrasikan:

```text
profiles
budgets
transactions
coffeeshops
menu_items
menu_availability
recommendation_sessions
favorites
user_locations
notification_preferences
```

### `transactions`

Minimal:

```text
id
user_id
menu_name
price
category
transaction_date
transaction_time
location
location_lat
location_lng
location_source
coffeeshop_id
source
notes
created_at
updated_at
```

### `menu_items`

Minimal:

```text
id
coffeeshop_id
name
category
description
price
temperature
strength_level
sweetness_level
milk_types
flavor_tags
caffeine_level
dietary_tags
image_url
is_active
updated_at
```

### `menu_availability`

Minimal:

```text
id
menu_item_id
status
stock_status
source
verified_at
expires_at
confidence_score
updated_by
notes
```

### `recommendation_sessions`

Minimal:

```text
id
user_id
latitude
longitude
area_name
radius_meters
max_budget
preferences
result_count
created_at
```

Buat migration yang aman dan jangan menghapus data lama tanpa backup.

Aktifkan Row Level Security.

---

## 17. OFFLINE-FIRST

Gunakan local database seperti Drift/SQLite.

Offline behavior:

- transaksi dapat disimpan lokal;
- tampilkan status pending sync;
- sinkronkan saat internet kembali;
- cache data coffeeshop;
- cache hasil rekomendasi terakhir;
- jangan membuat aplikasi crash saat offline.

Conflict strategy harus jelas.

---

## 18. ERROR HANDLING

Gunakan error model terpusat.

Jenis error:

- network error;
- Supabase error;
- authentication error;
- GPS error;
- permission error;
- OCR error;
- Places API error;
- empty result;
- timeout;
- offline.

Setiap error harus:

- memiliki pesan yang mudah dipahami;
- memiliki tombol retry jika relevan;
- tidak menampilkan raw exception ke user;
- dicatat ke logger pada mode development.

---

## 19. RESPONSIVE DAN ACCESSIBILITY

Aturan:

- gunakan SafeArea;
- gunakan LayoutBuilder atau responsive utility;
- jangan hard-code tinggi layar;
- support font scaling;
- touch target minimal 44–48 px;
- teks utama minimal 14 px;
- gunakan semantic label;
- jangan hanya mengandalkan warna untuk status;
- support dark text contrast pada cream background;
- keyboard tidak boleh menutupi input;
- form harus scrollable.

---

## 20. PERFORMANCE

Pastikan:

- image caching;
- pagination pada transaksi;
- debounce search;
- Places API caching 24 jam;
- rekomendasi tidak melakukan request berulang tanpa perubahan filter;
- provider tidak rebuild seluruh halaman;
- gunakan const widget jika memungkinkan;
- kompres gambar OCR;
- hindari nested scroll yang berat;
- lazy load list.

---

## 21. KEAMANAN

- API key tidak boleh berada di repository;
- gunakan `.env`;
- request AI dan Places sensitif melalui Edge Function;
- aktifkan RLS;
- validasi data di client dan server;
- sanitasi input;
- batasi upload;
- jangan menyimpan koordinat permanen tanpa kebutuhan;
- jangan menyimpan IP user;
- jangan log token atau data sensitif.

---

## 22. TESTING

Buat:

### Unit Test

- budget calculation;
- recommendation score;
- availability expiration;
- location fallback;
- transaction validation;
- repository mapping.

### Widget Test

- login;
- transaction form;
- guided search;
- empty recommendation;
- GPS error state;
- budget card.

### Integration Test

- login sampai home;
- tambah transaksi;
- OCR sampai simpan;
- finder sampai detail;
- guided recommendation sampai detail menu;
- offline transaction sync.

---

## 23. DEFINITION OF DONE

Rebuild dianggap selesai jika:

1. Semua halaman utama tersedia.
2. Tema cream dan roasted brown konsisten.
3. Tidak ada hard-coded style yang tidak perlu.
4. Bottom navigation bekerja.
5. Auth guard bekerja.
6. CRUD transaksi bekerja.
7. OCR flow memiliki loading, correction, dan error.
8. GPS permission dan fallback bekerja.
9. Coffeeshop Finder memiliki list dan map.
10. Guided Menu Search memiliki tiga langkah.
11. Hard filtering dilakukan sebelum AI ranking.
12. Status ketersediaan transparan.
13. Empty/loading/error/offline state tersedia.
14. Aplikasi responsif.
15. Database memiliki RLS.
16. Tidak ada API key di client.
17. Test utama lulus.
18. Tidak ada crash pada flow utama.
19. `flutter analyze` tidak memiliki error.
20. Dokumentasi setup diperbarui.

---

## 24. CARA KERJA YANG DIHARAPKAN

Kerjakan secara bertahap.

Untuk setiap tahap:

1. Jelaskan file yang akan dibuat atau diubah.
2. Jelaskan alasan perubahan.
3. Tulis kode lengkap, bukan potongan yang tidak dapat digunakan.
4. Jangan meninggalkan TODO palsu.
5. Jangan menulis placeholder yang seolah-olah sudah bekerja.
6. Setelah tahap selesai:
   - jalankan format;
   - jalankan analyze;
   - jalankan test terkait;
   - laporkan error;
   - perbaiki error sebelum lanjut.

Jangan mengubah banyak bagian sekaligus tanpa menjelaskan dampaknya.

---

## 25. FORMAT RESPONS AI CODING AGENT

Gunakan format jawaban:

```text
TAHAP:
TUJUAN:
HASIL AUDIT:
FILE YANG DIUBAH:
FILE BARU:
PERUBAHAN DATABASE:
IMPLEMENTASI:
PENGUJIAN:
HASIL:
MASALAH YANG BELUM SELESAI:
LANGKAH BERIKUTNYA:
```

Saat memberikan kode, sebutkan path file secara lengkap.

---

## 26. PERINTAH PERTAMA

Mulai dengan:

1. Audit seluruh project saat ini.
2. Baca ketiga file Markdown acuan.
3. Buat gap analysis.
4. Buat migration plan.
5. Jangan langsung menulis ulang seluruh aplikasi.
6. Tunjukkan tahap pertama yang paling aman untuk dikerjakan.
