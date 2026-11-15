import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// PremiumCard is RTO Info's signature container widget with subtle border,
/// rounded corners, and anti-aliased Material ink splash.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? accentColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.borderColor,
    this.accentColor,
    this.gradient,
    this.padding = AppSpacing.edgeInsetsL,
    this.borderRadius = AppRadius.card,
    this.borderWidth = 1.0,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    Widget content = Padding(padding: padding, child: child);

    if (accentColor != null) {
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(borderRadius),
                ),
              ),
            ),
            Expanded(
              child: Padding(padding: padding, child: child),
            ),
          ],
        ),
      );
    }

    Widget cardBody = InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(borderRadius),
      splashColor: (isDark ? Colors.white : Colors.black).withAlpha(15),
      highlightColor: (isDark ? Colors.white : Colors.black).withAlpha(8),
      child: accentColor != null
          ? content
          : Padding(padding: padding, child: child),
    );

    if (gradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? defaultBorder,
            width: borderWidth,
          ),
          boxShadow: shadows,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(color: Colors.transparent, child: cardBody),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: borderWidth,
        ),
        boxShadow: shadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(color: Colors.transparent, child: cardBody),
    );
  }
}
