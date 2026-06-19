import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../helpers/auth_helper.dart';
import '../app/constants/app_routes.dart';
import '../theme/app_theme.dart';
import '../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _userName = 'User';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthHelper.instance.getCurrentUser();
    if (mounted) {
      setState(() {
        _userName = user['name'] ?? 'User';
        _userEmail = user['email'] ?? '';
      });
    }
  }

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(transactionProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              // Title
              Text(
                'Pengaturan',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kelola akun dan preferensi kamu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              // Profile Card
              InkWell(
                onTap: () => context.push(AppRoutes.editProfile),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6F4E37), Color(0xFF3C2415)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(60),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _userEmail,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: Colors.white70, size: 18),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Profil & Privasi Section
              _sectionTitle('Profil & Privasi'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.coffee_maker_rounded,
                iconBg: const Color(0xFFEFEBE9),
                iconColor: const Color(0xFF5D4037),
                title: 'Preferensi Minuman',
                subtitle: 'Atur suhu, jenis susu, dan rasa favorit',
                onTap: () => context.push(AppRoutes.preferences),
              ),
              const SizedBox(height: 10),
              _settingsTile(
                icon: Icons.security_rounded,
                iconBg: const Color(0xFFE8EAF6),
                iconColor: const Color(0xFF3F51B5),
                title: 'Privasi & Lokasi',
                subtitle: 'Kelola izin akses data kamu',
                onTap: () => context.push(AppRoutes.privacyLocation),
              ),

              const SizedBox(height: 24),

              // Budget Settings Section
              _sectionTitle('Pengaturan Budget'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.view_week_rounded,
                iconBg: const Color(0xFFFFF3E6),
                iconColor: AppColors.warning,
                title: 'Budget Mingguan',
                subtitle: provider.weeklyBudget > 0
                    ? formatRupiah(provider.weeklyBudget)
                    : 'Belum diatur',
                onTap: () => _showBudgetDialog(
                  context,
                  'Budget Mingguan',
                  provider.weeklyBudget,
                  (val) => ref.read(transactionProvider.notifier).setWeeklyBudget(val),
                ),
              ),
              const SizedBox(height: 10),
              _settingsTile(
                icon: Icons.calendar_month_rounded,
                iconBg: const Color(0xFFEDF7ED),
                iconColor: AppColors.success,
                title: 'Budget Bulanan',
                subtitle: provider.monthlyBudget > 0
                    ? formatRupiah(provider.monthlyBudget)
                    : 'Belum diatur',
                onTap: () => _showBudgetDialog(
                  context,
                  'Budget Bulanan',
                  provider.monthlyBudget,
                  (val) => ref.read(transactionProvider.notifier).setMonthlyBudget(val),
                ),
              ),

              const SizedBox(height: 24),

              // Appearance Section
              _sectionTitle('Tampilan'),
              const SizedBox(height: 10),

              Builder(
                builder: (context) {
                  final themeProv = ref.watch(themeProvider);
                  final isDark = themeProv == ThemeMode.dark;
                  return _settingsTile(
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconBg: isDark ? const Color(0xFF332A26) : const Color(0xFFFFF9C4),
                    iconColor: isDark ? Colors.amber : Colors.orange,
                    title: 'Mode Gelap',
                    subtitle: isDark ? 'Aktif' : 'Non-aktif',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(val),
                      activeThumbColor: AppColors.primary,
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Summary Section
              _sectionTitle('Ringkasan'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.receipt_long_rounded,
                iconBg: const Color(0xFFF0EEFF),
                iconColor: const Color(0xFF7C6BEA),
                title: 'Total Transaksi',
                subtitle: '${provider.transactions.length} transaksi',
                showChevron: false,
              ),
              const SizedBox(height: 10),
              _settingsTile(
                icon: Icons.account_balance_wallet_rounded,
                iconBg: const Color(0xFFE8F4FD),
                iconColor: const Color(0xFF4A90D9),
                title: 'Total Pengeluaran',
                subtitle: formatRupiah(
                    provider.transactions.fold(0, (sum, t) => sum + t.price)),
                showChevron: false,
              ),

              const SizedBox(height: 24),

              // Favorites Section
              _sectionTitle('Tersimpan'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.favorite_rounded,
                iconBg: const Color(0xFFFCE4EC),
                iconColor: const Color(0xFFE91E63),
                title: 'Menu & Kedai Favorit',
                subtitle: 'Kelola preferensi tersimpan kamu',
                onTap: () => context.push(AppRoutes.favorites),
              ),

              const SizedBox(height: 24),

              // App Info Section
              _sectionTitle('Tentang Aplikasi'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.info_outline_rounded,
                iconBg: AppColors.secondary,
                iconColor: AppColors.primary,
                title: 'Versi',
                subtitle: '1.0.0',
                showChevron: false,
              ),
              const SizedBox(height: 10),
              _settingsTile(
                icon: Icons.code_rounded,
                iconBg: AppColors.secondary,
                iconColor: AppColors.primary,
                title: 'Developer',
                subtitle: 'Coffee Budget Team',
                showChevron: false,
              ),

              const SizedBox(height: 24),

              // Export Data Section
              _sectionTitle('Data & Laporan'),
              const SizedBox(height: 10),

              _settingsTile(
                icon: Icons.file_download_rounded,
                iconBg: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00796B),
                title: 'Export ke CSV',
                subtitle: 'Download riwayat transaksi kamu',
                onTap: () async {
                  await ref.read(transactionProvider.notifier).exportToCSV();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Menyiapkan file laporan...')),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Actions
              // Clear Data
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showClearDataDialog(context, provider),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.danger, size: 20),
                  label: Text(
                    'Hapus Semua Data',
                    style: GoogleFonts.poppins(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: Text(
                    'Keluar dari Akun',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showChevron = true,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron && trailing == null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, String title, int currentValue,
      Function(int) onSave) {
    final controller =
        TextEditingController(text: currentValue > 0 ? currentValue.toString() : '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan jumlah budget',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                filled: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? 0;
              onSave(val);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, TransactionState provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            const SizedBox(width: 8),
            Text(
              'Hapus Semua Data?',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Semua transaksi akan dihapus permanen. Aksi ini tidak bisa dibatalkan.',
          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              for (var t in List.from(provider.transactions)) {
                await ref.read(transactionProvider.notifier).deleteTransaction(t.id);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Keluar dari Akun',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: Text(
          'Yakin ingin keluar dari akun?',
          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthHelper.instance.logout();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
