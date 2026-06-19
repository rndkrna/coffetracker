# Coffee Budget Tracker — Design System & UI Concept

**Versi:** 1.0  
**Basis:** Coffee Budget Tracker PRD v4.2  
**Platform:** Mobile App (Android & iOS)  
**Tema Visual:** Kopi — **Cream & Brown**  

---

## 1. Konsep Desain

Desain aplikasi **Coffee Budget Tracker** menggunakan tema visual kopi dengan kombinasi warna **cream** dan **coklat**, terinspirasi dari:

- **Cream** → warna biji kopi yang belum di-roasting / warna susu, latte, dan foam.
- **Brown** → warna biji kopi yang sudah di-roasting / espresso, roasted bean, dan bubuk kopi.

Tujuan desain ini adalah menciptakan tampilan yang:

- hangat,
- nyaman,
- premium tetapi tetap ramah,
- estetik seperti suasana coffeeshop,
- mudah dibaca,
- cocok untuk aplikasi pencatatan pengeluaran, pencarian coffeeshop, OCR struk, dan rekomendasi menu.

Aplikasi harus terasa seperti perpaduan antara:

- **budget tracker modern**,
- **coffee lifestyle app**, dan
- **smart recommendation assistant**.

---

## 2. Brand Personality

### 2.1 Karakter Brand

Coffee Budget Tracker harus terasa:

- **Warm** → nyaman, akrab, santai.
- **Smart** → modern, cerdas, berbasis AI.
- **Personal** → terasa seperti asisten kopi pribadi.
- **Elegant** → tidak terlalu ramai, rapi, dan premium.
- **Natural** → dekat dengan nuansa biji kopi, susu, kayu, dan cafe.

### 2.2 Keywords Visual

- warm
- creamy
- roasted
- minimal
- cozy
- premium
- earthy
- coffee-inspired

---

## 3. Arah Visual Utama

### 3.1 Gaya Umum

Gunakan pendekatan **modern mobile UI** dengan ciri:

- rounded corner,
- card-based layout,
- banyak whitespace,
- ikon simpel dan lembut,
- ilustrasi atau aksen kopi yang halus,
- warna dominan cream dan brown,
- highlight warna coklat tua untuk CTA utama,
- kesan lembut dan tidak terlalu kontras keras.

### 3.2 Suasana Antarmuka

Suasana UI harus seperti:

- masuk ke aplikasi finansial yang tetap terasa santai,
- seperti membuka menu digital coffeeshop premium,
- tidak terlalu formal seperti aplikasi bank,
- tidak terlalu playful seperti aplikasi anak-anak.

---

## 4. Palet Warna

Palet warna utama dibagi menjadi warna **base**, **primary**, **accent**, dan **status**.

### 4.1 Primary Coffee Palette

| Token | Warna | Hex | Fungsi |
| --- | --- | --- | --- |
| `coffee-cream-50` | Soft Cream | `#FAF5EE` | Background utama app |
| `coffee-cream-100` | Light Cream | `#F4E9DA` | Surface ringan / section block |
| `coffee-cream-200` | Warm Beige | `#EBD7BE` | Input background / chip nonaktif |
| `coffee-brown-300` | Latte Brown | `#C49A6C` | Accent lembut |
| `coffee-brown-500` | Roasted Brown | `#8B5E3C` | Primary brand color |
| `coffee-brown-700` | Espresso Brown | `#5C3A21` | Tombol utama / heading penting |
| `coffee-brown-900` | Dark Roast | `#3A2416` | Teks utama / ikon utama |
| `milk-foam` | Milk Foam | `#FFFDF9` | Card terang / modal |

### 4.2 Supporting Accent Palette

| Token | Warna | Hex | Fungsi |
| --- | --- | --- | --- |
| `caramel` | Caramel | `#B97A3D` | Badge harga / highlight |
| `matcha-soft` | Olive Soft | `#A8B18A` | Tag healthy / sugar free |
| `rose-mocha` | Dusty Rose | `#C88D7A` | Accent lembut sekunder |
| `mocha-gray` | Warm Gray | `#8A8178` | Secondary text |
| `linen` | Linen | `#F8F1E7` | Background alt |

### 4.3 Status Colors

| Status | Hex | Fungsi |
| --- | --- | --- |
| Success | `#7C9A62` | transaksi berhasil, menu tersedia |
| Warning | `#D1A054` | kemungkinan tersedia, lokasi jaringan |
| Error | `#B85C4A` | gagal, menu tidak tersedia |
| Info | `#7A8FA6` | informasi netral |

### 4.4 Rekomendasi Kombinasi Warna

