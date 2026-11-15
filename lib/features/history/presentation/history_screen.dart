import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/app_colors.dart';
import 'providers/history_provider.dart';

/// HistoryScreen provides chronological search history with individual delete and clear-all.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final historyItems = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'खोज इतिहास' : 'Search History'),
        actions: [
          if (historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: isHindi ? 'इतिहास साफ़ करें' : 'Clear All History',
              onPressed: () {
                _showClearHistoryDialog(context, ref, isHindi);
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
                        ? 'खोजे गए वाहन स्वचालित रूप से यहाँ दिखाई देंगे'
                        : 'Searched vehicles will appear here for fast access',
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
                final formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(item.searchedAt);

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(historyProvider.notifier).removeSearch(item.id);
                  },
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        context.push('/rc?plate=${item.registrationNumber}');
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
                                    item.formattedPlate,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.makerModel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              onPressed: () {
                                ref.read(historyProvider.notifier).removeSearch(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(isHindi ? 'इतिहास साफ़ करें?' : 'Clear Search History?'),
        content: Text(
          isHindi
              ? 'क्या आप सभी खोज इतिहास रिकॉर्ड हटाना चाहते हैं?'
              : 'This will remove all recent vehicle search history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(historyProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isHindi ? 'इतिहास साफ़ किया गया' : 'Search history cleared'),
                ),
              );
            },
            child: Text(isHindi ? 'साफ़ करें' : 'Clear'),
          ),
        ],
      ),
    );
  }
}
