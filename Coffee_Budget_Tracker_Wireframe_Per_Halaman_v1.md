# Coffee Budget Tracker — Wireframe Per Halaman

**Versi:** 1.0  
**Basis:** Coffee Budget Tracker PRD v4.2  
**Platform:** Mobile Android & iOS  
**Tipe:** Low-Fidelity Wireframe  
**Tema:** Coffee Cream & Roasted Brown  

---

# 1. Tujuan Wireframe

Dokumen ini menerjemahkan PRD dan design system Coffee Budget Tracker menjadi rancangan struktur antarmuka per halaman.

Wireframe berfokus pada:

- posisi elemen;
- hierarki informasi;
- alur navigasi;
- interaksi pengguna;
- kondisi normal, kosong, loading, dan error;
- konsistensi fitur transaksi, OCR, lokasi, coffeeshop, dan rekomendasi menu.

Wireframe belum menampilkan detail visual final seperti foto, ikon final, animasi, dan tipografi secara penuh.

---

# 2. Standar Layar

## 2.1 Ukuran Acuan

Ukuran dasar yang digunakan:

- lebar: 390 px;
- tinggi: 844 px;
- safe area atas: 44 px;
- safe area bawah: 34 px;
- margin horizontal: 20 px;
- grid dasar: 8 px.

## 2.2 Notasi Wireframe

| Simbol | Makna |
| --- | --- |
| `[ Tombol ]` | Tombol yang dapat ditekan |
| `( Pilihan )` | Radio button atau pilihan tunggal |
| `[✓]` | Checkbox aktif |
| `[ ]` | Checkbox tidak aktif |
| `──────` | Pembatas atau garis |
| `▣` | Gambar atau thumbnail |
| `⌕` | Search |
| `⌖` | Lokasi |
| `⌂` | Home |
| `◇` | Fitur AI |
| `☕` | Kopi atau menu |
| `▤` | Transaksi atau riwayat |
| `○` | Avatar |
| `⋮` | Menu tambahan |

---

# 3. Struktur Navigasi Utama

Bottom Navigation menggunakan lima menu:

1. Home
2. Transaksi
3. Cari Kedai
4. Rekomendasi
5. Profil

```text
┌──────────────────────────────────┐
│                                  │
│         KONTEN HALAMAN           │
│                                  │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
│ Home  Transaksi Finder  Rekom. Profil│
└──────────────────────────────────┘
```

Floating Action Button dapat muncul pada halaman Home dan Transaksi untuk menambah transaksi.

---

# 4. Alur Utama Pengguna

```text
Splash
  ↓
Onboarding
  ↓
Login / Register
  ↓
Home
  ├── Tambah Transaksi
  ├── Scan Struk
  ├── Cari Kedai
  ├── Rekomendasi Menu
  ├── Statistik
  └── Profil
```

---

# 5. Wireframe Halaman

---

# 5.1 Splash Screen

## Tujuan

Memperkenalkan identitas aplikasi ketika pertama kali dibuka.

```text
┌──────────────────────────────────┐
│                                  │
│                                  │
│              ☕                  │
│                                  │
│     COFFEE BUDGET TRACKER        │
│                                  │
│  Catat kopi, jaga budget, dan    │
│  temukan menu favoritmu.         │
│                                  │
│                                  │
│          [ Loading ... ]         │
│                                  │
│                                  │
└──────────────────────────────────┘
```

## Elemen

- logo aplikasi;
- nama aplikasi;
- tagline;
- indikator loading.

## Perilaku

- tampil 1–2 detik;
- memeriksa status login;
- pengguna login diarahkan ke Home;
- pengguna baru diarahkan ke Onboarding.

---

# 5.2 Onboarding — Halaman 1

## Fokus

Pencatatan pengeluaran kopi.

```text
┌──────────────────────────────────┐
│                          [Lewati]│
│                                  │
│           ▣ ILUSTRASI            │
│        Kopi + Dompet Digital     │
│                                  │
│      Catat Pengeluaran Kopi      │
│                                  │
│  Simpan setiap pembelian kopi    │
│  agar pengeluaran tetap terkendali.│
│                                  │
│             ● ○ ○                │
│                                  │
│          [ Selanjutnya ]         │
└──────────────────────────────────┘
```

---

# 5.3 Onboarding — Halaman 2

## Fokus

Pencarian coffeeshop terdekat.

```text
┌──────────────────────────────────┐
│                          [Lewati]│
│                                  │
│           ▣ ILUSTRASI            │
│         Peta + Pin Kedai         │
│                                  │
│       Temukan Kedai Terdekat     │
│                                  │
│  Cari coffeeshop sesuai lokasi,  │
│  budget, mood, dan fasilitas.    │
│                                  │
│             ○ ● ○                │
│                                  │
│          [ Selanjutnya ]         │
└──────────────────────────────────┘
```

