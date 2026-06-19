import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../app/constants/app_colors.dart';
import '../app/constants/app_radius.dart';
import '../app/constants/app_spacing.dart';
import '../app/constants/app_typography.dart';
import '../models/transaction.dart';
import '../app/constants/app_routes.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../core/widgets/widgets.dart';

/// Screen detail untuk menampilkan rincian transaksi kopi secara lengkap.
///
/// Mendukung edit, hapus dengan konfirmasi bottom sheet, dan
/// menampilkan metadata GPS jika tersedia.
class DetailTransactionScreen extends ConsumerWidget {
  final String transactionId;
  const DetailTransactionScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final index = state.transactions.indexWhere((t) => t.id == transactionId);

    // Jika transaksi sudah dihapus
    if (index == -1) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final t = state.transactions[index];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detail Transaksi', style: AppTypography.appBarTitle()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.textPrimary),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
            ),
            onPressed: () {
              context.push(AppRoutes.addTransaction, extra: t);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header Card (Price Hero) ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Category Icon Avatar
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.warmBeige, width: 2),
                    ),
                    child: Icon(
                      _categoryIcon(t.category),
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Coffee Name
                  Text(
                    t.coffeeName,
                    textAlign: TextAlign.center,
                    style: AppTypography.heading1(),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Price Hero
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(t.price),
                    style: AppTypography.priceHero(color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warmBeige,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t.category,
                      style: AppTypography.caption(color: AppColors.primary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ─── Details List ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.lgBR,
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal & Waktu',
                      value: DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id').format(t.transactionTime),
                    ),
                    const Divider(height: AppSpacing.lg),
                    _buildDetailRow(
                      icon: Icons.store_outlined,
                      label: 'Lokasi / Cafe',
                      value: t.location ?? 'Input Manual (Tidak ada cafe terkait)',
                      subtitle: t.coffeeshopId != null ? 'Terhubung ke database cafe' : null,
                    ),
                    if (t.locationLat != null && t.locationLng != null) ...[
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        icon: Icons.my_location_rounded,
                        label: 'Koordinat GPS',
                        value: '${t.locationLat!.toStringAsFixed(6)}, ${t.locationLng!.toStringAsFixed(6)}',
                        trailing: t.locationSource != null
                            ? LocationSourceBadge(source: t.locationSource!)
                            : null,
                      ),
                    ],
                    const Divider(height: AppSpacing.lg),
                    _buildDetailRow(
                      icon: Icons.source_outlined,
                      label: 'Metode Pencatatan',
                      value: t.source == TransactionSource.ocr
                          ? 'Scan Struk (OCR AI)'
                          : 'Pencatatan Manual',
                    ),
                    if (t.note != null && t.note!.isNotEmpty) ...[
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        icon: Icons.notes_rounded,
                        label: 'Catatan',
                        value: t.note!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ─── Actions ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: GhostButton(
                label: 'Hapus Transaksi',
                onPressed: () => _confirmDelete(context, ref),
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodyRegular().copyWith(fontWeight: FontWeight.w500),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.caption(color: AppColors.success),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'espresso':
        return Icons.coffee;
      case 'latte':
        return Icons.local_cafe;
      case 'cappuccino':
        return Icons.coffee_maker;
      case 'americano':
        return Icons.coffee_rounded;
      case 'kopi susu':
        return Icons.local_drink;
      case 'manual brew':
        return Icons.filter_alt;
      case 'frappuccino':
        return Icons.icecream;
      default:
        return Icons.coffee_rounded;
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmationBottomSheet(
      context: context,
      title: 'Hapus Transaksi?',
      message: 'Tindakan ini tidak dapat dibatalkan. Riwayat budget kamu akan disesuaikan kembali.',
      confirmLabel: 'Ya, Hapus',
      cancelLabel: 'Batal',
      isDanger: true,
    );

    if (confirmed && context.mounted) {
      ref.read(transactionProvider.notifier).deleteTransaction(transactionId);
      context.pop(); // Pop Detail Screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaksi berhasil dihapus'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
