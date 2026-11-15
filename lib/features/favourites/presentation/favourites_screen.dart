import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
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
      appBar: AppBar(title: Text(isHindi ? 'पसंदीदा वाहन' : 'My Favourites')),
      body: favouriteVehicles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 64,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isHindi
                        ? 'कोई पसंदीदा वाहन सुरक्षित नहीं है'
                        : 'No favourite vehicles saved',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHindi
                        ? 'किसी वाहन को देखने के बाद "पसंदीदा में जोड़ें" दबाएं'
                        : 'Search any vehicle and tap the bookmark icon',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favouriteVehicles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final v = favouriteVehicles[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Text(
                                v.formattedPlate,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
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
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark,
                                    color: AppColors.saffron,
                                  ),
                                  tooltip: 'Remove from Favourites',
                                  onPressed: () {
                                    ref
                                        .read(favouritesProvider.notifier)
                                        .removeFavourite(v.registrationNumber);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          v.makerModel,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${v.vehicleClass} • ${v.fuelType}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Insurance: ${v.insuranceValidity} • Fitness: ${v.fitnessValidity}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  isHindi ? 'चालान देखें' : 'Check Challans',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  context.push(
                                    '/challan?plate=${v.registrationNumber}',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.icon(
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: Text(
                                  isHindi ? 'आरसी देखें' : 'View RC',
                                  style: const TextStyle(fontSize: 12),
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
                  ),
                );
              },
            ),
    );
  }
}