---

# 5.4 Onboarding — Halaman 3

## Fokus

Rekomendasi menu berbasis AI.

```text
┌──────────────────────────────────┐
│                                  │
│           ▣ ILUSTRASI            │
│       AI + Gelas Kopi Pilihan    │
│                                  │
│       Rekomendasi yang Personal  │
│                                  │
│  Isi preferensimu dan temukan    │
│  menu yang tersedia di dekatmu.  │
│                                  │
│             ○ ○ ●                │
│                                  │
│            [ Mulai ]             │
└──────────────────────────────────┘
```

---

# 5.5 Login

```text
┌──────────────────────────────────┐
│                                  │
│              ☕                  │
│                                  │
│         Selamat Datang           │
│  Masuk untuk melanjutkan         │
│                                  │
│ Email                            │
│ ┌──────────────────────────────┐ │
│ │ nama@email.com               │ │
│ └──────────────────────────────┘ │
│                                  │
│ Password                         │
│ ┌──────────────────────────────┐ │
│ │ •••••••••••              👁  │ │
│ └──────────────────────────────┘ │
│                     Lupa password?│
│                                  │
│            [ Masuk ]             │
│                                  │
│ ───────── atau ─────────         │
│                                  │
│      [ Masuk dengan Google ]     │
│                                  │
│ Belum punya akun? [Daftar]       │
└──────────────────────────────────┘
```

## Validasi

- email wajib valid;
- password wajib diisi;
- error tampil tepat di bawah field.

---

# 5.6 Register

```text
┌──────────────────────────────────┐
│ ‹ Kembali                        │
│                                  │
│          Buat Akun Baru          │
│                                  │
│ Nama                             │
│ ┌──────────────────────────────┐ │
│ │ Nama lengkap                 │ │
│ └──────────────────────────────┘ │
│                                  │
│ Email                            │
│ ┌──────────────────────────────┐ │
│ │ nama@email.com               │ │
│ └──────────────────────────────┘ │
│                                  │
│ Password                         │
│ ┌──────────────────────────────┐ │
│ │ •••••••••••              👁  │ │
│ └──────────────────────────────┘ │
│                                  │
│ Konfirmasi Password              │
│ ┌──────────────────────────────┐ │
│ │ •••••••••••              👁  │ │
│ └──────────────────────────────┘ │
│                                  │
│ [✓] Saya setuju dengan syarat    │
│                                  │
│            [ Daftar ]            │
└──────────────────────────────────┘
```

---

# 5.7 Pengaturan Budget Awal

## Tujuan

Mengatur target pengeluaran kopi setelah registrasi.

```text
┌──────────────────────────────────┐
│ Lewati                           │
│                                  │
│      Atur Budget Kopi Bulanan    │
│                                  │
│  Berapa batas pengeluaran kopi   │
│  yang ingin kamu jaga?           │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Rp 300.000                   │ │
│ └──────────────────────────────┘ │
│                                  │
│ Pilihan cepat                    │
│ [150rb] [300rb] [500rb] [Custom]│
│                                  │
│ Periode                          │
│ (●) Bulanan   (○) Mingguan       │
│                                  │
│ Pengingat budget                 │
│ [✓] Ingatkan saat mencapai 80%   │
│                                  │
│          [ Simpan Budget ]       │
└──────────────────────────────────┘
```

---

# 5.8 Home Dashboard

```text
┌──────────────────────────────────┐
│ Halo, Alfin 👋              🔔  ○ │
│ Jumat, 5 Juni 2026              │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Budget Kopi Bulan Ini        │ │
│ │ Rp180.000 / Rp300.000        │ │
│ │ ███████████░░░░ 60%          │ │
│ │ Sisa Rp120.000               │ │
│ └──────────────────────────────┘ │
│                                  │
│ Akses Cepat                      │
│ ┌──────────┐ ┌──────────┐       │
│ │    +     │ │    ▣     │       │
│ │ Tambah   │ │Scan Struk│       │
│ └──────────┘ └──────────┘       │
│ ┌──────────┐ ┌──────────┐       │
│ │    ⌖     │ │    ◇     │       │
│ │Cari Kedai│ │Rekomendasi│      │
│ └──────────┘ └──────────┘       │
│                                  │
│ Insight Minggu Ini               │
│ ┌──────────────────────────────┐ │
│ │ ✨ Pengeluaran turun 12%     │ │
│ │ dibanding minggu lalu.       │ │
│ └──────────────────────────────┘ │
│                                  │
│ Transaksi Terbaru       Lihat semua│
│ ┌──────────────────────────────┐ │
│ │ ☕ Iced Latte        Rp25.000│ │
│ │ Kopi Kita • Hari ini         │ │
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
└──────────────────────────────────┘
```

## Interaksi

