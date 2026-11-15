import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/status_badge.dart';
import 'providers/favourites_provider.dart';

/// FavouritesScreen manages bookmarked personal and family vehicles.
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final favouriteVehicles = ref.watch(favouritesProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: isHindi ? 'पसंदीदा वाहन' : 'My Favourites',
        subtitle: isHindi
            ? '${favouriteVehicles.length} सुरक्षित वाहन'
            : '${favouriteVehicles.length} bookmarked vehicles',
      ),
      body: SafeArea(
        child: favouriteVehicles.isEmpty
            ? EmptyStateView(
                icon: Icons.bookmark_outline_rounded,
                title: isHindi
                    ? 'कोई पसंदीदा वाहन सुरक्षित नहीं है'
                    : 'No Favourite Vehicles Saved',
                description: isHindi
                    ? 'किसी भी वाहन की आरसी विवरण स्क्रीन पर बुकमार्क आइकन दबाकर यहाँ जोड़ें।'
                    : 'Bookmark personal and family vehicles to quickly monitor registration, insurance, and challans.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.l),
                itemCount: favouriteVehicles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.m),
                itemBuilder: (context, index) {
                  final v = favouriteVehicles[index];

                  return PremiumCard(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurfaceAlt
                                    : AppColors.lightSurfaceAlt,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.s,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.electricBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    v.formattedPlate,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                StatusBadge(
                                  label: v.insuranceStatus,
                                  type: v.insuranceStatus == 'ACTIVE'
                                      ? BadgeType.active
                                      : BadgeType.expired,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_rounded,
                                    color: AppColors.saffron,
                                  ),
                                  tooltip: 'Remove Bookmark',
                                  onPressed: () {
                                    ref
                                        .read(favouritesProvider.notifier)
                                        .removeFavourite(v.registrationNumber);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isHindi
                                              ? '${v.formattedPlate} पसंदीदा से हटाया गया'
                                              : '${v.formattedPlate} removed from favourites',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          v.makerModel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.electricBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                v.vehicleClass,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.electricBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•   ${v.fuelType}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Row(
                          children: [
                            Icon(
                              Icons.security_rounded,
                              size: 13,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Insurance: ${v.insuranceValidity}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.speed_rounded,
                              size: 13,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Fitness: ${v.fitnessValidity}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.saffron,
                                  side: const BorderSide(
                                    color: AppColors.saffron,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.button,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  isHindi ? 'चालान देखें' : 'Check Challans',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  context.push(
                                    '/challan?plate=${v.registrationNumber}',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.electricBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.button,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  isHindi ? 'आरसी देखें' : 'View RC',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  context.push(
                                    '/rc?plate=${v.registrationNumber}',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
