import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/app_colors.dart';

/// HistoryScreen shows recently searched vehicle records.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Demo recent history items
    final historyItems = [
      {
        'plate': 'DL01AB1234',
        'display': 'DL 01 AB 1234',
        'maker': 'Maruti Suzuki Swift VXI',
        'time': 'Today, 10:30 AM',
        'class': 'Motor Car (LMV)'
      },
      {
        'plate': 'MH12DE1433',
        'display': 'MH 12 DE 1433',
        'maker': 'Hyundai Creta CRDi',
        'time': 'Yesterday, 04:15 PM',
        'class': 'Motor Car (LMV)'
      },
      {
        'plate': 'KA05MJ5005',
        'display': 'KA 05 MJ 5005',
        'maker': 'Tata Nexon EV Long Range',
        'time': '12 Nov 2026',
        'class': 'Electric Car'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'खोज इतिहास' : 'Search History'),
        actions: [
          if (historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: isHindi ? 'इतिहास साफ़ करें' : 'Clear History',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isHindi ? 'इतिहास साफ़ किया गया' : 'History cleared'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isHindi ? 'कोई खोज इतिहास नहीं है' : 'No search history yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHindi
                      ? 'आपकी हालिया खोजें यहाँ दिखाई देंगी'
                      : 'Your recent vehicle lookups will appear here',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = historyItems[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      context.push('/rc?plate=${item['plate']}');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryNavy.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: AppColors.electricBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['display']!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['maker']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['time']!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