- kartu budget membuka detail budget;
- shortcut membuka fitur terkait;
- transaksi terbaru membuka detail;
- bell membuka notifikasi.

---

# 5.9 Notifikasi

```text
┌──────────────────────────────────┐
│ ‹ Kembali      Notifikasi        │
│                                  │
│ Hari ini                         │
│ ┌──────────────────────────────┐ │
│ │ ⚠ Budget sudah mencapai 80% │ │
│ │ Sisa budget bulan ini Rp60rb │ │
│ │ 10 menit lalu                │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ☕ Menu favorit tersedia     │ │
│ │ Iced Latte tersedia kembali  │ │
│ │ 1 jam lalu                   │ │
│ └──────────────────────────────┘ │
│                                  │
│ Kemarin                          │
│ ┌──────────────────────────────┐ │
│ │ ⌖ Ada kedai baru dekatmu     │ │
│ │ Berjarak 650 meter           │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.10 Tambah Transaksi — Form Manual

```text
┌──────────────────────────────────┐
│ ‹ Kembali    Tambah Transaksi    │
│                                  │
│ Nama minuman                     │
│ ┌──────────────────────────────┐ │
│ │ Contoh: Iced Latte           │ │
│ └──────────────────────────────┘ │
│                                  │
│ Harga                            │
│ ┌──────────────────────────────┐ │
│ │ Rp 25.000                    │ │
│ └──────────────────────────────┘ │
│                                  │
│ Lokasi                           │
│ ┌──────────────────────────────┐ │
│ │ ⌖ Kopi Kita Nagoya          │ │
│ └──────────────────────────────┘ │
│ GPS Aktif • akurasi ±12 m        │
│                                  │
│ Tanggal & waktu                  │
│ ┌──────────────┐ ┌────────────┐ │
│ │ 05 Jun 2026 │ │ 15:30      │ │
│ └──────────────┘ └────────────┘ │
│                                  │
│ Kategori                         │
│ [Coffee] [Non-Coffee] [Food]    │
│                                  │
│ Catatan                          │
│ ┌──────────────────────────────┐ │
│ │ Kurang gula                  │ │
│ └──────────────────────────────┘ │
│                                  │
│        [ Simpan Transaksi ]      │
└──────────────────────────────────┘
```

## State Lokasi

- GPS aktif;
- lokasi terakhir diketahui;
- lokasi manual;
- tanpa lokasi.

---

# 5.11 Scan Struk — Kamera

```text
┌──────────────────────────────────┐
│ × Tutup          Scan Struk      │
│                                  │
│ ┌──────────────────────────────┐ │
│ │                              │ │
│ │      AREA PREVIEW KAMERA     │ │
│ │                              │ │
│ │   ┌──────────────────────┐   │ │
│ │   │  Arahkan struk ke    │   │ │
│ │   │  dalam bingkai       │   │ │
│ │   └──────────────────────┘   │ │
│ │                              │ │
│ └──────────────────────────────┘ │
│                                  │
│ Pastikan tulisan dan total harga │
│ terlihat jelas.                  │
│                                  │
│       [ Galeri ]   ( ● )         │
│                     Foto         │
└──────────────────────────────────┘
```

---

# 5.12 OCR Processing

```text
┌──────────────────────────────────┐
│                                  │
│                                  │
│              ◇                   │
│                                  │
│       Membaca struk kamu...      │
│                                  │
│  AI sedang mengambil nama menu,  │
│  harga, tanggal, dan lokasi.     │
│                                  │
│        ████████░░ 75%            │
│                                  │
│  Lokasi pendukung: Nagoya, Batam │
│                                  │
│            [ Batalkan ]          │
└──────────────────────────────────┘
```

---

# 5.13 Hasil OCR & Konfirmasi

```text
┌──────────────────────────────────┐
│ ‹ Kembali      Hasil Scan        │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Thumbnail Struk           │ │
│ └──────────────────────────────┘ │
│                                  │
│ Nama minuman                     │
│ ┌──────────────────────────────┐ │
│ │ Iced Caramel Latte           │ │
│ └──────────────────────────────┘ │
│                                  │
│ Harga                            │
│ ┌──────────────────────────────┐ │
│ │ Rp28.000                     │ │
│ └──────────────────────────────┘ │
│                                  │
│ Coffeeshop                       │
│ ┌──────────────────────────────┐ │
│ │ Kopi Kita Nagoya             │ │
│ └──────────────────────────────┘ │
│ Cocok dengan kedai 120 m darimu  │
│                                  │
│ Tanggal                          │
│ ┌──────────────────────────────┐ │
│ │ 05 Juni 2026                │ │
│ └──────────────────────────────┘ │
│                                  │
│ [ Scan Ulang ] [ Simpan ]        │
└──────────────────────────────────┘
```

---

# 5.14 Daftar Transaksi

```text
┌──────────────────────────────────┐
│ Transaksi                  ⌕  ⋮  │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Cari transaksi...           │ │
│ └──────────────────────────────┘ │
│                                  │
│ [Semua] [Minggu Ini] [Bulan Ini]│
│                                  │
│ Juni 2026            Rp180.000   │
│ ┌──────────────────────────────┐ │
│ │ ☕ Iced Latte        Rp25.000│ │
│ │ Kopi Kita • Hari ini         │ │
│ └──────────────────────────────┘ │
│ ┌──────────────────────────────┐ │
│ │ ☕ Americano         Rp18.000│ │
│ │ Point Coffee • Kemarin       │ │
│ └──────────────────────────────┘ │
│                                  │
│ Mei 2026             Rp320.000   │
│ ┌──────────────────────────────┐ │
│ │ ☕ Cappuccino        Rp30.000│ │
│ │ Coffee House • 29 Mei        │ │
│ └──────────────────────────────┘ │
│                                  │
│                  [ + ]           │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
└──────────────────────────────────┘
```

---

# 5.15 Detail Transaksi

```text
┌──────────────────────────────────┐
│ ‹ Kembali   Detail Transaksi  ⋮  │
│                                  │
│              ☕                  │
│       Iced Caramel Latte         │
│            Rp28.000              │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Coffeeshop                   │ │
│ │ Kopi Kita Nagoya            │ │
│ │                              │ │
│ │ Tanggal & Waktu              │ │
│ │ 05 Juni 2026 • 15:30        │ │
│ │                              │ │
│ │ Lokasi                       │ │
│ │ Nagoya, Batam               │ │
│ │                              │ │
│ │ Sumber                       │ │
│ │ OCR Scan                     │ │
│ └──────────────────────────────┘ │
│                                  │
│ Catatan                          │
│ Kurang gula                      │
│                                  │
│ [ Edit ]        [ Hapus ]        │
└──────────────────────────────────┘
```

---

# 5.16 Coffeeshop Finder — Permission Location

```text
┌──────────────────────────────────┐
│                                  │
│              ⌖                   │
│                                  │
│  Izinkan Akses Lokasi            │
│                                  │
│  Lokasi digunakan untuk mencari  │
│  coffeeshop dan menu terdekat.   │
│                                  │
│  Lokasi tidak dilacak terus-     │
│  menerus dan hanya digunakan     │
│  ketika fitur lokasi dibuka.     │
│                                  │
│       [ Izinkan Lokasi ]         │
│                                  │
│    [ Masukkan Lokasi Manual ]    │
│                                  │
│           Nanti Saja             │
└──────────────────────────────────┘
```

---

# 5.17 Coffeeshop Finder — List View

```text
┌──────────────────────────────────┐
│ Cari Kedai                 ⟳     │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ⌖ Kamu di: Nagoya, Batam    │ │
│ │ GPS Aktif • ±12 m           │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ⌕ Cari nama coffeeshop...   │ │
│ └──────────────────────────────┘ │
│                                  │
│ [Mood] [Budget] [Fasilitas] [Jarak]│
│                                  │
│ Radius: [500m] [1km] [3km] [5km]│
│                                  │
│ [ List ]              [ Map ]    │
│ Urutkan: Terdekat ▼              │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Kopi Kita Nagoya          │ │
│ │ ★4.7 • 650 m • Rp20–35rb    │ │
│ │ [Nyaman] [WiFi] [Buka]      │ │
│ │              [Lihat Kedai]  │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Coffee House              │ │
│ │ ★4.5 • 1,2 km • Rp18–30rb   │ │
│ │ [Tenang] [Outdoor]          │ │
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
└──────────────────────────────────┘
```

---

# 5.18 Coffeeshop Finder — Map View

```text
┌──────────────────────────────────┐
│ ‹ Kembali       Peta Kedai       │
│                                  │
│ ┌──────────────────────────────┐ │
│ │                              │ │
│ │          PETA                │ │
│ │     ⌖ User                   │ │
│ │   ● Kedai 1   ● Kedai 2      │ │
│ │           ● Kedai 3          │ │
│ │                              │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Kopi Kita Nagoya            │ │
│ │ ★4.7 • 650 m • Buka         │ │
│ │ Rp20–35rb                   │ │
│ │ [Lihat Detail] [Rute]        │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.19 Detail Coffeeshop

