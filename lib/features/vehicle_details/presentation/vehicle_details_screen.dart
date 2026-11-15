import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../../core/widgets/status_badge.dart';
import '../providers/vehicle_details_provider.dart';
import '../../history/presentation/providers/history_provider.dart';
import '../../favourites/presentation/providers/favourites_provider.dart';
import '../../domain/models/vehicle_entity.dart';

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

  @override
  Widget build(BuildContext context) {
    final rawPlate = widget.initialPlate ?? 'DL01AB1234';
    final cleanPlate = VehicleNumberValidator.cleanPlate(rawPlate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final vehicleAsync = ref.watch(vehicleLookupProvider(cleanPlate));
    final favourites = ref.watch(favouritesProvider);
    final isFav = ref.read(favouritesProvider.notifier).isFavourite(cleanPlate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          VehicleNumberValidator.formatForDisplay(cleanPlate),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
        actions: [
          vehicleAsync.when(
            data: (vehicle) {
              if (vehicle == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: isFav ? AppColors.saffron : null,
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
                            : 'Added to Favourites',
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
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Details',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vehicle details ready for sharing'),
                ),
              );
            },
          ),
        ],
      ),
      body: vehicleAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Retrieving Parivahan Vahan Records...',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Record Not Found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Could not retrieve vehicle information for $cleanPlate. Please check the registration number.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('Vehicle record not available'));
          }

          _recordHistoryOnce(vehicle);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Digital Smart Card RC Header
              _buildDigitalRcSmartCard(vehicle, isDark),
              const SizedBox(height: 16),

              // Quick Action Bar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: AppColors.error,
                      ),
                      label: const Text(
                        'Check Challans',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.error.withOpacity(0.5),
                        ),
                      ),
                      onPressed: () {
                        context.push(
                          '/challan?plate=${vehicle.cleanRegistrationNumber}',
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 1: Registration Details
              _buildSectionTitle('REGISTRATION DETAILS', isDark),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(
                        title: 'Registration Number',
                        value: vehicle.registrationNumber,
                        isBold: true,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Registration Date',
                        value: vehicle.registrationDate,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Registering Authority',
                        value: vehicle.registrationAuthority,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'RTO Code & State',
                        value: '${vehicle.rtoCode} (${vehicle.state})',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Vehicle Class',
                        value: vehicle.vehicleClass,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Registration Validity',
                        value: vehicle.registrationValidity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Status',
                        value: vehicle.registrationStatus,
                        isSuccess: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section 2: Vehicle Details
              _buildSectionTitle('VEHICLE & MANUFACTURER DETAILS', isDark),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(
                        title: 'Manufacturer / Maker',
                        value: vehicle.maker,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Commercial Model',
                        value: vehicle.model,
                        isBold: true,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Category & Body Type',
                        value:
                            '${vehicle.vehicleCategory} • ${vehicle.bodyType}',
                      ),
                      const Divider(height: 16),
                      _DetailRow(title: 'Fuel Type', value: vehicle.fuelType),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Engine / Power Capacity',
                        value: vehicle.engineCapacity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Seating Capacity',
                        value: '${vehicle.seatingCapacity} Persons',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Manufacturing Year',
                        value: vehicle.manufacturingYear,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Emission Norms',
                        value: vehicle.emissionStandard,
                      ),
                      const Divider(height: 16),
                      _DetailRow(title: 'Color', value: vehicle.color),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Chassis No (Masked)',
                        value: vehicle.maskedChassisNumber,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Engine No (Masked)',
                        value: vehicle.maskedEngineNumber,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section 3: Owner Details (Privacy-protected)
              _buildSectionTitle(
                'OWNER INFORMATION (PRIVACY PROTECTED)',
                isDark,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(
                        title: 'Owner Name (Masked)',
                        value: vehicle.maskedOwnerName,
                        isBold: true,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Father / Husband Name',
                        value: vehicle.maskedFatherName,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Ownership Serial',
                        value: vehicle.ownershipSerial,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Jurisdiction Area',
                        value: vehicle.maskedAddress,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section 4: Compliance Details (Insurance, PUC, Fitness, Tax, Loan)
              _buildSectionTitle('COMPLIANCE & LEGAL CERTIFICATES', isDark),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(
                        title: 'Insurance Status',
                        value: vehicle.insuranceStatus,
                        isSuccess: vehicle.insuranceStatus == 'ACTIVE',
                        isError: vehicle.insuranceStatus == 'EXPIRED',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Insurance Provider',
                        value: vehicle.insuranceCompany,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Policy Expiry Date',
                        value: vehicle.insuranceValidity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'PUC Certificate Status',
                        value: vehicle.pucStatus,
                        isSuccess:
                            vehicle.pucStatus == 'ACTIVE' ||
                            vehicle.pucStatus == 'EXEMPTED',
                        isError: vehicle.pucStatus == 'EXPIRED',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'PUC Expiry Date',
                        value: vehicle.pucValidity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Fitness Validity Upto',
                        value: vehicle.fitnessValidity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Permit Details',
                        value: vehicle.permitValidity,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Road Tax Details',
                        value:
                            '${vehicle.roadTaxStatus} (${vehicle.roadTaxPaidUpto})',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        title: 'Hypothecation (Financier)',
                        value: vehicle.isHypothecated
                            ? '${vehicle.hypothecationBank ?? "Financed"} • ${vehicle.hypothecationStatus ?? "ACTIVE"}'
                            : 'No Hypothecation (Clean Title)',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDigitalRcSmartCard(VehicleEntity v, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavyDark, AppColors.primaryNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.electricBlue.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.35),
            blurRadius: 18,
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
                  const Icon(Icons.shield, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'UNION OF INDIA • REGISTRATION CERTIFICATE',
                    style: TextStyle(
                      color: Colors.amber.shade300,
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
          const SizedBox(height: 6),
          // Demo vs Verified Gateway Data Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: v.isDemoData
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.registrationNumber,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${v.maker} • ${v.model}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                width: 38,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.shade200),
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final bool isSuccess;
  final bool isError;

  const _DetailRow({
    required this.title,
    required this.value,
    this.isBold = false,
    this.isSuccess = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    if (isSuccess) textColor = AppColors.success;
    if (isError) textColor = AppColors.error;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            VehicleEntity.safeValue(value),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
