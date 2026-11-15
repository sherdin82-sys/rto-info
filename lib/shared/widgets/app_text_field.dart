import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// AppTextField provides standardized, modern automotive input fields with
/// consistent rounded corners, prefix/suffix icons, and error handling.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? hintText;
  final String? errorText;
  final dynamic prefixIcon; // Supports Widget or IconData
  final dynamic suffixIcon; // Supports Widget or IconData
  final String? suffixText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final int maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.maxLines = 1,
  });

  Widget? _buildIcon(dynamic icon, Color color) {
    if (icon == null) return null;
    if (icon is Widget) return icon;
    if (icon is IconData) {
      return Icon(icon, size: 20, color: color);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final hintColor = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final fillColor = isDark
        ? AppColors.darkSurfaceAlt
        : AppColors.lightSurfaceAlt;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final resolvedPrefix = _buildIcon(prefixIcon, hintColor);
    Widget? resolvedSuffix = _buildIcon(suffixIcon, hintColor);

    if (resolvedSuffix == null && suffixText != null) {
      resolvedSuffix = Padding(
        padding: const EdgeInsets.only(right: AppSpacing.m),
        child: Center(
          child: Text(
            suffixText!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: hintColor,
            ),
          ),
        ),
      );
    } else if (resolvedSuffix == null &&
        onClear != null &&
        (controller?.text.isNotEmpty ?? false)) {
      resolvedSuffix = IconButton(
        icon: const Icon(Icons.clear, size: 18),
        onPressed: onClear,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelLarge(
              isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            hintText: hint ?? hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: hintColor,
            ),
            errorText: errorText,
            prefixIcon: resolvedPrefix,
            suffixIcon: resolvedSuffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusM,
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusM,
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusM,
              borderSide: const BorderSide(
                color: AppColors.electricBlue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusM,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