```text
┌──────────────────────────────────┐
│ ‹ Kembali                  ♡     │
│ ┌──────────────────────────────┐ │
│ │       FOTO COFFEESHOP        │ │
│ └──────────────────────────────┘ │
│                                  │
│ Kopi Kita Nagoya                 │
│ ★4.7 • 650 m • Buka sampai 22:00 │
│ Rp20.000–Rp35.000                │
│                                  │
│ [Rute] [Rekomendasi Menu] [Catat]│
│                                  │
│ Fasilitas                        │
│ [WiFi] [AC] [Outdoor] [Colokan] │
│                                  │
│ Tentang Kedai                    │
│ Tempat nyaman untuk bekerja dan  │
│ menikmati menu kopi susu.        │
│                                  │
│ Menu Populer                     │
│ ┌──────────────────────────────┐ │
│ │ ☕ Iced Latte       Rp25.000│ │
│ │ Tersedia                    │ │
│ └──────────────────────────────┘ │
│ ┌──────────────────────────────┐ │
│ │ ☕ Americano        Rp18.000│ │
│ │ Kemungkinan tersedia        │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.20 Rekomendasi — Pilih Mode

```text
┌──────────────────────────────────┐
│ Rekomendasi Menu                 │
│                                  │
│ Temukan kopi yang cocok untukmu  │
│ berdasarkan rasa, budget, dan    │
│ lokasi.                          │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ◇ Rekomendasi Cepat         │ │
│ │ Berdasarkan riwayat dan      │ │
│ │ preferensi kamu.             │ │
│ │                [Mulai]       │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ☕ Cari Menu Sendiri         │ │
│ │ Isi rasa, suhu, susu, budget,│ │
│ │ dan radius pencarian.        │ │
│ │                [Isi Pilihan] │ │
│ └──────────────────────────────┘ │
│                                  │
│ Rekomendasi terakhir             │
│ Iced Latte • 92% cocok           │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
└──────────────────────────────────┘
```

---

# 5.21 Guided Menu Search — Langkah 1

## Fokus

Jenis, rasa, dan suhu.

```text
┌──────────────────────────────────┐
│ ‹ Kembali     Cari Menu     1/3  │
│ ███████░░░░░░░░░░░░             │
│                                  │
│ Kopi seperti apa yang kamu mau?  │
│                                  │
│ Jenis minuman                    │
│ [Latte] [Americano] [Cappuccino]│
│ [Mocha] [Manual Brew] [Bebas]   │
│                                  │
│ Rasa yang kamu suka              │
│ [Creamy] [Pahit] [Manis]        │
│ [Fruity] [Nutty] [Chocolate]    │
│                                  │
│ Suhu                             │
│ (●) Dingin  (○) Panas  (○) Bebas│
│                                  │
│          [ Selanjutnya ]         │
└──────────────────────────────────┘
```

---

# 5.22 Guided Menu Search — Langkah 2

## Fokus

Kekuatan, susu, dan kemanisan.

```text
┌──────────────────────────────────┐
│ ‹ Kembali     Cari Menu     2/3  │
│ █████████████░░░░░░             │
│                                  │
│ Sesuaikan detail minumanmu       │
│                                  │
│ Kekuatan kopi                    │
│ (○) Ringan (●) Sedang (○) Kuat  │
│                                  │
│ Pilihan susu                     │
│ [Susu Biasa] [Tanpa Susu]       │
│ [Oat Milk] [Almond Milk]        │
│                                  │
│ Tingkat kemanisan                │
│ Tanpa gula ─────●───── Manis     │
│                                  │
│ Preferensi tambahan              │
│ [ ] Rendah kalori                │
│ [ ] Non-dairy                    │
│ [ ] Decaf                        │
│                                  │
│          [ Selanjutnya ]         │
└──────────────────────────────────┘
```

---

# 5.23 Guided Menu Search — Langkah 3

## Fokus

Konteks, budget, lokasi, dan radius.

```text
┌──────────────────────────────────┐
│ ‹ Kembali     Cari Menu     3/3  │
│ ████████████████████             │
│                                  │
│ Kamu ingin minum kopi untuk apa? │
│ [Fokus] [Santai] [Kerja]        │
│ [Begadang] [Nongkrong]          │
│                                  │
│ Budget maksimum                  │
│ ┌──────────────────────────────┐ │
│ │ Rp30.000                     │ │
│ └──────────────────────────────┘ │
│                                  │
│ Lokasi                           │
│ ┌──────────────────────────────┐ │
│ │ ⌖ Nagoya, Batam             │ │
│ └──────────────────────────────┘ │
│ GPS Aktif                        │
│                                  │
│ Radius                           │
│ [500m] [1km] [3km] [5km] [10km]│
│                                  │
│ [✓] Hanya kedai yang buka        │
│                                  │
│            [ Cari Menu ]         │
└──────────────────────────────────┘
```

---

# 5.24 Loading Rekomendasi

```text
┌──────────────────────────────────┐
│                                  │
│              ◇                   │
│                                  │
│    Mencarikan menu terbaik...    │
│                                  │
│  Mencocokkan rasa, budget, jarak,│
│  dan ketersediaan menu.          │
│                                  │
│      ○ Kopi Kita                 │
│      ○ Coffee House              │
│      ○ Point Coffee              │
│                                  │
│       ███████████░░ 82%          │
│                                  │
│            [ Batalkan ]          │
└──────────────────────────────────┘
```

---

# 5.25 Hasil Rekomendasi Menu

```text
┌──────────────────────────────────┐
│ ‹ Kembali    Hasil Rekomendasi   │
│                                  │
│ 8 menu ditemukan • radius 3 km   │
│ [Ubah Filter] [Urutkan ▼]        │
│                                  │
│ Pilihan Terbaik                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Iced Caramel Latte        │ │
│ │ Kopi Kita Nagoya            │ │
│ │ Rp28.000 • 1,2 km           │ │
│ │ [92% cocok] [Tersedia]      │ │
│ │                              │ │
│ │ Creamy, dingin, sedikit     │ │
│ │ manis, dan sesuai budget.   │ │
│ │                              │ │
│ │ [Detail] [Maps] [Simpan ♡]  │ │
│ └──────────────────────────────┘ │
│                                  │
│ Rekomendasi Lain                 │
│ ┌──────────────────────────────┐ │
│ │ Iced Café Latte • 88%       │ │
│ │ Coffee House • Rp25.000     │ │
│ │ Kemungkinan tersedia        │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.26 Detail Menu Rekomendasi

