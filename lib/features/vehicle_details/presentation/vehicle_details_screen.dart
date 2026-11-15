import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/native_bridge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../../shared/models/vehicle_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../favourites/presentation/providers/favourites_provider.dart';
import '../../history/presentation/providers/history_provider.dart';
import 'providers/vehicle_details_provider.dart';

/// VehicleDetailsScreen presents the comprehensive Parivahan Vahan profile
/// organized into Registration, Vehicle, Owner, and Compliance sections.
class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final String? initialPlate;

  const VehicleDetailsScreen({super.key, this.initialPlate});

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  bool _historyRecorded = false;

  void _recordHistoryOnce(VehicleEntity vehicle) {
    if (_historyRecorded) return;
    _historyRecorded = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(historyProvider.notifier)
          .addSearch(
            registrationNumber: vehicle.cleanRegistrationNumber,
            formattedPlate: vehicle.registrationNumber,
            makerModel: '${vehicle.maker} ${vehicle.model}',
            vehicleClass: vehicle.vehicleClass,
          );
    });
  }

  void _shareVehicle(VehicleEntity vehicle) {
    final text =
        '''
*RTO VEHICLE INFORMATION*
Plate: ${vehicle.registrationNumber}
Model: ${vehicle.maker} ${vehicle.model}
Class: ${vehicle.vehicleClass}
Fuel: ${vehicle.fuelType}
Fitness: ${vehicle.fitnessValidity}
Insurance: ${vehicle.insuranceValidity} (${vehicle.insuranceStatus})
Authority: ${vehicle.registrationAuthority}
Check more on RTO Info App
''';
    NativeBridge.shareVehicleDetails(
      text,
      subject: 'RTO Details: ${vehicle.registrationNumber}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawPlate = widget.initialPlate ?? 'DL01AB1234';
    final cleanPlate = VehicleNumberValidator.cleanPlate(rawPlate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final vehicleAsync = ref.watch(vehicleLookupProvider(cleanPlate));
    ref.watch(favouritesProvider);
    final isFav = ref.read(favouritesProvider.notifier).isFavourite(cleanPlate);

    return Scaffold(
      appBar: AppAppBar(
        title: VehicleNumberValidator.formatForDisplay(cleanPlate),
        subtitle: 'Parivahan Digital RC Card',
        actions: [
          vehicleAsync.when(
            data: (vehicle) {
              if (vehicle == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: isFav ? AppColors.warmOrange : null,
                ),
                tooltip: isFav
                    ? 'Remove from Favourites'
                    : 'Save to Favourites',
                onPressed: () {
                  ref
                      .read(favouritesProvider.notifier)
                      .toggleFavourite(vehicle);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? 'Removed from Favourites'
                            : 'Saved to Favourites',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          vehicleAsync.when(
            data: (vehicle) {
              if (vehicle == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share Details',
                onPressed: () => _shareVehicle(vehicle),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: vehicleAsync.when(
        loading: () =>
            const LoadingView(message: 'Retrieving Parivahan Vahan Records...'),
        error: (err, stack) => ErrorView(
          title: 'Record Not Found',
          message:
              'Could not retrieve vehicle information for $cleanPlate. Please verify the registration number.',
          actionLabel: 'Go Back',
          onAction: () => context.pop(),
        ),
        data: (vehicle) {
          if (vehicle == null) {
            return ErrorView(
              title: 'Vehicle Record Unavailable',
              message:
                  'No official registration record matched $cleanPlate in the database.',
              actionLabel: 'Go Back',
              onAction: () => context.pop(),
            );
          }

          _recordHistoryOnce(vehicle);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            children: [
              // Digital Smart Card RC Header
              _buildDigitalRcSmartCard(vehicle, isDark),
              const SizedBox(height: 10),

              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Check e-Challan',
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                      variant: AppButtonVariant.danger,
                      height: 38,
                      onPressed: () {
                        context.push(
                          '/challan?plate=${vehicle.cleanRegistrationNumber}',
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      label: isFav ? 'Saved' : 'Bookmark',
                      icon: Icon(
                        isFav ? Icons.bookmark : Icons.bookmark_border,
                        size: 17,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      variant: AppButtonVariant.secondary,
                      height: 38,
                      onPressed: () {
                        ref
                            .read(favouritesProvider.notifier)
                            .toggleFavourite(vehicle);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Section 1: Registration Details
              _buildSectionTitle('REGISTRATION DETAILS', isDark),
              const SizedBox(height: 6),
              PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      title: 'Registration Number',
                      value: vehicle.registrationNumber,
                      isBold: true,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Registration Date',
                      value: vehicle.registrationDate,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Registering Authority',
                      value: vehicle.registrationAuthority,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'RTO Code & State',
                      value: '${vehicle.rtoCode} (${vehicle.state})',
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Vehicle Class',
                      value: vehicle.vehicleClass,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Registration Validity',
                      value: vehicle.registrationValidity,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Status',
                      value: vehicle.registrationStatus,
                      isSuccess: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section 2: Vehicle & Manufacturer Details
              _buildSectionTitle('VEHICLE & TECHNICAL SPECIFICATIONS', isDark),
              const SizedBox(height: 6),
              PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      title: 'Manufacturer / Maker',
                      value: vehicle.maker,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(title: 'Model & Variant', value: vehicle.model),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(title: 'Body Type', value: vehicle.bodyType),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(title: 'Fuel Type', value: vehicle.fuelType),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Engine Displacement',
                      value: vehicle.engineCapacity,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Seating Capacity',
                      value: '${vehicle.seatingCapacity} Persons',
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(title: 'Color', value: vehicle.color),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section 3: Compliance & Validity
              _buildSectionTitle('INSURANCE, FITNESS & PUC COMPLIANCE', isDark),
              const SizedBox(height: 6),
              PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      title: 'Insurance Status',
                      value: vehicle.insuranceStatus,
                      isSuccess:
                          vehicle.insuranceStatus.toUpperCase() == 'ACTIVE',
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Insurance Provider',
                      value: vehicle.insuranceCompany,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Insurance Valid Upto',
                      value: vehicle.insuranceValidity,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Fitness Valid Upto',
                      value: vehicle.fitnessValidity,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'PUC Valid Upto',
                      value: vehicle.pucValidity,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Road Tax Status',
                      value: vehicle.roadTaxPaidUpto,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Emission Norms',
                      value: vehicle.emissionStandard,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section 4: Statutory Compliance & Ownership Details
              _buildSectionTitle('STATUTORY COMPLIANCE & OWNERSHIP', isDark),
              const SizedBox(height: 6),
              PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      title: 'Owner Name (Sec 6 Privacy)',
                      value: vehicle.maskedOwnerName,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Owner Serial / Count',
                      value: vehicle.ownershipSerial,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Chassis Number (Masked)',
                      value: vehicle.maskedChassisNumber,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Engine Number (Masked)',
                      value: vehicle.maskedEngineNumber,
                    ),
                    const Divider(height: 12, thickness: 0.8),
                    _DetailRow(
                      title: 'Hypothecation / Financier',
                      value:
                          vehicle.hypothecationBank ??
                          (vehicle.isHypothecated ? 'Hypothecated' : 'None'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDigitalRcSmartCard(VehicleEntity v, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavyDark, AppColors.primaryNavyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.electricBlue.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield,
                    color: AppColors.metallicGold,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    'UNION OF INDIA • REGISTRATION CERTIFICATE',
                    style: TextStyle(
                      color: AppColors.metallicGoldLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              StatusBadge(label: v.registrationStatus, type: BadgeType.active),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          // Demo vs Verified Record Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: v.isDemoData
                  ? Colors.amber.withOpacity(0.18)
                  : Colors.green.withOpacity(0.18),
              borderRadius: AppRadius.radiusXs,
              border: Border.all(
                color: v.isDemoData ? Colors.amberAccent : Colors.greenAccent,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  v.isDemoData ? Icons.science_outlined : Icons.verified_user,
                  size: 12,
                  color: v.isDemoData ? Colors.amberAccent : Colors.greenAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  v.isDemoData
                      ? 'DEMONSTRATION RECORD'
                      : 'VERIFIED PARIVAHAN RECORD',
                  style: TextStyle(
                    color: v.isDemoData
                        ? Colors.amberAccent
                        : Colors.greenAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.registrationNumber,
                    style: AppTypography.hsrpPlate(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${v.maker} • ${v.model}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Metallic EMV Chip Visual
              Container(
                width: 42,
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.metallicGoldLight,
                      AppColors.metallicGold,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.radiusS,
                  border: Border.all(color: Colors.white70, width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.memory,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CardInfoItem(label: 'FUEL', value: v.fuelType),
              _CardInfoItem(
                label: 'CLASS',
                value: v.vehicleClass.split(' ')[0],
              ),
              _CardInfoItem(label: 'REG DATE', value: v.registrationDate),
              _CardInfoItem(
                label: 'FITNESS',
                value: v.fitnessValidity.split('-').last,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? AppColors.electricBlueLight : AppColors.electricBlue,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final bool isSuccess;

  const _DetailRow({
    required this.title,
    required this.value,
    this.isBold = false,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isSuccess
                  ? AppColors.success
                  : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _CardInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
