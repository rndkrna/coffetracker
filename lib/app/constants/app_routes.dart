/// Daftar route constants — persiapan migrasi ke go_router.
/// Semua route string terpusat di sini agar tidak ada typo.
class AppRoutes {
  AppRoutes._();

  // ─── Auth & Setup ────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String setupBudget = '/setup-budget';

  // ─── Main (Bottom Nav shell) ─────────────────────────────────────────────
  static const String main = '/main';
  static const String home = '/home';
  static const String notifications = '/notifications';

  // ─── Transactions ────────────────────────────────────────────────────────
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit'; // + /:id
  static const String transactionDetail = '/transactions/detail'; // + /:id

  // ─── OCR ─────────────────────────────────────────────────────────────────
  static const String ocrScan = '/ocr/scan';
  static const String ocrResult = '/ocr/result';

  // ─── Coffeeshop Finder ───────────────────────────────────────────────────
  static const String finder = '/finder';
  static const String finderMap = '/finder/map';
  static const String coffeeshopDetail = '/coffeeshop'; // + /:id

  // ─── Recommendations ────────────────────────────────────────────────────
  static const String recommendations = '/recommendations';
  static const String guidedSearch = '/recommendations/guided';
  static const String recommendationResults = '/recommendations/results';
  static const String menuDetail = '/menu'; // + /:id

  // ─── Statistics ──────────────────────────────────────────────────────────
  static const String statistics = '/statistics';

  // ─── Favorites ───────────────────────────────────────────────────────────
  static const String favorites = '/favorites';

  // ─── Profile ─────────────────────────────────────────────────────────────
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String preferences = '/profile/preferences';
  static const String privacyLocation = '/profile/privacy-location';

  // ─── Budget ──────────────────────────────────────────────────────────────
  static const String budget = '/budget';
  static const String editBudget = '/budget/edit';

  // ─── Coffee Shop Management ──────────────────────────────────────────────
  static const String addShop = '/add-shop';

  // ─── Legacy aliases (kompatibilitas) ─────────────────────────────────────
  /// Alias lama: '/add' → [addTransaction]
  static const String legacyAdd = '/add';

  /// Alias lama: '/scan' → [ocrScan]
  static const String legacyScan = '/scan';

  /// Alias lama: '/recommendation' → [recommendations]
  static const String legacyRecommendation = '/recommendation';
}
