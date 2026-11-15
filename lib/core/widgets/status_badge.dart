import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum BadgeType { active, expired, warning, info, neutral }

/// StatusBadge displays a compliance status tag with appropriate semantic coloring.
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.info,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (type) {
      case BadgeType.active:
        bg = AppColors.successLight;
        text = AppColors.successDark;
        break;
      case BadgeType.expired:
        bg = AppColors.errorLight;
        text = AppColors.error;
        break;
      case BadgeType.warning:
        bg = AppColors.warningLight;
        text = AppColors.warning;
        break;
      case BadgeType.info:
        bg = AppColors.electricBlue.withOpacity(0.12);
        text = AppColors.electricBlue;
        break;
      case BadgeType.neutral:
        bg = Colors.grey.withOpacity(0.12);
        text = Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
