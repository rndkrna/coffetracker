# Coffee Budget Tracker

Aplikasi Flutter untuk mencatat, menganalisis, dan mengelola budget pengeluaran kopi harian. App mendukung auth Supabase, penyimpanan lokal SQLite, katalog coffee shop, rekomendasi menu, OCR struk, lokasi, integrasi AI, Foursquare Places, dan Google Maps.

## Prasyarat

- Flutter SDK sesuai `pubspec.yaml` (`sdk: ^3.5.0`)
- Project Supabase dengan schema dari `supabase_schema.sql`
- API key opsional:
  - Gemini untuk fitur AI
  - Foursquare Places untuk pencarian coffee shop nyata
  - Google Maps untuk tampilan peta dan marker

## Konfigurasi Environment

Untuk build yang lebih aman, gunakan `--dart-define` dan jangan membundel `.env` ke aplikasi production.

Contoh run development:

```sh
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key \
  --dart-define=GEMINI_API_KEY=your-gemini-api-key \
  --dart-define=FOURSQUARE_API_KEY=your-foursquare-api-key \
  --dart-define=GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

Saat debug lokal, file `.env` masih bisa digunakan sebagai fallback jika tersedia, tetapi `.env` tidak didaftarkan sebagai Flutter asset sehingga tidak ikut dipaketkan ke app.

Contoh `.env` lokal:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
GEMINI_API_KEY=your-gemini-api-key
FOURSQUARE_API_KEY=your-foursquare-api-key
GOOGLE_MAPS_API_KEY=your-google-maps-api-key
```

> Jangan commit `.env` atau API key asli. Batasi API key di provider masing-masing jika tersedia.

## Setup Supabase

1. Buat project Supabase.
2. Jalankan isi `supabase_schema.sql` di SQL editor Supabase.
3. Pastikan Row Level Security aktif dan policy sesuai kebutuhan.
4. Masukkan `SUPABASE_URL` dan `SUPABASE_ANON_KEY` lewat `--dart-define`.

## Menjalankan App

```sh
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

Jika konfigurasi Supabase belum tersedia, app akan menampilkan layar error konfigurasi alih-alih crash saat startup.

## Test & Analisis

```sh
flutter test
flutter analyze
```

Test service Foursquare:

```sh
flutter test test/services/foursquare_places_service_test.dart
```

## Catatan Keamanan

- `.env` tidak dimasukkan ke asset bundle.
- API key tidak dicetak sebagian ke log.
- Debug route diagnostics hanya aktif pada mode debug.
- Untuk produksi, fitur Gemini sebaiknya dipanggil lewat backend/proxy agar API key tidak berada di client app.

## Batasan Sinkronisasi Saat Ini

Sync Supabase saat ini melakukan:

- Upsert transaksi lokal ke remote.
- Download transaksi remote yang belum ada di lokal.

Conflict resolution penuh dan sync delete membutuhkan metadata tambahan di database lokal seperti `updatedAt`, `deletedAt`, dan `syncStatus`.
