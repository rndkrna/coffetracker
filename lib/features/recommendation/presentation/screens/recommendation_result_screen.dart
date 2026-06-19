import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_routes.dart';
import '../../providers/recommendation_provider.dart';
import 'package:intl/intl.dart';

class RecommendationResultScreen extends ConsumerStatefulWidget {
  final List<RecommendationResult>? results;
  
  const RecommendationResultScreen({super.key, this.results});

  @override
  ConsumerState<RecommendationResultScreen> createState() => _RecommendationResultScreenState();
}

class _RecommendationResultScreenState extends ConsumerState<RecommendationResultScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    // If results is null, it means we didn't pass data properly, 
    // but typically we pass it via GoRouter extra.
    final items = widget.results ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Hasil Rekomendasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final result = items[index];
                return _buildResultCard(result, index + 1);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: AppColors.textSecondary.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'Tidak ada menu yang cocok',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah kriteria pencarian kamu, misalnya dengan menaikkan budget atau mencoba rasa lain.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Ubah Pencarian'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(RecommendationResult result, int rank) {
    final matchPercentage = (result.matchScore * 100).toInt();
    
    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.menuDetail}/${result.item.id}', extra: result);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank Badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank == 1 ? AppColors.caramel : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: rank == 1 ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          result.item.name,
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$matchPercentage% Match',
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currencyFormat.format(result.item.price),
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  
                  // Shop Info
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          result.shop.name,
                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(result.item.temperature, AppColors.info),
                      if (result.item.flavorTags.isNotEmpty)
                        _buildTag(result.item.flavorTags.first, AppColors.accent),
                      _buildTag(result.item.category, AppColors.warmBeige),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: color.withAlpha(204)),
      ),
    );
  }
}