- **Background App:** `#FAF5EE`
- **Card Surface:** `#FFFDF9`
- **Primary CTA:** `#5C3A21`
- **Primary CTA Text:** `#FFFFFF`
- **Secondary Button:** `#F4E9DA`
- **Main Text:** `#3A2416`
- **Secondary Text:** `#8A8178`
- **Divider:** `#E8DDCF`
- **Input Border:** `#DCCAB5`

---

## 5. Typography

### 5.1 Rekomendasi Font

Untuk nuansa modern dan elegan:

- **Heading:** `Playfair Display` atau `DM Serif Display`
- **Body UI:** `Poppins`, `Inter`, atau `Nunito Sans`

### 5.2 Sistem Tipografi

| Style | Ukuran | Weight | Kegunaan |
| --- | --- | --- | --- |
| Display Large | 32 | 700 | Judul hero / onboarding |
| Heading 1 | 24 | 700 | Judul halaman |
| Heading 2 | 20 | 600 | Section title |
| Heading 3 | 18 | 600 | Subsection |
| Body Large | 16 | 500 | Isi utama |
| Body Regular | 14 | 400 | Konten umum |
| Body Small | 12 | 400 | Label kecil |
| Caption | 11 | 400 | Status, helper text |
| Button | 14 | 600 | CTA |

### 5.3 Karakter Tipografi

- Heading boleh sedikit lebih elegan dan premium.
- Isi tetap harus sangat terbaca.
- Jangan gunakan terlalu banyak style font berbeda.
- Fokus pada readability karena ada data finansial dan fitur rekomendasi.

---

## 6. Spacing & Layout System

### 6.1 Grid Dasar

Gunakan sistem **8pt spacing**:

- 4 px → spacing sangat kecil
- 8 px → spacing mini
- 12 px → antar elemen kecil
- 16 px → padding standar
- 20 px → section kecil
- 24 px → section besar
- 32 px → jarak antar blok utama

### 6.2 Radius

| Komponen | Radius |
| --- | --- |
| Input | 14 px |
| Card kecil | 16 px |
| Card besar | 20 px |
| Button | 14 px |
| Modal / Bottom Sheet | 24 px |
| Floating action | 18 px |

### 6.3 Shadow

Gunakan bayangan lembut:

- blur ringan,
- opacity rendah,
- warna kecoklatan transparan.

Contoh:

- `rgba(92, 58, 33, 0.08)` untuk card shadow.
- Hindari shadow hitam pekat.

---

## 7. Komponen Dasar UI

### 7.1 App Bar

Karakter app bar:

- background cream atau milk foam,
- judul warna espresso brown,
- ikon sederhana warna brown gelap,
- bisa diberi subtitle lokasi kecil jika diperlukan.

Contoh penggunaan:

- Dashboard
- Coffeeshop Finder
- Rekomendasi Menu
- Riwayat Transaksi

### 7.2 Button System

#### Primary Button

- background: `#5C3A21`
- text: putih
- radius: 14 px
- style: solid, elegan

Contoh:

- Simpan Transaksi
- Cari Menu
- Scan Struk
- Buka Maps

#### Secondary Button

- background: `#F4E9DA`
- text: `#5C3A21`
- border opsional `#DCCAB5`

#### Ghost Button

- transparan
- text coklat tua
- dipakai untuk aksi sekunder

### 7.3 Input Field

Karakter input:

- background cream muda,
- border tipis beige,
- icon leading warna brown 500,
- focus ring brown 500.

Input digunakan untuk:

- nominal transaksi,
- lokasi,
- pencarian coffeeshop,
- filter menu,
- input manual area.

### 7.4 Card

Semua informasi utama sebaiknya berbasis card.

Jenis card:

1. **Transaction Card**
2. **Coffeeshop Card**
3. **Recommendation Card**
4. **Budget Summary Card**
5. **Menu Card**

Karakter card:

- surface putih-cream,
- sudut rounded,
- shadow halus,
- padding 16–20 px,
- icon / image kecil yang relevan.

### 7.5 Chip & Tag

Gunakan chip untuk:

- mood,
- budget,
- jarak,
- fasilitas,
- rasa,
- suhu,
- jenis minuman.

State chip:

- default → cream muda
- active → brown 500 dengan text putih atau cream
- outlined → beige border

### 7.6 Badge

Badge digunakan untuk:

- `Tersedia`
- `Kemungkinan tersedia`
- `Tidak tersedia`
- `GPS Aktif`
- `Perkiraan IP`
- `Favorite`
- `92% cocok`

Warna badge:

- tersedia → hijau olive soft
- kemungkinan → caramel / warning
- tidak tersedia → terracotta / error
- AI match → brown tua + cream text

