import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';
import '../../../models/transaction.dart';

enum AvailabilityStatus {
  available,
  likelyAvailable,
  unavailable,
  unverified,
}

class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({
    super.key,
    required this.status,
    this.verifiedAt,
    this.compact = false,
  });

  final AvailabilityStatus status;
  final DateTime? verifiedAt;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg(status);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cfg.bg,
            borderRadius: AppRadius.smBR,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(cfg.icon, size: 12, color: cfg.fg),
              const SizedBox(width: 4),
              Text(
                cfg.label,
                style: AppTypography.caption(color: cfg.fg)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (!compact && verifiedAt != null) ...[
          const SizedBox(height: 2),
          Text(
            _ago(verifiedAt!),
            style:
                AppTypography.caption(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  String _ago(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja diperbarui';
    if (diff.inMinutes < 60) return 'Diperbarui ${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return 'Diperbarui ${diff.inHours} jam lalu';
    return 'Diperbarui ${diff.inDays} hari lalu';
  }

  _Cfg _cfg(AvailabilityStatus s) => switch (s) {
        AvailabilityStatus.available => _Cfg(
            label: AppStrings.available,
            icon: Icons.check_circle_outline_rounded,
            bg: Color(0x1F7C9A62),
            fg: AppColors.success,
          ),
        AvailabilityStatus.likelyAvailable => _Cfg(
            label: AppStrings.likelyAvailable,
            icon: Icons.help_outline_rounded,
            bg: Color(0x1FD1A054),
            fg: AppColors.warning,
          ),
        AvailabilityStatus.unavailable => _Cfg(
            label: AppStrings.unavailable,
            icon: Icons.cancel_outlined,
            bg: Color(0x1FB85C4A),
            fg: AppColors.error,
          ),
        AvailabilityStatus.unverified => _Cfg(
            label: AppStrings.unverified,
            icon: Icons.info_outline_rounded,
            bg: AppColors.warmBeige,
            fg: AppColors.textSecondary,
          ),
      };
}

class _Cfg {
  const _Cfg(
      {required this.label,
      required this.icon,
      required this.bg,
      required this.fg});
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
}

// ─── Location source badge ────────────────────────────────────────────────


class LocationSourceBadge extends StatelessWidget {
  const LocationSourceBadge({super.key, required this.source});
  final LocationSource source;

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg(source);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: AppRadius.smBR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cfg.emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            cfg.label,
            style: AppTypography.caption(color: cfg.fg)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _LocCfg _cfg(LocationSource s) => switch (s) {
        LocationSource.gps => _LocCfg(
            emoji: '📍',
            label: 'GPS Aktif',
            bg: const Color(0x1F7C9A62),
            fg: AppColors.success,
          ),
        LocationSource.network => _LocCfg(
            emoji: '📶',
            label: 'Sinyal Jaringan',
            bg: const Color(0x1FD1A054),
            fg: AppColors.warning,
          ),
        LocationSource.ip => _LocCfg(
            emoji: '🌐',
            label: 'Perkiraan IP',
            bg: const Color(0xFFE8F0F5),
            fg: AppColors.info,
          ),
        LocationSource.manual => _LocCfg(
            emoji: '✍️',
            label: 'Manual',
            bg: AppColors.warmBeige,
            fg: AppColors.textSecondary,
          ),
      };
}

class _LocCfg {
  const _LocCfg(
      {required this.emoji,
      required this.label,
      required this.bg,
      required this.fg});
  final String emoji;
  final String label;
  final Color bg;
  final Color fg;
}

// ─── Match score badge ────────────────────────────────────────────────────

class MatchScoreBadge extends StatelessWidget {
  const MatchScoreBadge({super.key, required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.smBR,
      ),
      child: Text(
        '${(score * 100).round()}% cocok',
        style: AppTypography.caption(color: Colors.white)
            .copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
