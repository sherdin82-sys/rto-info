import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, accent, danger, text }

/// AppButton is a standardized, high-performance button supporting primary,
/// secondary, warm orange accent, and danger styles with responsive ink ripple.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 48.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    Color? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.electricBlue;
        fg = Colors.white;
        border = null;
        break;
      case AppButtonVariant.accent:
        bg = AppColors.warmOrange;
        fg = Colors.white;
        border = null;
        break;
      case AppButtonVariant.secondary:
        bg = Colors.transparent;
        fg = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        break;
      case AppButtonVariant.danger:
        bg = AppColors.error;
        fg = Colors.white;
        border = null;
        break;
      case AppButtonVariant.text:
        bg = Colors.transparent;
        fg = isDark ? AppColors.electricBlueLight : AppColors.electricBlue;
        border = null;
        break;
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSpacing.s),
        ],
        Text(
          label,
          style: AppTypography.labelLarge(fg)
              .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : width,
      child: Material(
        color: onPressed == null ? bg.withOpacity(0.5) : bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusM,
          side: border != null
              ? BorderSide(color: border, width: 1.2)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          splashColor: Colors.white.withOpacity(0.18),
          highlightColor: Colors.white.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
