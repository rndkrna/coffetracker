/// String label dan copy terpusat
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Coffee Budget Tracker';
  static const String appTagline =
      'Catat kopi, jaga budget, dan temukan menu favoritmu.';

  // Onboarding
  static const String onboarding1Title = 'Catat Pengeluaran Kopi';
  static const String onboarding1Body =
      'Simpan setiap pembelian kopi agar pengeluaran tetap terkendali.';
  static const String onboarding2Title = 'Temukan Kedai Terdekat';
  static const String onboarding2Body =
      'Cari coffeeshop sesuai lokasi, budget, mood, dan fasilitas.';
  static const String onboarding3Title = 'Rekomendasi yang Personal';
  static const String onboarding3Body =
      'Isi preferensimu dan temukan menu yang tersedia di dekatmu.';

  // Auth
  static const String loginTitle = 'Selamat Datang';
  static const String loginSubtitle = 'Masuk untuk melanjutkan';
  static const String registerTitle = 'Buat Akun Baru';
  static const String emailHint = 'nama@email.com';
  static const String passwordHint = 'Kata sandi';
  static const String passwordConfirmHint = 'Ulangi kata sandi';
  static const String nameHint = 'Nama lengkap';
  static const String forgotPassword = 'Lupa password?';
  static const String loginButton = 'Masuk';
  static const String registerButton = 'Daftar';
  static const String orDivider = 'atau';
  static const String googleLogin = 'Masuk dengan Google';
  static const String googleRegister = 'Daftar dengan Google';
  static const String noAccount = 'Belum punya akun?';
  static const String hasAccount = 'Sudah punya akun?';
  static const String register = 'Daftar';
  static const String loginLink = 'Masuk';

  // Budget Setup
  static const String budgetSetupTitle = 'Atur Budget Kopi Bulanan';
  static const String budgetSetupBody =
      'Berapa batas pengeluaran kopi yang ingin kamu jaga?';

  // Home
  static const String homeGreetingPrefix = 'Halo, ';
  static const String homeBudgetTitle = 'Budget Kopi Bulan Ini';
  static const String homeRemaining = 'Sisa';
  static const String homeQuickAccess = 'Akses Cepat';
  static const String homeInsight = 'Insight Minggu Ini';
  static const String homeRecentTx = 'Transaksi Terbaru';
  static const String homeSeeAll = 'Lihat semua';

  // Shortcuts
  static const String shortcutAdd = 'Tambah';
  static const String shortcutScan = 'Scan Struk';
  static const String shortcutFinder = 'Cari Kedai';
  static const String shortcutReco = 'Rekomendasi';

  // Transactions
  static const String transactionTitle = 'Transaksi';
  static const String addTransactionTitle = 'Tambah Transaksi';
  static const String editTransactionTitle = 'Edit Transaksi';
  static const String saveTransaction = 'Simpan Transaksi';
  static const String deleteTransaction = 'Hapus Transaksi';
  static const String fieldDrinkName = 'Nama minuman';
  static const String fieldPrice = 'Harga';
  static const String fieldLocation = 'Lokasi';
  static const String fieldDate = 'Tanggal & waktu';
  static const String fieldCategory = 'Kategori';
  static const String fieldNote = 'Catatan';

  // OCR
  static const String scanTitle = 'Scan Struk';
  static const String scanInstruction = 'Arahkan struk ke dalam bingkai';
  static const String scanProcessing = 'Membaca struk kamu...';
  static const String scanResultTitle = 'Hasil Scan';
  static const String scanRescan = 'Scan Ulang';

  // Finder
  static const String finderTitle = 'Cari Kedai';
  static const String finderSearchHint = 'Cari nama coffeeshop...';
  static const String finderYouAreAt = 'Kamu di:';
  static const String finderListView = 'List';
  static const String finderMapView = 'Map';

  // Recommendation
  static const String recoTitle = 'Rekomendasi Menu';
  static const String recoHeroTitle = 'Temukan Kopi yang Cocok Untukmu';
  static const String recoQuick = 'Rekomendasi Cepat';
  static const String recoGuided = 'Cari Menu Sendiri';
  static const String recoQuickDesc =
      'Berdasarkan riwayat dan preferensi kamu.';
  static const String recoGuidedDesc =
      'Isi rasa, suhu, susu, budget, dan radius pencarian.';
  static const String recoSearchButton = 'Cari Menu';
  static const String recoStep1Title = 'Kopi seperti apa yang kamu mau?';
  static const String recoStep2Title = 'Sesuaikan detail minumanmu';
  static const String recoStep3Title = 'Kamu ingin minum kopi untuk apa?';

  // Availability
  static const String available = 'Tersedia';
  static const String likelyAvailable = 'Kemungkinan tersedia';
  static const String unavailable = 'Tidak tersedia';
  static const String unverified = 'Belum diverifikasi';

  // Favorites
  static const String favoritesTitle = 'Favorit';
  static const String favMenuTab = 'Menu';
  static const String favShopTab = 'Coffeeshop';

  // Statistics
  static const String statsTitle = 'Statistik';
  static const String statsTotalExpense = 'Total Pengeluaran';
  static const String statsWeeklyChart = 'Pengeluaran 7 Hari Terakhir';
  static const String statsByCategory = 'Pengeluaran per Kategori';

  // Profile
  static const String profileTitle = 'Profil';
  static const String editProfile = 'Edit Profil';
  static const String preferencesTitle = 'Preferensi Minuman';
  static const String privacyLocationTitle = 'Privasi & Lokasi';
  static const String logoutButton = 'Keluar dari Akun';
  static const String deleteAllData = 'Hapus Semua Data';

  // Bottom Nav
  static const String navHome = 'Home';
  static const String navTransactions = 'Transaksi';
  static const String navFinder = 'Cari Kedai';
  static const String navRecommendations = 'Rekomendasi';
  static const String navProfile = 'Profil';

  // Empty States
  static const String emptyTransactions = 'Belum ada transaksi';
  static const String emptyTransactionsSub =
      'Tekan + untuk mencatat pembelian kopi pertamamu.';
  static const String emptyRecommendations = 'Belum ada menu yang sesuai';
  static const String emptyFavorites = 'Belum ada favorit';
  static const String emptyFavoritesSub =
      'Simpan menu atau kedai yang kamu suka dari halaman detail.';

  // Errors
  static const String errorGeneral =
      'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorNetwork = 'Tidak ada koneksi internet.';
  static const String errorOffline = 'Kamu sedang offline.';
  static const String errorGps = 'Lokasi tidak terdeteksi.';
  static const String errorPermissionLocation =
      'Izin lokasi diperlukan untuk fitur ini.';

  // Validasi
  static const String validRequired = 'Wajib diisi';
  static const String validEmail = 'Format email tidak valid';
  static const String validPasswordMin = 'Password minimal 8 karakter';
  static const String validPasswordMatch = 'Password tidak cocok';
  static const String validPositiveNumber = 'Harus angka positif';

  // Common Actions
  static const String cancel = 'Batal';
  static const String save = 'Simpan';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String next = 'Selanjutnya';
  static const String back = 'Kembali';
  static const String skip = 'Lewati';
  static const String start = 'Mulai';
  static const String retry = 'Coba Lagi';
  static const String confirm = 'Konfirmasi';
  static const String openMaps = 'Buka Maps';
  static const String saveFavorite = 'Simpan';
  static const String recordPurchase = 'Catat sebagai Pembelian';
}
