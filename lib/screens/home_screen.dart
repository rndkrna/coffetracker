import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../helpers/auth_helper.dart';
import '../theme/app_theme.dart';
import '../app/constants/app_routes.dart';
import '../core/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _userName = 'User';

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
      });
    }
  }

  String formatRupiah(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(transactionProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
            slivers: [
              // Custom App Bar / Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hai, $_userName',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          Text(
                            'Waktunya kopi, tapi tetap hemat!',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.notifications),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.notifications_outlined, size: 22, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Total Bulan Ini Card (Figma Style)
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.budget),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2E6D8), // Light tan background from Figma
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(150),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.primary),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Total Bulan Ini',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  formatRupiah(provider.monthlyTotal),
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryDark,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (provider.monthlyBudget > 0)
                                  Text(
                                    ' / ${formatRupiah(provider.monthlyBudget)}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            
                            if (provider.monthlyBudget > 0) ...[
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (provider.monthlyBudgetPercentage / 100).clamp(0.0, 1.0),
                                  minHeight: 8,
                                  backgroundColor: Colors.white.withAlpha(150),
                                  color: provider.monthlyBudgetPercentage >= 100 
                                        ? AppColors.danger 
                                        : (provider.monthlyBudgetPercentage >= 80 ? AppColors.warning : AppColors.primary),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${provider.monthlyBudgetPercentage.toStringAsFixed(0)}% dari anggaran terpakai',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Sisa: ${formatRupiah(provider.monthlyBudget - provider.monthlyTotal > 0 ? provider.monthlyBudget - provider.monthlyTotal : 0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Akses Cepat
                    Text(
                      'Akses Cepat',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildShortcutCard(
                            context: context,
                            icon: Icons.add_rounded,
                            label: 'Tambah',
                            color: AppColors.primary,
                            onTap: () => context.push(AppRoutes.addTransaction),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildShortcutCard(
                            context: context,
                            icon: Icons.document_scanner_rounded,
                            label: 'Scan Struk',
                            color: AppColors.secondary,
                            onTap: () => context.push(AppRoutes.ocrScan),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildShortcutCard(
                            context: context,
                            icon: Icons.location_on_rounded,
                            label: 'Cari Kedai',
                            color: AppColors.matchaSoft,
                            onTap: () => context.go(AppRoutes.finder),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildShortcutCard(
                            context: context,
                            icon: Icons.auto_awesome_rounded,
                            label: 'Rekomendasi',
                            color: AppColors.caramel,
                            onTap: () => context.go(AppRoutes.recommendations),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Insight Minggu Ini
                    Text(
                      'Insight Minggu Ini',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInsightCard(provider),
                    const SizedBox(height: 24),

                    // Transaksi Terakhir Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaksi Terakhir',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.transactions);
                          },
                          child: Text(
                            'Lihat Semua',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // List Transaksi Terakhir (Figma Style using TransactionCard)
                    ...provider.transactions.take(5).map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TransactionCard(
                              coffeeName: t.coffeeName,
                              price: t.price,
                              date: t.date,
                              location: t.location,
                              category: t.category,
                              source: t.source.name,
                              onTap: () {
                                context.push('${AppRoutes.transactionDetail}/${t.id}');
                              },
                            ),
                          ),
                        ),

                    if (provider.transactions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.coffee_outlined,
                                size: 64,
                                color: AppColors.textSecondary.withAlpha(80)),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada transaksi\nTekan + untuk menambahkan',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    const SizedBox(height: 80), // Padding for FAB
                  ]),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildShortcutCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(TransactionState provider) {
    final weekly = provider.weeklyTotal;
    final lastWeekly = provider.lastWeekTotal;
    String insightText = 'Amankan budget bulananmu dengan memantau transaksi harian.';
    bool isPositive = true;

    if (lastWeekly > 0) {
      final diff = weekly - lastWeekly;
      final pct = (diff / lastWeekly * 100).abs();
      if (diff > 0) {
        insightText = 'Pengeluaran kopi kamu naik ${pct.toStringAsFixed(0)}% dibanding minggu lalu. Yuk kurangi tipis-tipis!';
        isPositive = false;
      } else if (diff < 0) {
        insightText = 'Mantap! Pengeluaran kopi turun ${pct.toStringAsFixed(0)}% dibanding minggu lalu. Pertahankan hematmu!';
        isPositive = true;
      } else {
        insightText = 'Pengeluaran kopi kamu sama dengan minggu lalu. Tetap stabil ya!';
        isPositive = true;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPositive 
            ? AppColors.success.withValues(alpha: 0.1) 
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPositive 
              ? AppColors.success.withValues(alpha: 0.3) 
              : AppColors.error.withValues(alpha: 0.3)
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.stars_rounded : Icons.info_outline_rounded,
            color: isPositive ? AppColors.success : AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insightText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