```text
┌──────────────────────────────────┐
│ ‹ Kembali                  ♡     │
│ ┌──────────────────────────────┐ │
│ │         FOTO MENU            │ │
│ └──────────────────────────────┘ │
│                                  │
│ Iced Caramel Latte               │
│ Kopi Kita Nagoya                 │
│ Rp28.000                         │
│                                  │
│ [92% cocok] [Tersedia]           │
│ Diperbarui 20 menit lalu         │
│                                  │
│ Kenapa cocok untukmu?            │
│ • rasa creamy                    │
│ • dingin                         │
│ • kafein sedang                  │
│ • sesuai budget Rp30.000         │
│                                  │
│ Detail Menu                      │
│ Susu biasa • manis ringan        │
│ Kafein sedang • 320 ml           │
│                                  │
│ [ Buka Maps ]                    │
│ [ Catat sebagai Pembelian ]      │
└──────────────────────────────────┘
```

---

# 5.27 Empty State Rekomendasi

```text
┌──────────────────────────────────┐
│ ‹ Kembali    Hasil Rekomendasi   │
│                                  │
│             ▣                    │
│                                  │
│   Belum ada menu yang sesuai     │
│                                  │
│ Tidak ditemukan menu di bawah    │
│ Rp20.000 dalam radius 1 km.      │
│                                  │
│         [ Perluas ke 3 km ]      │
│         [ Naikkan Budget ]       │
│         [ Izinkan Menu Serupa ]  │
│         [ Ubah Preferensi ]      │
│                                  │
│ Alternatif terdekat              │
│ Iced Americano • Rp22.000        │
│ Berjarak 700 meter               │
└──────────────────────────────────┘
```

