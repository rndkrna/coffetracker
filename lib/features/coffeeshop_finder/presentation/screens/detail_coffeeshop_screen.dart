import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../recommendation/providers/recommendation_provider.dart';

class DetailCoffeeshopScreen extends ConsumerStatefulWidget {
  final String id;
  const DetailCoffeeshopScreen({super.key, required this.id});

  @override
  ConsumerState<DetailCoffeeshopScreen> createState() => _DetailCoffeeshopScreenState();
}

class _DetailCoffeeshopScreenState extends ConsumerState<DetailCoffeeshopScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final recommendationState = ref.watch(recommendationProvider);
    final shopIndex = recommendationState.allShops.indexWhere((s) => s.id == widget.id);
    if (shopIndex == -1) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Coffee shop not found')),
      );
    }
    final shop = recommendationState.allShops[shopIndex];

    // Dummy Data & Real Data Mix
    const isVerified = true;
    final rating = shop.rating;
    const reviews = 124; // Dummy
    const distance = 1.2; // Dummy

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header / Cover Image
          SliverAppBar(
            expandedHeight: 250,
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
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 20,
                    color: _isFavorite ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
                onPressed: () {
                  setState(() => _isFavorite = !_isFavorite);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.cream),
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
                              shop.name,
                              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coffee Shop • ${shop.address}',
                              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success.withAlpha(50)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_rounded, size: 12, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text('Verified', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quick Stats
                  Row(
                    children: [
                      _buildStatItem(Icons.star_rounded, '$rating ($reviews)', AppColors.caramel),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.location_on_rounded, '${distance}km', AppColors.info),
                      const SizedBox(width: 16),
                      _buildStatItem(Icons.access_time_rounded, 'Buka', AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mood & Facilities
                  Text('Mood', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: shop.vibes.map((e) => _buildTag(e, AppColors.accent)).toList(),
                  ),
                  const SizedBox(height: 16),

                  Text('Fasilitas', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['WiFi', 'Stopkontak', 'Indoor', 'Outdoor'].map((e) => _buildTag(e, AppColors.warmBeige)).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Map Preview
                  Text('Lokasi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_rounded, size: 32, color: AppColors.secondary),
                          const SizedBox(height: 8),
                          Text('Peta Google Maps', style: GoogleFonts.poppins(color: AppColors.secondary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: PrimaryButton(
                      label: 'Buka di Google Maps',
                      onPressed: () {},
                      icon: Icons.directions_rounded,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
    );
  }
}
