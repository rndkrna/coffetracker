import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/constants/app_colors.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Preferensi Minuman', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kopi Favorit Kamu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Data ini akan digunakan untuk memberikan rekomendasi menu yang lebih akurat.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            
            // Example preference selections
            _buildPrefTile('Suhu Kopi', 'Hot & Iced', Icons.thermostat_rounded),
            _buildPrefTile('Tingkat Kemanisan', 'Normal (100%)', Icons.coffee_rounded),
            _buildPrefTile('Kekuatan Kopi', 'Medium', Icons.flash_on_rounded),
            _buildPrefTile('Jenis Susu', 'Oat Milk, Full Cream', Icons.water_drop_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildPrefTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}
