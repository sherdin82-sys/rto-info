import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/native_bridge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../favourites/presentation/providers/favourites_provider.dart';
import '../../history/presentation/providers/history_provider.dart';

/// SettingsScreen provides theme, language, about, and data management options.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Map<String, dynamic>? _deviceInfo;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final info = await NativeBridge.getDeviceInfo();
    if (mounted) {
      setState(() {
        _deviceInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isHindi = currentLocale.languageCode == 'hi';
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppAppBar(
        title: isHindi ? 'सेटिंग्स' : 'Settings',
        subtitle: isHindi ? 'प्राथमिकताएं व सिस्टम' : 'Preferences & System',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          children: [
            // Section: Appearance
            _buildSectionHeader(
              isHindi ? 'रंगरूप व थीम' : 'Appearance',
              isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              borderRadius: 10,
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    activeColor: AppColors.electricBlue,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    title: Text(
                      isHindi ? 'सिस्टम थीम' : 'System Default',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'डिवाइस सेटिंग्स का पालन करें'
                          : 'Follow device OS dark/light mode',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
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
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  RadioListTile<ThemeMode>(
                    activeColor: AppColors.electricBlue,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    title: Text(
                      isHindi ? 'लाइट मोड' : 'Light Theme',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    value: ThemeMode.light,
                    groupValue: currentThemeMode,
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  RadioListTile<ThemeMode>(
                    activeColor: AppColors.electricBlue,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    title: Text(
                      isHindi ? 'डार्क मोड' : 'Dark Theme',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'ऑटोमोटिव डीप नेवी डिस्प्ले'
                          : 'Automotive deep navy aesthetic',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
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
            const SizedBox(height: AppSpacing.xl),

            // Section: Language
            _buildSectionHeader(isHindi ? 'भाषा चयन' : 'Language', isDark),
            PremiumCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Column(
                children: [
                  RadioListTile<String>(
                    activeColor: AppColors.electricBlue,
                    title: const Text(
                      'English',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Standard automotive interface',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: 'en',
                    groupValue: currentLocale.languageCode,
                    onChanged: (code) {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(SupportedLanguage.english);
                    },
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  RadioListTile<String>(
                    activeColor: AppColors.electricBlue,
                    title: const Text(
                      'हिंदी (Hindi)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'भारतीय राष्ट्रीय मानक इंटरफ़ेस',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: 'hi',
                    groupValue: currentLocale.languageCode,
                    onChanged: (code) {
                      ref
                          .read(localeProvider.notifier)
                          .setLocale(SupportedLanguage.hindi);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section: Native Android Integration
            _buildSectionHeader(
              isHindi
                  ? 'एंड्रॉइड नेटिव प्लेटफॉर्म'
                  : 'Android Native Integration',
              isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.electricBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: const Icon(
                          Icons.android_rounded,
                          size: 20,
                          color: AppColors.electricBlue,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Platform Channel: com.rtoinfo.app/native',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            'Kotlin MainActivity MethodChannel Bridge',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_deviceInfo != null) ...[
                    const Divider(height: AppSpacing.l),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manufacturer / Model',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        Text(
                          '${_deviceInfo!['manufacturer']} ${_deviceInfo!['model']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Android SDK Level',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        Text(
                          'API ${_deviceInfo!['sdk']} (Android ${_deviceInfo!['release']})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section: Data & Privacy
            _buildSectionHeader(
              isHindi ? 'डेटा व गोपनीयता' : 'Data & Privacy',
              isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.s,
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                ),
                title: Text(
                  isHindi ? 'स्थानीय डेटा साफ़ करें' : 'Clear Local App Data',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  isHindi
                      ? 'खोज इतिहास व सुरक्षित पसंदीदा हटाएं'
                      : 'Reset local search history and bookmarked vehicles',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                onTap: () {
                  _showClearDataDialog(context, ref, isHindi);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section: About
            _buildSectionHeader(
              isHindi ? 'एप्लिकेशन के बारे में' : 'About Application',
              isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(AppRadius.s),
                          border: Border.all(
                            color: AppColors.electricBlue,
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car_rounded,
                            color: AppColors.metallicGold,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            'Version ${AppConstants.appVersion} (Build ${AppConstants.buildNumber}) • Pure Flutter Native',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.electricBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    isHindi
                        ? 'आरटीओ इन्फो एक सूचनात्मक भारतीय वाहन सेवा एप्लिकेशन है जो भारत सरकार के केंद्रीय मोटर वाहन नियमों (CMVR 1989) के अनुरूप तैयार की गई है।'
                        : 'RTO Info is a high-performance Indian automotive companion application conforming to MoRTH Parivahan standards and Section 139 of the Central Motor Vehicles Rules.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const Divider(height: AppSpacing.l),
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: AppColors.saffron,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Section 139 CMVR / DPDP Act Compliant',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.s),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(
          isHindi ? 'स्थानीय डेटा साफ़ करें?' : 'Clear App Data?',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        content: Text(
          isHindi
              ? 'क्या आप सभी खोज इतिहास और पसंदीदा वाहन रिकॉर्ड हटाना चाहते हैं?'
              : 'This will reset your cached search history and bookmarked vehicles.',
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
              ref.read(favouritesProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isHindi
                        ? 'डेटा सफलतापूर्वक साफ़ किया गया'
                        : 'Local data successfully cleared',
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
