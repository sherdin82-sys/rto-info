import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/dl_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/status_badge.dart';
import 'providers/dl_provider.dart';

/// DlScreen handles Driving Licence verification adhering to Sarathi Parivahan standards.
class DlScreen extends ConsumerStatefulWidget {
  const DlScreen({super.key});

  @override
  ConsumerState<DlScreen> createState() => _DlScreenState();
}

class _DlScreenState extends ConsumerState<DlScreen> {
  final _dlController = TextEditingController(text: 'DL0420110149632');
  final _dobController = TextEditingController(text: '1990-05-14');
  String _activeSearchDl = 'DL0420110149632';

  @override
  void dispose() {
    _dlController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _search() {
    final clean = _dlController.text.trim();
    if (clean.isNotEmpty) {
      setState(() {
        _activeSearchDl = clean;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dlAsync = ref.watch(dlDetailsProvider(_activeSearchDl));

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Driving Licence Verification',
        subtitle: 'Sarathi National Register Portal',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        children: [
          // DL Search Box
          PremiumCard(
            padding: const EdgeInsets.all(12),
            borderRadius: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _dlController,
                  label: 'DRIVING LICENCE NUMBER',
                  hint: 'e.g. DL0420110149632',
                  prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => _search(),
                  onClear: () => _dlController.clear(),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _dobController,
                  label: 'DATE OF BIRTH (YYYY-MM-DD)',
                  hint: '1990-05-14',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                  ),
                  onSubmitted: (_) => _search(),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Verify Licence with Sarathi',
                  icon: const Icon(
                    Icons.verified,
                    size: 17,
                    color: Colors.white,
                  ),
                  variant: AppButtonVariant.primary,
                  height: 38,
                  onPressed: _search,
                ),
                const SizedBox(height: 8),
                // Quick Sample Pills
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Sample:',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    _sampleChip('DL0420110149632', 'Delhi (LMV+Bike)', isDark),
                    _sampleChip('MH1420180019284', 'Maharashtra (Cab)', isDark),
                    _sampleChip('KA0120150038192', 'Karnataka (Car)', isDark),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // DL Results
          dlAsync.when(
            loading: () => const LoadingView(
              message: 'Verifying Driving Licence with Sarathi...',
            ),
            error: (err, stack) => ErrorView(
              title: 'Error Verifying Licence',
              message: '$err',
              actionLabel: 'Try Again',
              onAction: _search,
            ),
            data: (dl) {
              if (dl == null) {
                return EmptyStateView(
                  icon: Icons.search_off_rounded,
                  title: 'No Driving Licence Found',
                  description:
                      'Please check the DL number and date of birth format.',
                );
              }

              return _buildDlCardAndDetails(dl, isDark);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _sampleChip(String dlNum, String label, bool isDark) {
    return InkWell(
      onTap: () {
        _dlController.text = dlNum;
        _search();
      },
      borderRadius: AppRadius.radiusS,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
          borderRadius: AppRadius.radiusS,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDlCardAndDetails(DlEntity dl, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sarathi Digital DL Smart Card
        Container(
          padding: AppSpacing.edgeInsetsXl,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF042F2E), Color(0xFF0D9488), Color(0xFF115E59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.radiusXl,
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: AppRadius.radiusXs,
                        ),
                        child: const Text(
                          'SARATHI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      const Text(
                        'UNION OF INDIA • DRIVING LICENCE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  StatusBadge(
                    label: dl.status,
                    type: dl.status == 'ACTIVE'
                        ? BadgeType.active
                        : BadgeType.expired,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dl.dlNumber,
                        style: AppTypography.hsrpPlate(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dl.holderName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  // Gold EMV Chip Visual
                  Container(
                    width: 38,
                    height: 28,
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
                      border: Border.all(color: Colors.white70),
                    ),
                    child: const Icon(
                      Icons.memory,
                      color: Colors.black87,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DlInfoItem(label: 'AUTHORITY', value: dl.issuingAuthority),
                  _DlInfoItem(label: 'ISSUE DATE', value: dl.issueDate),
                  _DlInfoItem(
                    label: 'NON-TRANS',
                    value: dl.validityNonTransport,
                  ),
                  _DlInfoItem(label: 'TRANSPORT', value: dl.validityTransport),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Endorsement Vehicle Classes
        Text(
          'AUTHORIZED VEHICLE CLASSES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: isDark
                ? AppColors.electricBlueLight
                : AppColors.electricBlue,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final cov in dl.vehicleClasses)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius: AppRadius.radiusM,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 16,
                      color: AppColors.electricBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cov.classCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Detail Breakdown Card
        PremiumCard(
          child: Column(
            children: [
              _DlDetailRow(
                title: 'Issuing Authority',
                value: dl.issuingAuthority,
              ),
              const Divider(height: 20),
              _DlDetailRow(title: 'State', value: dl.state),
              const Divider(height: 20),
              _DlDetailRow(title: 'Blood Group', value: dl.bloodGroup),
              const Divider(height: 20),
              _DlDetailRow(
                title: 'Father / Guardian',
                value: dl.maskedFatherName,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DlInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _DlInfoItem({required this.label, required this.value});

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
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DlDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DlDetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
