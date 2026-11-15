import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../core/widgets/status_badge.dart';

/// VehicleDetailsScreen presents detailed Parivahan RC information.
class VehicleDetailsScreen extends StatelessWidget {
  final String? initialPlate;

  const VehicleDetailsScreen({super.key, this.initialPlate});

  @override
  Widget build(BuildContext context) {
    final plate = initialPlate != null && initialPlate!.isNotEmpty
        ? VehicleNumberFormatter.formatForDisplay(initialPlate!)
        : 'DL 01 AB 1234';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(plate),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to Favourites')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehicle details copied for sharing')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Smart Card RC Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryNavyDark, AppColors.primaryNavy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.electricBlue.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNavy.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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
                        const Icon(Icons.shield, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CERTIFICATE OF REGISTRATION',
                          style: TextStyle(
                            color: Colors.amber.shade300,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const StatusBadge(label: 'ACTIVE', type: BadgeType.active),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  plate,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'MARUTI SUZUKI INDIA LTD • SWIFT VXI 1.2L',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _CardInfoItem(label: 'FUEL', value: 'PETROL'),
                    _CardInfoItem(label: 'CLASS', value: 'LMV (CAR)'),
                    _CardInfoItem(label: 'REG DATE', value: '12-APR-2023'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Compliance Overview Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.security, color: AppColors.success, size: 20),
                            StatusBadge(label: 'ACTIVE', type: BadgeType.active),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Insurance Status', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const Text('Valid till Apr 2027', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.eco, color: AppColors.success, size: 20),
                            StatusBadge(label: 'VALID', type: BadgeType.active),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('PUC Certificate', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const Text('Valid till May 2027', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Specification Details
          Text(
            'REGISTRATION SPECIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _DetailRow(title: 'Registering Authority', value: 'North Delhi RTO (DL-01)'),
                  Divider(height: 16),
                  _DetailRow(title: 'Owner Serial', value: '1st Owner (Masked: R****H K***R)'),
                  Divider(height: 16),
                  _DetailRow(title: 'Emission Norms', value: 'BHARAT STAGE VI (OBD-II PHASE 2)'),
                  Divider(height: 16),
                  _DetailRow(title: 'Fitness Validity', value: 'Valid upto 11-Apr-2038'),
                  Divider(height: 16),
                  _DetailRow(title: 'Road Tax', value: 'Life Time Tax (LTT) Paid'),
                  Divider(height: 16),
                  _DetailRow(title: 'Hypothecation Bank', value: 'HDFC Bank Ltd (Active Loan)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
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
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
