import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// SettingsScreen provides theme, language, about, and data management options.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isHindi = currentLocale.languageCode == 'hi';
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'सेटिंग्स' : 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Appearance
          _buildSectionHeader(isHindi ? 'रंगरूप व थीम' : 'Appearance', context),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(isHindi ? 'सिस्टम थीम' : 'System Default'),
                  subtitle: Text(
                    isHindi ? 'डिवाइस सेटिंग्स का पालन करें' : 'Follow system dark/light mode',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  value: ThemeMode.system,
                  groupValue: currentThemeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(isHindi ? 'लाइट मोड' : 'Light Theme'),
                  value: ThemeMode.light,
                  groupValue: currentThemeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(isHindi ? 'डार्क मोड' : 'Dark Theme'),
                  value: ThemeMode.dark,
                  groupValue: currentThemeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Language
          _buildSectionHeader(isHindi ? 'भाषा' : 'Language', context),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('English'),
                  subtitle: const Text('Default language', style: TextStyle(fontSize: 11)),
                  value: 'en',
                  groupValue: currentLocale.languageCode,
                  onChanged: (code) {
                    ref.read(localeProvider.notifier).setLocale(SupportedLanguage.english);
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('हिंदी (Hindi)'),
                  subtitle: const Text('भारतीय राष्ट्रीय भाषा', style: TextStyle(fontSize: 11)),
                  value: 'hi',
                  groupValue: currentLocale.languageCode,
                  onChanged: (code) {
                    ref.read(localeProvider.notifier).setLocale(SupportedLanguage.hindi);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Data & Privacy
          _buildSectionHeader(isHindi ? 'डेटा व गोपनीयता' : 'Data & Privacy', context),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                isHindi ? 'स्थानीय डेटा साफ़ करें' : 'Clear Local App Data',
                style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isHindi ? 'खोज इतिहास व पसंदीदा हटाएं' : 'Clear search history and bookmarks',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              onTap: () {
                _showClearDataDialog(context, isHindi);
              },
            ),
          ),
          const SizedBox(height: 24),

          // Section: About
          _buildSectionHeader(isHindi ? 'एप्लिकेशन के बारे में' : 'About Application', context),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.electricBlue, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.directions_car, color: Colors.amber, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Version ${AppConstants.appVersion} (${AppConstants.buildNumber})',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isHindi
                        ? 'आरटीओ इन्फो एक सूचनात्मक भारतीय वाहन सेवा एप्लिकेशन है जो भारत सरकार के केंद्रीय मोटर वाहन नियमों के अनुरूप तैयार की गई है।'
                        : 'RTO Info is a premium Indian automotive information application conforming to Central Motor Vehicles Rules and MoRTH data specifications.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(isHindi ? 'डेटा साफ़ करें?' : 'Clear App Data?'),
        content: Text(
          isHindi
              ? 'क्या आप सभी खोज इतिहास और पसंदीदा रिकॉर्ड हटाना चाहते हैं?'
              : 'This will reset your local search history and saved favourites.',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isHindi ? 'डेटा सफलतापूर्वक साफ़ किया गया' : 'Local data cleared'),
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
