import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// PremiumCard is NoteFlow's signature container widget with subtle border,
/// rounded corners, and anti-aliased Material ink splash.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(AppConstants.paddingMedium),
    this.borderRadius = AppConstants.radiusMedium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Material(
      color: backgroundColor ?? defaultBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor ?? defaultBorder, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: (isDark ? Colors.white : Colors.black).withAlpha(15),
        highlightColor: (isDark ? Colors.white : Colors.black).withAlpha(8),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