---

# 5.28 Favorites

```text
┌──────────────────────────────────┐
│ Favorit                          │
│                                  │
│ [ Menu ] [ Coffeeshop ]          │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Iced Caramel Latte        │ │
│ │ Kopi Kita Nagoya            │ │
│ │ Rp28.000 • Tersedia         │ │
│ │                       ♥      │ │
│ └──────────────────────────────┘ │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ ▣ Cappuccino                │ │
│ │ Coffee House                │ │
│ │ Rp30.000 • Belum diverifikasi│ │
│ │                       ♥      │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.29 Statistik

```text
┌──────────────────────────────────┐
│ Statistik                        │
│                                  │
│ Periode: Juni 2026 ▼             │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Total Pengeluaran           │ │
│ │ Rp180.000                   │ │
│ │ ↓ 12% dari bulan lalu       │ │
│ └──────────────────────────────┘ │
│                                  │
│ Pengeluaran Mingguan             │
│ ┌──────────────────────────────┐ │
│ │         GRAFIK BATANG        │ │
│ │  ▂   ▅   ▃   █              │ │
│ └──────────────────────────────┘ │
│                                  │
│ Menu Paling Sering               │
│ 1. Iced Latte           5 kali   │
│ 2. Americano            3 kali   │
│                                  │
│ Insight AI                       │
│ ┌──────────────────────────────┐ │
│ │ ✨ Kamu paling sering membeli│ │
│ │ kopi pada Jumat sore.        │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

---

# 5.30 Detail Budget

