import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/recommendation_provider.dart';
import 'package:intl/intl.dart';

class DetailMenuScreen extends ConsumerWidget {
  final String id;
  final RecommendationResult? resultData; // Optional, if passed via GoRouter extra
  
  const DetailMenuScreen({super.key, required this.id, this.resultData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If not passed via extra, we would normally fetch it from a provider using the ID
    // For this prototype, we rely on resultData being passed from RecommendationResultScreen
    if (resultData == null) {
      return const Scaffold(
        body: Center(child: Text('Menu not found')),
      );
    }

    final item = resultData!.item;
    final shop = resultData!.shop;
    final matchPercentage = (resultData!.matchScore * 100).toInt();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header / Cover Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl.isNotEmpty ? item.imageUrl : 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.cream),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$matchPercentage% Match',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shop.name,
                              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormat.format(item.price),
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Menu Details
                  Text('Detail Menu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  
                  _buildDetailRow('Kategori', item.category),
                  _buildDetailRow('Suhu', item.temperature),
                  _buildDetailRow('Level Kopi', '${item.strengthLevel}/5'),
                  _buildDetailRow('Level Manis', '${item.sweetnessLevel}/5'),
                  _buildDetailRow('Jenis Susu', item.milkTypes.join(', ')),
                  if (item.flavorTags.isNotEmpty)
                    _buildDetailRow('Rasa Dominan', item.flavorTags.join(', ')),
                    
                  const SizedBox(height: 24),

                  // Map Preview (dummy)
                  Text('Tersedia Di', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text(shop.address, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80), // Padding for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: PrimaryButton(
          label: 'Mulai Navigasi',
          icon: Icons.navigation_rounded,
          onPressed: () {
            // TODO: Open map
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
