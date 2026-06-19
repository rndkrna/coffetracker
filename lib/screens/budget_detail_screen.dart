import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../app/constants/app_colors.dart';
import '../app/constants/app_routes.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../core/widgets/widgets.dart';

class BudgetDetailScreen extends ConsumerWidget {
  const BudgetDetailScreen({super.key});

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  String _getMonthName() {
    final now = DateTime.now();
    return DateFormat('MMMM yyyy', 'id_ID').format(now);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(transactionProvider);
    final theme = Theme.of(context);

    // Calculate prediction metrics
    final now = DateTime.now();
    final daysPassed = now.day;
    final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final monthlyTotal = provider.monthlyTotal;
    
    final dailyAvg = daysPassed > 0 ? (monthlyTotal / daysPassed).round() : 0;
    final endOfMonthPrediction = daysPassed > 0 
        ? (dailyAvg * totalDaysInMonth)
        : 0;

    final remaining = provider.monthlyBudget - monthlyTotal;
    final displayRemaining = remaining > 0 ? remaining : 0;
    final percentage = provider.monthlyBudget > 0 
        ? (monthlyTotal / provider.monthlyBudget * 100) 
        : 0.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CoffeeAppBar(
        title: 'Detail Budget Kopi',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Text(
              'Periode ${_getMonthName()}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Card Budget Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Anggaran Bulanan',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatRupiah(provider.monthlyBudget),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: provider.monthlyBudget > 0 
                          ? (monthlyTotal / provider.monthlyBudget).clamp(0.0, 1.0) 
                          : 0.0,
                      minHeight: 12,
                      backgroundColor: AppColors.divider,
                      color: percentage >= 100 
                          ? AppColors.danger 
                          : (percentage >= 80 ? AppColors.warning : AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terpakai',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            formatRupiah(monthlyTotal),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Sisa',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            formatRupiah(displayRemaining),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: percentage >= 100 ? AppColors.danger : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Analytics Section
            Text(
              'Statistik Penggunaan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Rata-rata Harian',
                    value: formatRupiah(dailyAvg),
                    subtitle: 'Berdasarkan $daysPassed hari berlalu',
                    icon: Icons.analytics_outlined,
                    color: const Color(0xFFF0EEFF),
                    iconColor: const Color(0xFF7C6BEA),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Prediksi Akhir Bulan',
                    value: formatRupiah(endOfMonthPrediction),
                    subtitle: 'Sisa hari bulan ini: ${totalDaysInMonth - daysPassed} hari',
                    icon: Icons.trending_up_rounded,
                    color: const Color(0xFFFFF3E6),
                    iconColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // CTA Buttons
            PrimaryButton(
              label: 'Ubah Anggaran',
              onPressed: () => context.push(AppRoutes.editBudget),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Atur Pengingat Limit',
              icon: Icons.notifications_active_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengingat budget otomatis aktif pada batas 80% dan 100%'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