---

## 8. Iconography

Gaya ikon:

- outline atau rounded,
- tidak terlalu tebal,
- konsisten,
- modern.

Ikon yang sering dipakai:

- coffee cup
- coffee bean
- map pin
- wallet
- receipt
- sparkles / AI
- bookmark
- search
- filter
- chart / stats
- home
- user

Jika ingin lebih khas, bisa pakai aksen **coffee bean icon** sebagai ornamen section atau empty state.

---

## 9. Ilustrasi & Visual Pendukung

### 9.1 Arah Ilustrasi

Ilustrasi sebaiknya:

- flat atau semi-flat,
- warna lembut,
- dominan cream, caramel, brown,
- bertema kopi, cup, beans, maps, receipt, finance,
- cocok untuk empty state dan onboarding.

### 9.2 Motif Visual

Motif yang bisa digunakan:

- biji kopi,
- lingkaran seperti noda kopi,
- bentuk foam latte,
- garis lengkung lembut,
- pattern biji kopi tipis di background section.

Gunakan secara halus, jangan sampai mengganggu keterbacaan.

---

## 10. Halaman Utama dan Konsep Desainnya

---

## 10.1 Splash / Onboarding

### Tujuan
Memperkenalkan aplikasi sebagai asisten kopi dan pengelola budget.

### Konsep Visual
- background cream lembut,
- ilustrasi cup kopi atau coffee bean,
- judul besar elegan,
- CTA coklat tua.

### Copy Contoh
**Track your coffee, find your favorite, and stay on budget.**

### Elemen
- logo
- headline
- subheadline
- ilustrasi kopi
- tombol mulai

---

## 10.2 Home Dashboard

### Tujuan
Memberi ringkasan kondisi budget kopi user.

### Komponen
- greeting user
- budget bulan ini
- total pengeluaran kopi
- transaksi terbaru
- shortcut fitur utama
- insight AI singkat

### Visual
- top section dengan card summary besar
- statistik dalam card cream
- highlight nominal memakai espresso brown
- accent kecil caramel untuk angka penting

### Shortcut utama
- Tambah Transaksi
- Scan Struk
- Cari Kedai
- Rekomendasi Menu

---

## 10.3 Tambah Transaksi

### Tujuan
Mencatat pembelian kopi dengan cepat.

### Komponen
- nama minuman
- harga
- lokasi
- tanggal
- metode input manual / OCR
- notes opsional

### Visual
- form bersih dan ringkas
- section field dipisahkan rapi
- tombol simpan jelas di bawah
- field lokasi bisa punya icon pin

---

## 10.4 OCR Scan Receipt

### Tujuan
Memudahkan user scan struk.

### Visual
- area kamera dominan,
- overlay lembut dengan frame scan,
- panel info hasil OCR,
- tombol konfirmasi hasil scan.

### Nuansa
- tetap hangat walau layar bersifat teknis,
- gunakan background panel cream.

---

## 10.5 Coffeeshop Finder

### Tujuan
Menemukan coffeeshop terdekat.

### Komponen
- location strip
- search bar
- filter chip
- radius selector
- list / map toggle
- result card

### Visual
- map dan list dibuat rapi,
- location strip diberi badge GPS,
- filter mood dan budget tampil seperti chip krem-coklat,
- result card menonjolkan nama kedai, jarak, harga estimasi, dan rating.

---

## 10.6 Menu Recommendation

### Tujuan
Membantu user menemukan menu yang cocok berdasarkan preferensi dan lokasi.

### Komponen
- mode selector: rekomendasi cepat / cari menu sendiri
- preference form
- radius picker
- open now toggle
- hasil rekomendasi
- alternatif jika tidak ada hasil pas

### Visual
Halaman ini harus menjadi salah satu layar paling menarik.

#### Arah visual:
- ada header hangat dengan copy personal,
- form ditata seperti step kecil yang mudah diisi,
- recommendation card dibuat premium,
- badge kecocokan terlihat jelas,
- status tersedia tampil transparan.

#### Struktur hasil rekomendasi:
- foto menu
- nama menu
- nama coffeeshop
- harga
- jarak
- status ketersediaan
- skor kecocokan
- alasan rekomendasi
- CTA buka maps / simpan / beli

### Highlight khusus
Badge **92% cocok** bisa memakai warna brown tua dengan text cream agar terasa premium.

---

## 10.7 Statistik / Insight

### Tujuan
Menampilkan pola pengeluaran kopi user.

### Visual
- chart dengan warna cream, latte brown, roasted brown,
- gunakan grafik yang clean,
- hindari warna terlalu ramai.

