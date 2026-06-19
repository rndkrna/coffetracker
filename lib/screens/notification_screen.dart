import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/constants/app_colors.dart';
import '../core/widgets/widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock notification data matching Figma/wireframe
    final todayNotifications = [
      _NotificationItem(
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.warning,
        iconBg: AppColors.warning.withValues(alpha: 0.1),
        title: 'Budget sudah mencapai 80%',
        description: 'Sisa budget bulan ini sekitar Rp60.000. Waktunya mengerem sejenak!',
        time: '10 menit lalu',
      ),
      _NotificationItem(
        icon: Icons.coffee_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primary.withValues(alpha: 0.1),
        title: 'Menu favorit tersedia kembali',
        description: 'Iced Latte di Kopi Kita sekarang tersedia untuk dipesan.',
        time: '1 jam lalu',
      ),
    ];

    final yesterdayNotifications = [
      _NotificationItem(
        icon: Icons.location_on_rounded,
        iconColor: AppColors.success,
        iconBg: AppColors.success.withValues(alpha: 0.1),
        title: 'Ada kedai baru dekatmu',
        description: 'Kopi Kenangan Baru berjarak 650 meter dari lokasimu sekarang.',
        time: 'Kemarin',
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CoffeeAppBar(
        title: 'Notifikasi',
        onBack: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          if (todayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Hari Ini'),
            const SizedBox(height: 10),
            ...todayNotifications.map((n) => _buildItemCard(context, n)),
            const SizedBox(height: 24),
          ],
          if (yesterdayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Kemarin'),
            const SizedBox(height: 10),
            ...yesterdayNotifications.map((n) => _buildItemCard(context, n)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, _NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.time,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final String time;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.time,
  });
}
