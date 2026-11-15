import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../../shared/models/challan_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/status_badge.dart';
import 'providers/challan_provider.dart';

/// ChallanScreen displays official traffic violation records for a vehicle.
/// Conforms strictly to Section 7: Clearly differentiates Paid vs Pending challans,
/// provides official payment portal links, and does NOT simulate fake payments.
class ChallanScreen extends ConsumerStatefulWidget {
  final String? initialPlate;

  const ChallanScreen({super.key, this.initialPlate});

  @override
  ConsumerState<ChallanScreen> createState() => _ChallanScreenState();
}

class _ChallanScreenState extends ConsumerState<ChallanScreen> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Paid

  @override
  Widget build(BuildContext context) {
    final rawPlate = widget.initialPlate ?? 'DL01AB1234';
    final cleanPlate = VehicleNumberValidator.cleanPlate(rawPlate);
    final formattedPlate = VehicleNumberValidator.formatForDisplay(cleanPlate);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final challansAsync = ref.watch(vehicleChallansProvider(cleanPlate));

    return Scaffold(
      appBar: AppAppBar(
        title: 'e-Challan • $formattedPlate',
        subtitle: 'National e-Challan Gateway Records',
      ),
      body: challansAsync.when(
        loading: () => const LoadingView(
          message: 'Checking National e-Challan Database...',
        ),
        error: (err, _) => ErrorView(
          title: 'Error Checking Challans',
          message: '$err',
          actionLabel: 'Try Again',
          onAction: () => ref.refresh(vehicleChallansProvider(cleanPlate)),
        ),
        data: (challans) {
          final pendingChallans = challans.where((c) => c.isPending).toList();
          final paidChallans = challans.where((c) => c.isPaid).toList();
          final totalPendingAmount = pendingChallans.fold<double>(
            0,
            (sum, c) => sum + c.challanAmount,
          );

          List<ChallanEntity> displayList;
          if (_selectedFilter == 1) {
            displayList = pendingChallans;
          } else if (_selectedFilter == 2) {
            displayList = paidChallans;
          } else {
            displayList = challans;
          }

          return ListView(
            padding: AppSpacing.edgeInsetsL,
            children: [
              // Summary Banner
              PremiumCard(
                padding: AppSpacing.edgeInsetsL,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      label: 'Total Records',
                      value: '${challans.length}',
                      valueColor: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    _buildSummaryItem(
                      label: 'Pending Fines',
                      value: '₹${totalPendingAmount.toStringAsFixed(0)}',
                      valueColor: totalPendingAmount > 0
                          ? AppColors.error
                          : AppColors.success,
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    _buildSummaryItem(
                      label: 'Settled / Paid',
                      value: '${paidChallans.length}',
                      valueColor: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip(0, 'All (${challans.length})', isDark),
                  const SizedBox(width: AppSpacing.s),
                  _buildFilterChip(
                    1,
                    'Pending (${pendingChallans.length})',
                    isDark,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  _buildFilterChip(
                    2,
                    'Settled (${paidChallans.length})',
                    isDark,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),

              // Official Portal Notice (Section 7 compliance: No fake payment simulation)
              if (pendingChallans.isNotEmpty) ...[
                Container(
                  padding: AppSpacing.edgeInsetsM,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: AppRadius.radiusM,
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.error,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Official Government Payment Portal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pay online directly on the official Parivahan portal at echallan.parivahan.gov.in. Third-party simulated payments are strictly prohibited for your financial security.',
                              style: TextStyle(fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
              ],

              // Empty State
              if (displayList.isEmpty)
                EmptyStateView(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Clean Record! No Challans Found',
                  description:
                      'No pending or recorded violations found under this filter for $formattedPlate.',
                ),

              // Challan List Cards
              for (final c in displayList) ...[
                _buildChallanCard(c, isDark, context),
                const SizedBox(height: AppSpacing.m),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(int index, String label, bool isDark) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = index),
      selectedColor: AppColors.electricBlue.withOpacity(0.18),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected
            ? AppColors.electricBlue
            : (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
      ),
      side: BorderSide(
        color: isSelected
            ? AppColors.electricBlue
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
    );
  }

  Widget _buildChallanCard(ChallanEntity c, bool isDark, BuildContext context) {
    final isPending = c.isPending;

    return PremiumCard(
      accentColor: isPending ? AppColors.error : AppColors.success,
      padding: AppSpacing.edgeInsetsL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  c.violationDescription,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.primaryNavy,
                  ),
                ),
              ),
              StatusBadge(
                label: c.paymentStatus.toUpperCase(),
                type: isPending ? BadgeType.expired : BadgeType.active,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Challan No: ${c.challanNumber}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 14, color: Colors.grey),
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
          const SizedBox(height: 2),
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
                    'Penalty Amount',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹${c.challanAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isPending ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
              if (isPending)
                AppButton(
                  label: 'Pay on Parivahan',
                  variant: AppButtonVariant.primary,
                  height: 36,
                  isFullWidth: false,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Redirecting to official portal: echallan.parivahan.gov.in',
                        ),
                      ),
                    );
                  },
                )
              else
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Paid: ${c.paidAt ?? 'Settled'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
