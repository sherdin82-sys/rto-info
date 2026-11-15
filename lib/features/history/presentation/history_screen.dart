import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/premium_card.dart';
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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: isHindi ? 'खोज इतिहास' : 'Search History',
        subtitle: isHindi
            ? '${historyItems.length} वाहन रिकॉर्ड्स'
            : '${historyItems.length} cached vehicle searches',
        actions: [
          if (historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: isHindi ? 'इतिहास साफ़ करें' : 'Clear All History',
              color: AppColors.error,
              onPressed: () {
                _showClearHistoryDialog(context, ref, isHindi);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: historyItems.isEmpty
            ? EmptyStateView(
                icon: Icons.history_rounded,
                title: isHindi
                    ? 'कोई खोज इतिहास नहीं है'
                    : 'No Search History Yet',
                description: isHindi
                    ? 'खोजे गए वाहन त्वरित पहुँच के लिए स्वचालित रूप से यहाँ सुरक्षित होते हैं।'
                    : 'Searched vehicle registration numbers are saved locally for fast one-tap access.',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                itemCount: historyItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  final formattedTime = DateFormat('dd MMM yyyy, hh:mm a')
                      .format(item.searchedAt);

                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 14),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onDismissed: (_) {
                      ref.read(historyProvider.notifier).removeSearch(item.id);
                    },
                    child: PremiumCard(
                      onTap: () {
                        context.push('/rc?plate=${item.registrationNumber}');
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      borderRadius: 10,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.electricBlue.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.directions_car_rounded,
                              color: AppColors.electricBlue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkSurfaceAlt
                                            : AppColors.lightSurfaceAlt,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.darkBorder
                                              : AppColors.lightBorder,
                                        ),
                                      ),
                                      child: Text(
                                        item.formattedPlate,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.makerModel,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 11,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                            tooltip: 'Remove',
                            onPressed: () {
                              ref
                                  .read(historyProvider.notifier)
                                  .removeSearch(item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    WidgetRef ref,
    bool isHindi,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(
          isHindi ? 'इतिहास साफ़ करें?' : 'Clear Search History?',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        content: Text(
          isHindi
              ? 'क्या आप सभी हालिया खोज रिकॉर्ड स्थायी रूप से हटाना चाहते हैं?'
              : 'This will remove all recent vehicle search history cached on this device.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(historyProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isHindi ? 'इतिहास साफ़ किया गया' : 'Search history cleared',
                  ),
                ),
              );
            },
            child: Text(isHindi ? 'साफ़ करें' : 'Clear All'),
          ),
        ],
      ),
    );
  }
}
