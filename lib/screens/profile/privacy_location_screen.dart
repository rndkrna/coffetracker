import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/constants/app_colors.dart';

class PrivacyLocationScreen extends StatefulWidget {
  const PrivacyLocationScreen({super.key});

  @override
  State<PrivacyLocationScreen> createState() => _PrivacyLocationScreenState();
}

class _PrivacyLocationScreenState extends State<PrivacyLocationScreen> {
  bool _shareLocation = true;
  bool _allowAnalytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Privasi & Lokasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Izin & Pengumpulan Data', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kelola bagaimana aplikasi mengakses data privasi kamu.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Akses Lokasi GPS', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('Digunakan untuk mencari kedai kopi terdekat.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                    value: _shareLocation,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _shareLocation = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text('Kirim Data Analitik', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text('Bantu kami meningkatkan aplikasi secara anonim.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                    value: _allowAnalytics,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _allowAnalytics = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