```text
┌──────────────────────────────────┐
│ ‹ Kembali      Budget Kopi       │
│                                  │
│ Budget Juni                      │
│ Rp300.000                         │
│                                  │
│ Terpakai                          │
│ Rp180.000                         │
│ ███████████░░░░ 60%              │
│                                  │
│ Sisa                              │
│ Rp120.000                         │
│                                  │
│ Rata-rata per hari                │
│ Rp6.000                           │
│                                  │
│ Prediksi akhir bulan              │
│ Rp282.000                         │
│                                  │
│ [ Ubah Budget ]                   │
│ [ Atur Pengingat ]                │
└──────────────────────────────────┘
```

---

# 5.31 Profil

```text
┌──────────────────────────────────┐
│ Profil                           │
│                                  │
│              ○                   │
│         Alfin Rifaldy            │
│      alfin.rifaldy08@gmail.com   │
│          [ Edit Profil ]         │
│                                  │
│ ┌──────────────────────────────┐ │
│ │ Budget Kopi                 ›│ │
│ ├──────────────────────────────┤ │
│ │ Preferensi Minuman          ›│ │
│ ├──────────────────────────────┤ │
│ │ Lokasi Default              ›│ │
│ ├──────────────────────────────┤ │
│ │ Favorit                     ›│ │
│ ├──────────────────────────────┤ │
│ │ Notifikasi                  ›│ │
│ ├──────────────────────────────┤ │
│ │ Privasi & Lokasi            ›│ │
│ ├──────────────────────────────┤ │
│ │ Bantuan                     ›│ │
│ └──────────────────────────────┘ │
│                                  │
│             [ Keluar ]           │
├──────────────────────────────────┤
│  ⌂       ▤       ⌖       ◇      ○ │
└──────────────────────────────────┘
```

---

# 5.32 Preferensi Minuman

```text
┌──────────────────────────────────┐
│ ‹ Kembali  Preferensi Minuman    │
│                                  │
│ Jenis favorit                    │
│ [✓] Latte                        │
│ [ ] Americano                    │
│ [✓] Cappuccino                   │
│ [ ] Manual Brew                  │
│                                  │
│ Profil rasa                      │
│ [Creamy] [Sedikit Manis] [Nutty]│
│                                  │
│ Susu favorit                     │
│ (●) Biasa  (○) Oat  (○) Tanpa   │
│                                  │
│ Preferensi kesehatan             │
│ [ ] Rendah kalori                │
│ [✓] Gula rendah                  │
│ [ ] Decaf                        │
│                                  │
│            [ Simpan ]            │
└──────────────────────────────────┘
```

---

# 5.33 Privasi & Lokasi

```text
┌──────────────────────────────────┐
│ ‹ Kembali     Privasi & Lokasi   │
│                                  │
│ Izin Lokasi                      │
│ ┌──────────────────────────────┐ │
│ │ Gunakan lokasi saat aplikasi│ │
│ │ aktif                   ON  │ │
│ └──────────────────────────────┘ │
│                                  │
│ Lokasi Default                   │
│ Nagoya, Batam               ›    │
│                                  │
│ Sumber Lokasi Saat Ini           │
│ GPS Aktif • akurasi ±12 m        │
│                                  │
│ Penyimpanan Data                 │
│ Koordinat hanya disimpan untuk   │
│ kebutuhan sesi dan cache singkat.│
│                                  │
│ [ Hapus Cache Lokasi ]           │
│ [ Buka Pengaturan Perangkat ]    │
└──────────────────────────────────┘
```

---

# 5.34 Edit Profil

```text
┌──────────────────────────────────┐
│ ‹ Kembali       Edit Profil      │
│                                  │
│              ○                   │
│          [ Ubah Foto ]           │
│                                  │
│ Nama                             │
│ ┌──────────────────────────────┐ │
│ │ Alfin Rifaldy               │ │
│ └──────────────────────────────┘ │
│                                  │
│ Email                            │
│ ┌──────────────────────────────┐ │
│ │ alfin.rifaldy08@gmail.com   │ │
│ └──────────────────────────────┘ │
│                                  │
│ Kota Default                     │
│ ┌──────────────────────────────┐ │
│ │ Batam                        │ │
│ └──────────────────────────────┘ │
│                                  │
│            [ Simpan ]            │
└──────────────────────────────────┘
```

---

# 6. State Tambahan

---

# 6.1 Loading State Daftar Kedai

```text
┌──────────────────────────────┐
│ ███████████████░░░░          │
│ ██████████░░░░░░░░           │
│ [████] [████] [████]         │
└──────────────────────────────┘
```

Gunakan skeleton card agar pengguna memahami bahwa data sedang dimuat.

---

# 6.2 GPS Error State

```text
┌──────────────────────────────────┐
│             ⌖                    │
│                                  │
│ Lokasi tidak terdeteksi          │
│                                  │
│ Aktifkan GPS atau masukkan       │
│ lokasi secara manual.            │
│                                  │
│       [ Coba Lagi ]              │
│ [ Masukkan Lokasi Manual ]       │
└──────────────────────────────────┘
```