### Warna chart yang direkomendasikan
- bar 1 → `#8B5E3C`
- bar 2 → `#C49A6C`
- bar 3 → `#EBD7BE`
- line / highlight → `#5C3A21`

### Insight AI
Gunakan card kecil dengan ikon sparkles dan copy seperti:

> Minggu ini kamu lebih sering membeli menu dingin daripada kopi panas.

---

## 10.8 Favorites & Saved Menu

### Tujuan
Menyimpan kedai dan menu favorit.

### Visual
- gunakan tab switch: menu / kedai
- card simpel dan konsisten
- badge kecil untuk favorite

---

## 10.9 Profile & Settings

### Tujuan
Mengatur preferensi user dan pengaturan aplikasi.

### Komponen
- profil user
- budget bulanan kopi
- preferensi minuman
- lokasi default
- notifikasi
- privasi lokasi

### Visual
- clean,
- lebih banyak list tile,
- tetap pakai section card.

---

## 11. Bottom Navigation

Gunakan 4–5 menu utama:

1. Home
2. Transactions
3. Finder
4. Recommendations
5. Profile

### Style
- background cream / milk foam,
- active icon brown tua,
- inactive icon warm gray,
- indikator aktif lembut.

---

## 12. Design Token Ringkas

```json
{
  "colors": {
    "background": "#FAF5EE",
    "surface": "#FFFDF9",
    "primary": "#5C3A21",
    "secondary": "#8B5E3C",
    "accent": "#C49A6C",
    "textPrimary": "#3A2416",
    "textSecondary": "#8A8178",
    "border": "#DCCAB5",
    "success": "#7C9A62",
    "warning": "#D1A054",
    "error": "#B85C4A"
  },
  "radius": {
    "sm": 14,
    "md": 16,
    "lg": 20,
    "xl": 24
  },
  "spacing": {
    "xs": 4,
    "sm": 8,
    "md": 16,
    "lg": 24,
    "xl": 32
  }
}
```

---

## 13. Contoh Gaya Komponen

### 13.1 Recommendation Card Concept

**Struktur:**

- image menu di kiri / atas,
- nama menu tebal,
- nama kedai di bawah,
- harga menonjol,
- badge `92% cocok`,
- badge `Tersedia`,
- alasan rekomendasi,
- tombol aksi.

**Nuansa visual:**

- card cream,
- accent brown pada judul,
- chip kecil caramel dan olive,
- CTA kecil berwarna espresso.

### 13.2 Coffeeshop Card Concept

**Isi:**

- foto kedai,
- nama,
- jarak,
- estimasi harga,
- mood badge,
- rating,
- tombol map.

### 13.3 Budget Summary Card

**Isi:**

- total budget,
- total terpakai,
- sisa budget,
- progress bar.

**Warna:**
- background cream,
- progress base beige,
- filled progress roasted brown.

---

## 14. Motion & Interaction

### 14.1 Gaya Animasi

Gunakan animasi ringan:

- fade in,
- slide up,
- scale kecil pada card,
- micro-interaction saat chip dipilih,
- loading skeleton untuk hasil rekomendasi.

### 14.2 Prinsip Interaksi

- responsif,
- tidak terlalu banyak gerakan,
- fokus pada kejelasan,
- feedback visual harus halus.

Contoh:

- tombol ditekan → sedikit menggelap,
- chip aktif → berubah warna dari cream ke brown,
- hasil rekomendasi muncul → fade + slide ringan.

---

## 15. Accessibility

Agar tetap nyaman digunakan:

- kontras teks harus cukup,
- ukuran font minimum 14 untuk isi utama,
- tombol punya area sentuh cukup besar,
- jangan hanya mengandalkan warna untuk status,
- badge status harus punya label teks.

Contoh:

- jangan hanya badge hijau, tapi tulis **Tersedia**.
- jangan hanya badge kuning, tapi tulis **Kemungkinan tersedia**.

---

## 16. Kesimpulan Arah Desain

Desain Coffee Budget Tracker harus menghadirkan identitas yang:

- kuat secara tema kopi,
- hangat dan premium,
- modern untuk aplikasi mobile,
- nyaman dipakai sehari-hari,
- mendukung fitur pintar seperti OCR, Coffeeshop Finder, dan Menu Recommendation.

Kombinasi **cream** dan **brown** sangat cocok karena merepresentasikan:

- **biji kopi sebelum roasting** → lembut, natural, cream,
- **biji kopi setelah roasting** → kaya, dalam, coklat tua.

Dengan pendekatan ini, aplikasi akan terasa konsisten secara brand, estetis secara visual, dan relevan dengan fungsi utamanya.

---

