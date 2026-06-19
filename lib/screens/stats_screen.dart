import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(transactionProvider);
    final categoryData = provider.categoryBreakdown;
    final totalCategory = categoryData.values.fold(0, (a, b) => a + b);

    return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Statistik',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Analisis pengeluaran kopi kamu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (_) => setState(() {}),
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: 'Harian', height: 36),
                    Tab(text: 'Mingguan', height: 36),
                    Tab(text: 'Bulanan', height: 36),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Total Pengeluaran Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total Pengeluaran',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(provider.monthlyTotal),
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bulan ini',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Minggu Ini',
                      formatRupiah(provider.weeklyTotal),
                      Icons.view_week_rounded,
                      const Color(0xFFFFF3E6),
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      'Minggu Lalu',
                      formatRupiah(provider.lastWeekTotal),
                      Icons.history_rounded,
                      const Color(0xFFEDF7ED),
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Rata-rata/Hari',
                      formatRupiah(provider.dailyAverage),
                      Icons.trending_up_rounded,
                      const Color(0xFFF0EEFF),
                      const Color(0xFF7C6BEA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      'Total Transaksi',
                      '${provider.weeklyTransactionCount}x',
                      Icons.receipt_long_rounded,
                      const Color(0xFFE8F4FD),
                      const Color(0xFF4A90D9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Bar Chart
              Text(
                'Pengeluaran 7 Hari Terakhir',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: _buildBarChart(provider),
              ),

              const SizedBox(height: 24),

              // Pie Chart - Kategori
              Text(
                'Pengeluaran per Kategori',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              if (categoryData.isEmpty)
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pie_chart_outline,
                          size: 48, color: AppColors.textSecondary.withAlpha(80)),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada data',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 45,
                            sections:
                                _buildPieSections(categoryData, totalCategory),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      ...categoryData.entries.map((e) {
                        final pct = totalCategory > 0
                            ? (e.value / totalCategory * 100)
                            : 0;
                        final color = _getCategoryColor(e.key);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                              Text(
                                formatRupiah(e.value),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${pct.toStringAsFixed(0)}%',
                                  style: GoogleFonts.poppins(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
    );
  }

  Widget _statCard(String title, String value, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(TransactionState provider) {
    final data = provider.last7DaysTotals;
    final maxVal =
        data.fold<int>(0, (max, e) => e.value > max ? e.value : max);
    final maxY = maxVal > 0 ? (maxVal * 1.3) : 50000;

    return BarChart(
      BarChartData(
        maxY: maxY.toDouble(),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(x: entry.key, barRods: [
            BarChartRodData(
              toY: entry.value.value.toDouble(),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.coffeeLight],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 20,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ]);
        }).toList(),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx >= 0 && idx < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(data[idx].key,
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: AppColors.textSecondary)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                formatRupiah(rod.toY.toInt()),
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
      Map<String, int> data, int total) {
    return data.entries.map((e) {
      final pct = total > 0 ? (e.value / total * 100) : 0.0;
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: '${pct.toStringAsFixed(0)}%',
        color: _getCategoryColor(e.key),
        radius: 45,
        titleStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'Espresso': Color(0xFF3C2415),
      'Latte': Color(0xFFD4A574),
      'Cappuccino': Color(0xFF8B6914),
      'Americano': Color(0xFF5D4037),
      'Kopi Susu': Color(0xFFA1887F),
      'Manual Brew': Color(0xFF6F4E37),
      'Frappuccino': Color(0xFF90CAF9),
      'Lainnya': Color(0xFFBDBDBD),
    };
    return colors[category] ?? AppColors.primary;
  }
}
