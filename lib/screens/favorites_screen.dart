import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/constants/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tersimpan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Kedai Kopi'),
                  Tab(text: 'Menu Kopi'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmptyState('Belum ada kedai kopi favorit'),
                  _buildEmptyState('Belum ada menu kopi favorit'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.textSecondary.withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
