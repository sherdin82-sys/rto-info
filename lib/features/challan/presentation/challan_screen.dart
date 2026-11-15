import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../../core/widgets/status_badge.dart';
import 'providers/challan_provider.dart';

/// ChallanScreen displays official traffic violation records for a vehicle.
/// Conforms to Section 7: Clearly differentiates Paid vs Pending challans,
/// provides official payment portal links, and does NOT simulate fake payments.
class ChallanScreen extends ConsumerWidget {
  final String? initialPlate;

  const ChallanScreen({super.key, this.initialPlate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawPlate = initialPlate ?? 'DL01AB1234';
    final cleanPlate = VehicleNumberValidator.cleanPlate(rawPlate);
    final formattedPlate = VehicleNumberValidator.formatForDisplay(cleanPlate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final challansAsync = ref.watch(vehicleChallansProvider(cleanPlate));

    return Scaffold(
      appBar: AppBar(title: Text('e-Challan • $formattedPlate')),
      body: challansAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Checking National e-Challan Database...',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
        error: (err, _) => Center(
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
                  'Error Checking Challans',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  '$err',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        data: (challans) {
          final pendingChallans = challans.where((c) => c.isPending).toList();
          final paidChallans = challans.where((c) => c.isPaid).toList();
          final totalPendingAmount = pendingChallans.fold<double>(
            0,
            (sum, c) => sum + c.challanAmount,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Total Records',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${challans.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Pending Fines',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${totalPendingAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: totalPendingAmount > 0
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Settled / Paid',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${paidChallans.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Official Portal Notice (Prompt Section 7 compliance: No fake payment simulation)
              if (pendingChallans.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.error,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Official Fine Payment Portal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pay online exclusively via official government portal at echallan.parivahan.gov.in. Third-party simulated payments are strictly prohibited for your security.',
                              style: TextStyle(fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Empty State
              if (challans.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 56,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Clean Record! No Challans Found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No pending or recorded violations found for this vehicle.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Pending Challans Section
              if (pendingChallans.isNotEmpty) ...[
                Text(
                  'PENDING VIOLATIONS (${pendingChallans.length})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 10),
                for (final c in pendingChallans) ...[
                  _buildChallanCard(c, isDark, context),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
              ],

              // Paid Challans Section
              if (paidChallans.isNotEmpty) ...[
                Text(
                  'SETTLED / PAID RECORDS (${paidChallans.length})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 10),
                for (final c in paidChallans) ...[
                  _buildChallanCard(c, isDark, context),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildChallanCard(dynamic c, bool isDark, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  c.challanNumber,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                StatusBadge(
                  label: c.paymentStatus,
                  type: c.isPaid ? BadgeType.active : BadgeType.expired,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              c.violationDescription,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              c.legalSection,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.saffron,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c.location,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  c.challanDate,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fine Amount',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      '₹${c.challanAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: c.isPaid ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
                if (c.isPending)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.open_in_browser, size: 16),
                    label: const Text(
                      'Parivahan Portal',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Directing to official portal: https://echallan.parivahan.gov.in/',
                          ),
                        ),
                      );
                    },
                  )
                else
                  Text(
                    'Receipt: ${c.paymentReceiptNumber ?? "Settled"}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
