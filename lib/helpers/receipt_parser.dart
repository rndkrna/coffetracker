import 'package:flutter/foundation.dart';

/// Helper class untuk parsing teks hasil OCR dari struk belanjaan.
/// Hanya mendeteksi item MENU (makanan/minuman) dan harganya.
/// Mengabaikan subtotal, pajak, total, pembayaran, dll.
class ReceiptParser {
  /// Daftar kata kunci menu yang pasti valid (Whitelist)
  static final List<String> _menuKeywords = [
    // Kopi
    'kopi', 'coffee', 'latte', 'espresso', 'cappuccino', 'capucino',
    'americano', 'machiato', 'macchiato', 'aren', 'v60', 'manual brew',
    'flat white', 'mocha', 'mochaccino', 'cold brew', 'affogato',
    'frappe', 'frappuccino',
    // Minuman lain
    'teh', 'tea', 'milk', 'susu', 'chocolate', 'cokelat', 'choco',
    'lemonade', 'juice', 'jus', 'smoothie', 'matcha', 'milkshake',
    // Roti & Pastry
    'roti', 'bread', 'wafel', 'waffle', 'croissant', 'cake', 'pudding',
    'pastry', 'bolu', 'donut', 'donat', 'toast', 'sandwich', 'pie',
    // Makanan
    'nasi', 'mie', 'indomie', 'ayam', 'burger', 'pasta', 'kentang', 'fries',
    'goreng', 'bakar', 'rebus', 'panggang', 'tumis', 'soto', 'sop',
    'pisang', 'tahu', 'tempe', 'mendoan', 'bakso', 'meatball',
    'rice', 'chicken', 'beef', 'fish', 'ikan', 'udang', 'shrimp',
    // Cemilan
    'snack', 'cireng', 'rujak', 'dimsum', 'siomay', 'keripik',
    // Kata kunci umum di menu
    'ice', 'iced', 'hot', 'panas', 'dingin', 'regular', 'large',
    'custom', 'extra', 'shot',
  ];

  /// Parse teks OCR menjadi list item menu yang terdeteksi
  /// Menggunakan pendekatan dual-pass karena OCR sering memisahkan
  /// nama menu (kolom kiri) dan harga (kolom kanan) ke baris berbeda.
  static List<ParsedReceiptItem> parseReceipt(String rawText) {
    final items = <ParsedReceiptItem>[];
    final lines = rawText.split('\n');

    // DEBUG: Tampilkan teks mentah dari OCR di terminal
    debugPrint('=== RAW OCR TEXT ===');
    debugPrint(rawText);
    debugPrint('=== END RAW OCR TEXT ===');
    debugPrint('Total lines: ${lines.length}');

    // Kumpulkan nama menu dan harga secara terpisah
    final List<String> menuNames = [];
    final List<int> prices = [];
    final Set<int> usedLineIndices = {};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final lower = line.toLowerCase();

      // SKIP baris yang jelas bukan menu
      if (lower.startsWith('total') || lower.startsWith('subtotal') ||
          lower.startsWith('grand total') || lower.startsWith('sub total')) {
        debugPrint('[SKIP TOTAL] Line $i: "$line"');
        continue;
      }
      if (_shouldSkipLine(line)) {
        debugPrint('[SKIP] Line $i: "$line"');
        continue;
      }
      if (line.startsWith('+') || line.startsWith('> ')) {
        debugPrint('[SKIP ADDON] Line $i: "$line"');
        continue;
      }

      // Cek apakah baris ini punya harga
      final price = _extractPrice(line);
      final extractedName = _extractItemName(line);

      if (price != null && extractedName.isNotEmpty && _isMenuItem(extractedName)) {
        // CASE 1: Nama + Harga dalam satu baris (ideal)
        debugPrint('[FULL MATCH] Line $i: "$extractedName" => Rp $price');
        items.add(ParsedReceiptItem(
          name: _cleanItemName(extractedName),
          price: price,
          category: _detectCategory(extractedName),
        ));
        usedLineIndices.add(i);
      } else if (price != null && (extractedName.isEmpty || !_isMenuItem(extractedName))) {
        // CASE 2: Baris berisi harga tapi nama kosong/invalid
        // Coba cari nama dari baris sebelumnya (backward search)
        String foundName = '';
        for (int prevIdx = i - 1; prevIdx >= 0; prevIdx--) {
          if (usedLineIndices.contains(prevIdx)) continue;
          final prevLine = lines[prevIdx].trim();
          if (prevLine.isEmpty) continue;
          if (prevLine.startsWith('+') || prevLine.startsWith('> ')) continue;
          if (_shouldSkipLine(prevLine)) continue;
          if (prevLine.toLowerCase().startsWith('total')) continue;

          final cleanPrev = _extractItemName(prevLine);
          final nameToCheck = cleanPrev.isNotEmpty ? cleanPrev : prevLine;
          if (_isMenuItem(nameToCheck)) {
            foundName = nameToCheck;
            usedLineIndices.add(prevIdx);
            break;
          }
        }

        if (foundName.isNotEmpty) {
          debugPrint('[PAIRED] "$foundName" => Rp $price');
          items.add(ParsedReceiptItem(
            name: _cleanItemName(foundName),
            price: price,
            category: _detectCategory(foundName),
          ));
          usedLineIndices.add(i);
        } else {
          // Simpan harga untuk dipasangkan di Pass 2
          debugPrint('[ORPHAN PRICE] Line $i: Rp $price');
          prices.add(price);
        }
      } else if (price == null && _hasMenuKeyword(line)) {
        // CASE 3: Baris hanya berisi nama menu (tanpa harga)
        // KETAT: hanya terima jika mengandung kata kunci whitelist
        if (!usedLineIndices.contains(i)) {
          debugPrint('[ORPHAN MENU] Line $i: "$line"');
          menuNames.add(line);
          usedLineIndices.add(i);
        }
      } else {
        debugPrint('[IGNORED] Line $i: "$line"');
      }
    }

