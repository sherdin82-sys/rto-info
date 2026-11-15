import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/vehicle_search_bar.dart';

class VehicleSearchScreen extends ConsumerWidget {
  const VehicleSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: isHindi ? 'वाहन खोज' : 'Vehicle Search',
        subtitle: isHindi
            ? 'एचएसआरपी नंबर प्लेट सत्यापन'
            : 'Verify Indian registration plates',
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VehicleSearchBar(
              onSearch: (plate) {
                context.push('/rc?plate=$plate');
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              isHindi ? 'उदाहरण नंबर प्लेट' : 'Sample Number Plates',
              style: AppTypography.titleSmall(
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            ...AppConstants.sampleVehicles.map(
              (sample) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: PremiumCard(
                  onTap: () {
                    context.push('/rc?plate=${sample['plate']}');
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceAlt
                              : AppColors.lightSurfaceAlt,
                          borderRadius: AppRadius.radiusS,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          VehicleNumberFormatter.formatForDisplay(
                            sample['plate']!,
                          ),
                          style: AppTypography.hsrpPlate(
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sample['label']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sample['desc']!,
                              style: AppTypography.labelSmall(
                                isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.electricBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