---

# 6.3 Offline State

```text
┌──────────────────────────────────┐
│             ☁                    │
│                                  │
│ Kamu sedang offline              │
│                                  │
│ Transaksi tersimpan secara lokal.│
│ Beberapa hasil kedai menggunakan │
│ data cache terakhir.             │
│                                  │
│          [ Coba Lagi ]           │
└──────────────────────────────────┘
```

---

# 6.4 Error Umum

```text
┌──────────────────────────────────┐
│             !                    │
│                                  │
│ Terjadi kesalahan                │
│                                  │
│ Kami belum dapat memuat data.    │
│ Silakan coba beberapa saat lagi. │
│                                  │
│          [ Coba Lagi ]           │
└──────────────────────────────────┘
```

---

# 7. Alur Navigasi Detail

## 7.1 Alur Transaksi Manual

```text
Home
  ↓
Tambah Transaksi
  ↓
Isi Form
  ↓
Simpan
  ↓
Success Feedback
  ↓
Detail Transaksi / Home
```

## 7.2 Alur OCR

```text
Home
  ↓
Scan Struk
  ↓
Ambil Foto
  ↓
OCR Processing
  ↓
Konfirmasi Hasil
  ↓
Simpan Transaksi
```

## 7.3 Alur Coffeeshop Finder

```text
Home / Bottom Navigation
  ↓
Coffeeshop Finder
  ↓
Permission Lokasi
  ↓
List atau Map
  ↓
Detail Coffeeshop
  ├── Buka Maps
  ├── Catat Kunjungan
  └── Rekomendasi Menu
```

## 7.4 Alur Guided Recommendation

```text
Rekomendasi
  ↓
Cari Menu Sendiri
  ↓
Langkah 1: Jenis, Rasa, Suhu
  ↓
Langkah 2: Kekuatan, Susu, Gula
  ↓
Langkah 3: Konteks, Budget, Lokasi
  ↓
Hard Filtering
  ↓
AI Ranking
  ↓
Hasil Rekomendasi
  ↓
Detail Menu
  ├── Buka Maps
  ├── Simpan Favorit
  └── Catat Pembelian
```

---

# 8. Prioritas Implementasi

## Priority 0

Halaman yang harus tersedia pada MVP:

1. Splash
2. Login/Register
3. Home Dashboard
4. Tambah Transaksi
5. Daftar Transaksi
6. Detail Transaksi
7. OCR Scan
8. Hasil OCR
9. Budget
10. Profil dasar

## Priority 1

1. Coffeeshop Finder
2. Detail Coffeeshop
3. Menu Recommendation
4. Guided Search
5. Hasil Rekomendasi
6. Detail Menu
7. Favorites
8. Statistik
9. Permission dan fallback lokasi

## Priority 2

1. Notifikasi pintar
2. Integrasi partner/POS
3. Status stok real-time
4. Personalisasi AI lanjutan
5. Gamification penghematan

---

# 9. Catatan Handoff ke UI Designer

UI designer perlu mempertahankan:

- cream sebagai background utama;
- brown sebagai warna CTA dan elemen utama;
- card dengan sudut membulat;
- tampilan hangat dan premium;
- hierarki informasi yang jelas;
- status ketersediaan yang transparan;
- alasan rekomendasi yang mudah dipahami;
- akses lokasi yang tetap memberi kontrol kepada pengguna.

---

# 10. Catatan Handoff ke Flutter Developer

Komponen yang sebaiknya dibuat reusable:

- `CoffeeAppBar`
- `CoffeeBottomNavigation`
- `PrimaryButton`
- `SecondaryButton`
- `CoffeeTextField`
- `FilterChipGroup`
- `BudgetSummaryCard`
- `TransactionCard`
- `CoffeeshopCard`
- `RecommendationCard`
- `AvailabilityBadge`
- `LocationStatusBadge`
- `EmptyStateView`
- `ErrorStateView`
- `LoadingSkeleton`
- `StepProgressHeader`
- `PriceInputField`
- `RadiusSelector`

State management utama:

- authentication state;
- user profile state;
- transaction state;
- budget state;
- GPS/location state;
- coffeeshop finder state;
- recommendation form state;
- recommendation result state;
- OCR processing state.

---

# 11. Ringkasan

Wireframe ini mencakup alur utama Coffee Budget Tracker mulai dari onboarding, pencatatan transaksi, OCR, pencarian coffeeshop, rekomendasi menu, statistik, hingga pengaturan privasi lokasi.

Struktur dirancang agar:

- mudah dipahami pengguna baru;
- cepat digunakan untuk pencatatan harian;
- mendukung fitur lokasi secara transparan;
- mendukung rekomendasi menu berbasis preferensi;
- konsisten dengan tema cream dan roasted brown.
