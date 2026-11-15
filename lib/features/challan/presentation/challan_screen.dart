import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../core/widgets/status_badge.dart';

/// ChallanScreen displays official traffic violation records.
class ChallanScreen extends StatelessWidget {
  final String? initialPlate;

  const ChallanScreen({super.key, this.initialPlate});

  @override
  Widget build(BuildContext context) {
    final plate = initialPlate != null && initialPlate!.isNotEmpty
        ? VehicleNumberFormatter.formatForDisplay(initialPlate!)
        : 'DL 01 AB 1234';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final challans = [
      {
        'challanNo': 'DL240819004291',
        'violation': 'Over Speeding (LMV/Two Wheeler)',
        'section': 'Section 183(1) MV Act',
        'date': '14-Oct-2026, 11:24 AM',
        'amount': '₹2,000',
        'status': 'PENDING',
        'location': 'Ring Road near Kashmere Gate ISBT, North Delhi',
      },
      {
        'challanNo': 'DL240702008819',
        'violation': 'Zebra Crossing / Stop Line Violation',
        'section': 'Section 177 MV Act',
        'date': '05-Aug-2026, 09:12 AM',
        'amount': '₹500',
        'status': 'PAID',
        'location': 'ITO Junction Signal, New Delhi',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('e-Challan • $plate'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total Fines Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Total Records', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      '${challans.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.3)),
                Column(
                  children: const [
                    Text('Pending Fine', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(
                      '₹2,000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'VIOLATION RECORDS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Challan Items
          for (final c in challans) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c['challanNo']!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        StatusBadge(
                          label: c['status']!,
                          type: c['status'] == 'PAID' ? BadgeType.active : BadgeType.expired,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      c['violation']!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['section']!,
                      style: const TextStyle(fontSize: 12, color: AppColors.saffron, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            c['location']!,
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
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          c['date']!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fine Amount:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          c['amount']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
