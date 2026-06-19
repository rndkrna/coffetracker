import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/recommendation/providers/recommendation_provider.dart';
import '../features/location/providers/location_provider.dart';
import '../app/constants/app_routes.dart';
import '../theme/app_theme.dart';
import '../models/coffee_shop.dart';
import 'package:intl/intl.dart';

class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  final TextEditingController _budgetController = TextEditingController();
  String? _selectedVibe;
  List<CoffeeShop> _results = [];
  bool _hasSearched = false;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final List<Map<String, dynamic>> _vibes = [
    {'name': 'Nongki', 'icon': Icons.groups_rounded},
    {'name': 'Ngechill', 'icon': Icons.self_improvement_rounded},
    {'name': 'Nugas', 'icon': Icons.laptop_mac_rounded},
  ];

  void _search() {
    final budgetStr = _budgetController.text;
    if (budgetStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan budget kamu dulu ya!')),
      );
      return;
    }

    // Strip all non-numeric characters to prevent parsing errors
    final budgetStrOnlyDigits = budgetStr.replaceAll(RegExp(r'[^0-9]'), '');
    final budget = int.tryParse(budgetStrOnlyDigits) ?? 0;
    
    // If somehow it's still 0 (e.g., user typed "abc"), maybe give a default large budget just to show something
    final effectiveBudget = budget > 0 ? budget : 9999999;
    
    final provider = ref.read(recommendationProvider.notifier);
    final locState = ref.read(locationProvider);
    
    setState(() {
      _results = provider.searchShops(
        budget: effectiveBudget, 
        vibe: _selectedVibe,
        userLat: locState.location.latitude != 0.0 ? locState.location.latitude : null,
        userLng: locState.location.longitude != 0.0 ? locState.location.longitude : null,
      );
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kopi Sesuai Budget'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => context.push(AppRoutes.addShop).then((_) {
              // Refresh results if we have searched
              if (_hasSearched) _search();
            }),
            tooltip: 'Tambah Coffee Shop',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchCard(),
            const SizedBox(height: 24),
            if (_hasSearched) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rekomendasi Untukmu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    '${_results.length} ditemukan',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_results.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _buildShopCard(_results[index]),
                ),
            ] else 
              _buildInitialState(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentukan Budget & Vibe',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Berapa budget kamu? (Contoh: 50000)',
              prefixIcon: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
              suffixText: 'IDR',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lagi pengen ngapain?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _vibes.map((vibe) {
              final isSelected = _selectedVibe == vibe['name'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedVibe = null;
                      } else {
                        _selectedVibe = vibe['name'];
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          vibe['icon'],
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vibe['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Rekomendasi Cepat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(AppRoutes.guidedSearch),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cari Menu Sendiri', style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(CoffeeShop shop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  shop.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withAlpha(230),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          shop.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleSmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: shop.vibes.map((v) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(200),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        v[0].toUpperCase() + v.substring(1),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        shop.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                      onPressed: () => _confirmDelete(shop),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shop.address,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 12),
                Text(
                  'Menu Sesuai Budget:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleSmall?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: shop.menu.where((item) {
                    final budget = int.tryParse(_budgetController.text.replaceAll('.', '')) ?? 0;
                    return item.price <= budget;
                  }).map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          _currencyFormat.format(item.price),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(CoffeeShop shop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Coffee Shop?'),
        content: Text('Apakah kamu yakin ingin menghapus "${shop.name}" dari daftar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(recommendationProvider.notifier)
                  .deleteCoffeeShop(shop.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              if (_hasSearched) _search();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Coffee Shop berhasil dihapus')),
              );
            },
            child:
                const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.coffee_rounded, size: 64, color: AppColors.textSecondary.withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            'Yah, belum ada yang pas...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba naikkan budget atau ganti vibe-nya.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Cari Coffeeshop Idamanmu!',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Masukkan budget dan pilih suasana yang kamu mau untuk mendapatkan rekomendasi terbaik.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
