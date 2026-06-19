import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../core/widgets/layout/coffee_bottom_nav.dart';

/// Shell scaffold that wraps tab content with the persistent [CoffeeBottomNav].
///
/// The [child] parameter comes from [ShellRoute.builder] and represents
/// the currently active tab's widget.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.child});

  final Widget child;

  /// Maps tab index → route path for go_router navigation.
  static const _tabRoutes = [
    AppRoutes.home,         // 0 — Home
    AppRoutes.transactions, // 1 — History
    AppRoutes.finder,       // 2 — Cari Kedai
    AppRoutes.recommendations, // 3 — Rekomendasi
    AppRoutes.profile,      // 4 — Profil / Settings
  ];

  /// Determines the currently active tab index from the router location.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      floatingActionButton:
          (currentIndex == 0 || currentIndex == 1) ? _buildFAB(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CoffeeBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => _onTabTap(context, i),
      ),
    );
  }

  void _onTabTap(BuildContext context, int index) {
    context.go(_tabRoutes[index]);
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddSheet(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddMethodSheet(
        onScan: () {
          Navigator.pop(ctx);
          context.push(AppRoutes.ocrScan);
        },
        onManual: () {
          Navigator.pop(ctx);
          context.push(AppRoutes.addTransaction);
        },
      ),
    );
  }
}

// ─── Add Method Bottom Sheet ─────────────────────────────────────────────────

class _AddMethodSheet extends StatelessWidget {
  const _AddMethodSheet({required this.onScan, required this.onManual});
  final VoidCallback onScan;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Tambah Transaksi', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Pilih metode pencatatan pengeluaran kopi',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MethodCard(
                  icon: Icons.document_scanner_rounded,
                  label: 'Scan Struk',
                  description: 'Foto struk, data terisi otomatis',
                  color: theme.colorScheme.primary,
                  onTap: onScan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MethodCard(
                  icon: Icons.edit_note_rounded,
                  label: 'Input Manual',
                  description: 'Isi data transaksi secara manual',
                  color: theme.colorScheme.secondary,
                  onTap: onManual,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