    // ===== PASS 2: Pasangkan menu tanpa harga dengan harga tanpa menu =====
    // Ini menangani kasus OCR yang memisahkan kolom kiri (nama) dan kanan (harga)
    for (int j = 0; j < menuNames.length && j < prices.length; j++) {
      final name = menuNames[j];
      final price = prices[j];
      debugPrint('[LATE PAIR] "$name" => Rp $price');
      items.add(ParsedReceiptItem(
        name: _cleanItemName(name),
        price: price,
        category: _detectCategory(name),
      ));
    }

    debugPrint('=== TOTAL ITEMS DETECTED: ${items.length} ===');
    return items;
  }

  /// Cek apakah baris harus di-skip (BUKAN item menu)
  static bool _shouldSkipLine(String line) {
    final lower = line.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // Daftar keyword yang PASTI bukan menu item
    final skipKeywords = [
      // Total & Subtotal
      'subtotal', 'sub total', 'sub-total',
      'total tagihan', 'total bayar', 'total belanja',
      'total harga', 'total pesanan', 'total order',
      'grand total', 'nett total', 'total:', 'total ',
      // Pajak & Diskon
      'pajak', 'ppn', 'tax', 'pb1', 'service charge', 'service tax',
      'diskon', 'discount', 'promo', 'voucher', 'potongan',
      // Pembayaran
      'tunai', 'cash', 'kembalian', 'change', 'kembali',
      'pembayaran', 'payment', 'bayar', 'kartu',
      'debit', 'kredit', 'credit', 'edc', 'visa', 'mastercard',
      'qris', 'gopay', 'ovo', 'dana', 'shopeepay', 'linkaja',
      'bca', 'bni', 'bri', 'mandiri', 'cimb', 'permata',
      'transfer', 'e-wallet', 'ewallet', 'shopee',
      // Info struk
      'terima kasih', 'thank you', 'terimakasih', 'thanks',
      'kasir', 'cashier', 'operator', 'served by',
      'no. nota', 'no nota', 'no.nota', 'receipt',
      'tanggal', 'date', 'waktu', 'time', 'jam:',
      'nama order', 'jenis order', 'no urut', 'no. urut',
      'table', 'meja', 'pax', 'mode :', 'mode:', 
      'quick service', 'dine in', 'delivery',
      'member', 'poin', 'point', 'saldo',
      'terbayar', 'lunas', 'paid',
      'struk', 'nota', 'invoice',
      'free table',
      // Nama toko umum (agar tidak dianggap menu)
      'cafe', 'coffee dealer', 'warkop', 'warung', 'kedai',
      'resto', 'restaurant', 'rumah makan', 'kantin',
      'selamat', 'ibadah', 'puasa', 'ramadhan',
      // Info toko / Sosmed
      'jl.', 'jalan', 'kota', 'telp', 'tel.', 'phone', 'ruko ', 'blok ',
      'www.', 'http', '.com', '.id', 'instagram', 'ig:', 'follow',
      'facebook', 'fb:', 'twitter', 'visit', 'wifi', 'password',
      'takeaway', 'take away', 'grab', 'gofood', 'shopeefood',
      // Status & Header Struk
      'closed', 'check no', 'no. nota', 'nota no', 'copy', 'reprint',
      // Produk count
      'produk', 'items', 'qty',
    ];

    for (final kw in skipKeywords) {
      if (lower.contains(kw)) return true;
    }

    // Skip jika baris berisi jam (HH:mm) — hanya titik dua, bukan titik
    // Pastikan ada non-digit sebelumnya atau awal baris agar tidak match harga
    if (RegExp(r'(?:^|\s)\d{1,2}:\d{2}(?::\d{2})?(?:\s|$)').hasMatch(line)) return true;

    // Skip jika berisi tanggal (DD-MM-YYYY atau DD/MM/YYYY)
    if (RegExp(r'\d{1,2}[-/]\d{1,2}[-/]\d{2,4}').hasMatch(line)) return true;

    // Skip jika hanya angka/simbol, KECUALI jika terlihat seperti harga valid
    if (RegExp(r'^[\d\s\-=:.,/\\|*_@]+$').hasMatch(line)) {
      // Cek apakah ini harga valid (5.000 - 300.000) sebelum di-skip
      final priceCheck = line.replaceAll(RegExp(r'[\s.,]'), '');
      final numCheck = int.tryParse(priceCheck);
      if (numCheck != null && numCheck >= 5000 && numCheck <= 300000) {
        // Ini kemungkinan harga, jangan di-skip
        return false;
      }
      return true;
    }

    // Skip baris yang sangat pendek (< 3 karakter setelah hapus angka)
    final withoutNumbers = line.replaceAll(RegExp(r'[\d.,\s]'), '');
    if (withoutNumbers.length < 2) return true;

    return false;
  }

  /// Cek apakah teks mengandung kata kunci menu (whitelist) — KETAT
  /// Digunakan untuk validasi orphan menu (nama tanpa harga)
  static bool _hasMenuKeyword(String text) {
    if (text.isEmpty || text.length < 3) return false;
    final lower = text.toLowerCase();
    // Harus juga lolos _shouldSkipLine
    if (_shouldSkipLine(text)) return false;
    return _menuKeywords.any((kw) => lower.contains(kw));
  }

  /// Cek apakah nama adalah item menu yang valid
  static bool _isMenuItem(String name) {
    if (name.isEmpty || name.length < 3) return false;

    // KETAT: Semua item menu HARUS mengandung setidaknya satu kata kunci menu
    // Ini mencegah alamat, nama kasir, atau nama toko terbaca sebagai menu
    if (!_hasMenuKeyword(name)) return false;

    final lower = name.toLowerCase();

    // 2. CEK BLACKLIST (Kata kunci yang pasti bukan menu)
    final nonMenuWords = [
      'total', 'subtotal', 'pajak', 'tax', 'diskon', 'promo',
      'tunai', 'cash', 'kembalian', 'pembayaran',
      'terbayar', 'bayar', 'edc', 'kredit', 'debit', 'visa',
      'qris', 'produk', 'change', 'charge', 'item', 'qty',
      'terima kasih', 'thank you', 'follow', 'instagram', 'closed',
      'check no', 'no nota', 'no.nota', 'no. nota',
      'kasir', 'pos title', 'op:', 'rcpt#',
    ];

    for (final word in nonMenuWords) {
      if (lower.contains(word)) return false;
    }

    // 3. VALIDASI FORMAT (Pencegahan harga/angka jadi nama)
    if (RegExp(r'^[Rr][Pp]\.?\s*[\d.,\s]+$').hasMatch(name) ||
        RegExp(r'^[\d.,\s]+$').hasMatch(name)) {
      return false;
    }

    return true;
  }

  /// Ekstrak harga dari baris teks
  static int? _extractPrice(String line) {
    // Pattern: angka di akhir baris (harga biasanya di kanan)
    final patterns = [
      // Angka dengan titik/koma ribuan di akhir baris (toleran spasi): 32 . 000
      RegExp(r'(\d{1,3}(?:\s*[.,]\s*\d{3})+)\s*$'),
      // Angka >= 1000 murni di akhir baris
      RegExp(r'\s+(\d{4,})\s*$'),
      // Rp 32.000 atau Rp 32 , 000
      RegExp(r'[Rr][Pp]\.?\s*(\d{1,3}(?:\s*[.,]\s*\d{3})*)', caseSensitive: false),
      // IDR 32000
      RegExp(r'IDR\s*(\d{1,3}(?:\s*[.,]\s*\d{3})*)', caseSensitive: false),
      // @ 32.000
      RegExp(r'@\s*(\d{1,3}(?:\s*[.,]\s*\d{3})*)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final priceStr = match.group(1)!;
        // Hapus semua spasi, titik, dan koma untuk mendapatkan angka murni
        final cleaned = priceStr.replaceAll(RegExp(r'[\s.,]'), '');
        final price = int.tryParse(cleaned);
        // Harga menu masuk akal: Rp 5.000 - Rp 300.000
        if (price != null && price >= 5000 && price <= 300000) {
          return price;
        }
      }
    }
    return null;
  }

  /// Ekstrak nama item (hapus harga & qty dari baris)
  static String _extractItemName(String line) {
    String name = line;

    // Hapus harga dengan awalan Rp atau IDR (case insensitive)
    name = name.replaceAll(RegExp(r'[Rr][Pp]\.?\s*\d{1,3}(?:\s*[.,]\s*\d{3})*', caseSensitive: false), '');
    name = name.replaceAll(RegExp(r'IDR\s*\d{1,3}(?:\s*[.,]\s*\d{3})*', caseSensitive: false), '');
    
    // Hapus pattern "1 X @ 23.000" (toleran spasi)
    name = name.replaceAll(RegExp(r'\d+\s*[xX×]\s*@?\s*\d{1,3}(?:\s*[.,]\s*\d{3})*'), '');

    // Hapus harga murni di akhir baris (misal: 23 . 000)
    name = name.replaceAll(RegExp(r'\d{1,3}(?:\s*[.,]\s*\d{3})+\s*$'), '');
    name = name.replaceAll(RegExp(r'\s+\d{4,}\s*$'), '');
      // Hapus qty di depan: "1 Cappucino" → "Cappucino"
    name = name.replaceAll(RegExp(r'^\d+\s+'), '');
    
    // Hapus simbol-simbol sisa (termasuk @ yang sering ada di struk)
    name = name.replaceAll(RegExp(r'[:\-=|*#@]+'), ' ');
    
    // Hapus angka-angka sisa yang mencurigakan (seperti .000 dari "1 x 23.000")
    name = name.replaceAll(RegExp(r'\.?\d{3,}'), '');

    // Bersihkan multiple spaces
    name = name.replaceAll(RegExp(r'\s+'), ' ');

    return name.trim();
  }

  /// Bersihkan & capitalize nama item
  static String _cleanItemName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Deteksi kategori berdasarkan nama item
  static String _detectCategory(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('espresso')) return 'Espresso';
    if (lower.contains('latte') || lower.contains('latté')) return 'Latte';
    if (lower.contains('cappuccino') || lower.contains('capucino') || lower.contains('cappucino')) {
      return 'Cappuccino';
    }
    if (lower.contains('americano')) return 'Americano';
    if (lower.contains('machiato') || lower.contains('macchiato')) return 'Latte';
    if (lower.contains('kopi susu') || lower.contains('es kopi') ||
        lower.contains('coffee milk') || lower.contains('gula aren')) {
      return 'Kopi Susu';
    }
    if (lower.contains('v60') || lower.contains('manual brew') ||
        lower.contains('pour over') || lower.contains('tubruk')) {
      return 'Manual Brew';
    }
    if (lower.contains('frappuccino') || lower.contains('frappe') ||
        lower.contains('blended') || lower.contains('shake')) {
      return 'Frappuccino';
    }

    if (lower.contains('teh') || lower.contains('tea')) {
      return 'Teh';
    }

    if (lower.contains('nasi') || lower.contains('mie') || lower.contains('indomie') ||
        lower.contains('ayam') || lower.contains('burger') || lower.contains('pasta')) {
      return 'Makanan';
    }

    if (lower.contains('cireng') || lower.contains('rujak') || lower.contains('kentang') ||
        lower.contains('fries') || lower.contains('toast') || lower.contains('roti') ||
        lower.contains('snack') || lower.contains('pastry') || lower.contains('cake') ||
        lower.contains('wafel') || lower.contains('waffle') || lower.contains('croissant') ||
        lower.contains('bread') || lower.contains('pudding') || lower.contains('bolu')) {
      return 'Roti & Pastry';
    }

    return 'Lainnya';
  }
}

/// Model untuk item menu yang terdeteksi dari struk
class ParsedReceiptItem {
  String name;
  int price;
  String category;
  bool isSelected;

  ParsedReceiptItem({
    required this.name,
    required this.price,
    required this.category,
    this.isSelected = true,
  });
}
