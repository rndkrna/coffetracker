import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../app/constants/app_routes.dart';
import '../core/widgets/widgets.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  final List<String> _filters = [
    'Semua', 'Espresso', 'Latte', 'Cappuccino', 'Americano',
    'Kopi Susu', 'Manual Brew', 'Frappuccino', 'Lainnya',
  ];

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(transactionProvider);
    var filtered = provider.transactions.where((t) {
          final matchSearch = _searchQuery.isEmpty ||
              t.coffeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (t.location?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false);
          final matchFilter =
              _selectedFilter == 'Semua' || t.category == _selectedFilter;
          return matchSearch && matchFilter;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Riwayat Transaksi',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Semua catatan pengeluaran kopi kamu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  separatorBuilder: (context, a) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = _filters[index];
                    final isSelected = f == _selectedFilter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          f,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Transaction Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                '${filtered.length} transaksi ditemukan',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),

            // Transaction List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 64,
                              color: AppColors.textSecondary.withAlpha(80)),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada transaksi',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final t = filtered[index];
                        return Dismissible(
                          key: Key(t.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white),
                          ),
                          confirmDismiss: (_) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  'Hapus Transaksi',
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                ),
                                content: Text(
                                  'Hapus "${t.coffeeName}"?',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text('Batal', style: GoogleFonts.poppins()),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      'Hapus',
                                      style: GoogleFonts.poppins(color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (_) =>
                              ref.read(transactionProvider.notifier).deleteTransaction(t.id),
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
                        );
                      },
                    ),
            ),
          ],
        );
  }
}
