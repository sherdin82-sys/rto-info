import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

enum BadgeType { active, expired, warning, info, neutral }

/// StatusBadge displays a compliance status tag with appropriate semantic coloring,
/// subtle border, and optional pulsating dot.
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final bool showDot;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.info,
    this.showDot = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    Color border;

    switch (type) {
      case BadgeType.active:
        bg = isDark ? const Color(0x2A10B981) : AppColors.successLight;
        fg = isDark ? const Color(0xFF34D399) : AppColors.successDark;
        border = isDark ? const Color(0x4D10B981) : const Color(0x6610B981);
        break;
      case BadgeType.expired:
        bg = isDark ? const Color(0x2AEF4444) : AppColors.errorLight;
        fg = isDark ? const Color(0xFFF87171) : AppColors.error;
        border = isDark ? const Color(0x4DEF4444) : const Color(0x66EF4444);
        break;
      case BadgeType.warning:
        bg = isDark ? const Color(0x2AF59E0B) : AppColors.warningLight;
        fg = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
        border = isDark ? const Color(0x4DF59E0B) : const Color(0x66F59E0B);
        break;
      case BadgeType.info:
        bg = isDark ? const Color(0x2A0066FF) : const Color(0xFFEFF6FF);
        fg = isDark ? AppColors.electricBlueLight : AppColors.electricBlue;
        border = isDark ? const Color(0x4D0066FF) : const Color(0x660066FF);
        break;
      case BadgeType.neutral:
        bg = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
        fg = isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
        border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.radiusPill,
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppTypography.labelSmall(fg)
                .copyWith(letterSpacing: 0.4, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
