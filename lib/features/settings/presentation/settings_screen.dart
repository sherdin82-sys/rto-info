import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/native_bridge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../favourites/presentation/providers/favourites_provider.dart';
import '../../history/presentation/providers/history_provider.dart';

/// SettingsScreen provides an authentic, high-density Indian vehicle management settings interface.
/// Features digital garage statistics, appearance & language switchers, regional fuel/RTO preferences,
/// smart violation & expiry alerts, CMVR Rule 139 statutory compliance vault, roadside emergency directory,
/// local data management, and native hardware diagnostics.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Map<String, dynamic>? _deviceInfo;
  int _batteryLevel = -1;
  bool _isNetworkOnline = true;

  // Regional & Vahan Discovery Preferences
  String _selectedCity = 'Delhi NCR';
  String _preferredFuel = 'Petrol'; // Petrol, Diesel, CNG, Electric
  String _defaultVehicleClass = 'Car'; // Car, Bike, Commercial

  // Smart Alert Toggles
  bool _challanAlerts = true;
  bool _insuranceAlerts = true;
  bool _puccAlerts = true;
  bool _dailyFuelTicker = true;
  bool _offlineCache = true;

  // Expandable Diagnostics Card
  bool _isDiagnosticsExpanded = false;

  static const List<String> _indianCities = [
    'Delhi NCR',
    'Gurgaon',
    'Noida',
    'Mumbai',
    'Bengaluru',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Chandigarh',
    'Bhopal',
  ];

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    final info = await NativeBridge.getDeviceInfo();
    final battery = await NativeBridge.getBatteryLevel();
    final online = await NativeBridge.isNetworkAvailable();
    if (mounted) {
      setState(() {
        _deviceInfo = info;
        _batteryLevel = battery;
        _isNetworkOnline = online;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isHindi = currentLocale.languageCode == 'hi';
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final historyList = ref.watch(historyProvider);
    final favouritesList = ref.watch(favouritesProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF080D1A)
          : const Color(0xFFF6F8FC),
      appBar: AppAppBar(
        title: isHindi ? 'सेटिंग्स व प्राथमिकताएं' : 'Settings & Preferences',
        subtitle: isHindi
            ? 'वाहन गैराज, वैधानिक अनुपालन व सिस्टम'
            : 'Vehicle garage, statutory compliance & system',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          children: [
            // 1. DIGITAL VEHICLE PROFILE & GARAGE SUMMARY CARD
            _buildProfileSummaryCard(
              context: context,
              isDark: isDark,
              isHindi: isHindi,
              garageCount: favouritesList.length,
              historyCount: historyList.length,
            ),

            const SizedBox(height: 18),

            // 2. APPEARANCE & THEME (MODERN SEGMENTED SELECTOR)
            _buildSectionHeader(
              title: isHindi
                  ? 'रंगरूप व डिस्प्ले थीम'
                  : 'Appearance & Display Theme',
              icon: Icons.palette_outlined,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'एप्लिकेशन का रंगरूप चुनें:'
                        : 'Choose your visual preference:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildThemeSegment(
                          mode: ThemeMode.system,
                          label: isHindi ? 'सिस्टम' : 'System',
                          sublabel: isHindi ? 'ऑटो' : 'Auto',
                          icon: Icons.brightness_auto_rounded,
                          currentMode: currentThemeMode,
                          isDark: isDark,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.system),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildThemeSegment(
                          mode: ThemeMode.light,
                          label: isHindi ? 'लाइट' : 'Light',
                          sublabel: isHindi ? 'दिन' : 'Day',
                          icon: Icons.light_mode_rounded,
                          currentMode: currentThemeMode,
                          isDark: isDark,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.light),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildThemeSegment(
                          mode: ThemeMode.dark,
                          label: isHindi ? 'डार्क' : 'Dark',
                          sublabel: isHindi ? 'नेवी' : 'Navy',
                          icon: Icons.dark_mode_rounded,
                          currentMode: currentThemeMode,
                          isDark: isDark,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.dark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3. REGIONAL LANGUAGE (ENGLISH / HINDI)
            _buildSectionHeader(
              title: isHindi ? 'भाषा चयन (Language)' : 'Language Preferences',
              icon: Icons.translate_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'पसंदीदा क्षेत्रीय भाषा चुनें:'
                        : 'Select your preferred interface language:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLanguageSegment(
                          languageCode: 'en',
                          title: 'English',
                          subtitle: 'Standard Automotive UI',
                          isSelected: currentLocale.languageCode == 'en',
                          isDark: isDark,
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .setLocale(SupportedLanguage.english),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLanguageSegment(
                          languageCode: 'hi',
                          title: 'हिंदी (Hindi)',
                          subtitle: 'भारतीय राष्ट्रीय मानक',
                          isSelected: currentLocale.languageCode == 'hi',
                          isDark: isDark,
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .setLocale(SupportedLanguage.hindi),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 4. REGIONAL & VEHICLE DISCOVERY PREFERENCES
            _buildSectionHeader(
              title: isHindi
                  ? 'क्षेत्रीय व वाहन प्राथमिकताएं'
                  : 'Regional & Vehicle Discovery',
              icon: Icons.tune_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              borderRadius: 14,
              child: Column(
                children: [
                  // Default City Selector
                  InkWell(
                    onTap: () =>
                        _showCitySelectorSheet(context, isDark, isHindi),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF0066FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isHindi
                                      ? 'डिफ़ॉल्ट शहर (ईंधन व आरटीओ)'
                                      : 'Primary City (Fuel & RTO)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isHindi
                                      ? 'वर्तमान: $_selectedCity • दैनिक दरों के लिए'
                                      : 'Selected: $_selectedCity • Used for fuel rates ticker',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _selectedCity,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0066FF),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: Color(0xFF0066FF),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    height: 18,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),

                  // Preferred Fuel Type Filter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isHindi
                                ? 'पसंदीदा ईंधन प्रकार'
                                : 'Preferred Fuel Type',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            _preferredFuel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFuelChip(
                              'Petrol',
                              'पेट्रोल',
                              const Color(0xFFEF4444),
                              isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildFuelChip(
                              'Diesel',
                              'डीज़ल',
                              const Color(0xFF3B82F6),
                              isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildFuelChip(
                              'CNG',
                              'सीएनजी',
                              const Color(0xFF10B981),
                              isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildFuelChip(
                              'Electric',
                              'इलेक्ट्रिक (EV)',
                              const Color(0xFF8B5CF6),
                              isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    height: 18,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),

                  // Default Vehicle Category
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isHindi
                                ? 'डिफ़ॉल्ट खोज श्रेणी'
                                : 'Default Discovery Category',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            _defaultVehicleClass,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryChip(
                              id: 'Car',
                              title: isHindi ? 'कार (LMV)' : 'Cars (LMV)',
                              icon: Icons.directions_car_rounded,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCategoryChip(
                              id: 'Bike',
                              title: isHindi ? 'बाइक (2W)' : 'Bikes (2W)',
                              icon: Icons.two_wheeler_rounded,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCategoryChip(
                              id: 'Commercial',
                              title: isHindi ? 'कमर्शियल' : 'Commercial',
                              icon: Icons.local_shipping_rounded,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 5. SMART VEHICLE ALERTS & NOTIFICATIONS
            _buildSectionHeader(
              title: isHindi
                  ? 'स्मार्ट वाहन अलर्ट व सूचनाएं'
                  : 'Smart Alerts & Reminders',
              icon: Icons.notifications_active_outlined,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              borderRadius: 14,
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: const Color(0xFF0066FF),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi
                          ? 'ई-चालान बकाया सूचना'
                          : 'Traffic e-Challan Alerts',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'वर्चुअल कोर्ट नोटिस या नए लंबित चालान पर सूचना दें'
                          : 'Alert when new virtual court or traffic notice is recorded',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    value: _challanAlerts,
                    onChanged: (val) => setState(() => _challanAlerts = val),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),
                  SwitchListTile(
                    activeColor: const Color(0xFF0066FF),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi
                          ? 'बीमा समाप्ति चेतावनी'
                          : 'Insurance Expiry Reminder',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'पॉलिसी समाप्त होने के ३० व ७ दिन पूर्व सतर्क करें'
                          : 'Proactive alerts 30 days & 7 days prior to policy lapse',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    value: _insuranceAlerts,
                    onChanged: (val) => setState(() => _insuranceAlerts = val),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),
                  SwitchListTile(
                    activeColor: const Color(0xFF0066FF),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi
                          ? 'प्रदूषण प्रमाणपत्र (PUCC) नवीनीकरण'
                          : 'PUCC Emission Certificate Alerts',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? '६-माह अथवा १-वर्ष उत्सर्जन वैधता समाप्ति से पहले याद दिलाएं'
                          : 'Remind before mandatory 6-month / 1-year certificate expiry',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    value: _puccAlerts,
                    onChanged: (val) => setState(() => _puccAlerts = val),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),
                  SwitchListTile(
                    activeColor: const Color(0xFF0066FF),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_gas_station_rounded,
                        color: Color(0xFF0066FF),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi ? 'दैनिक ईंधन दर टिकर' : 'Daily Fuel Rate Ticker',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'प्रातः ०६:०० बजे चुनिंदा शहर के लिए पेट्रोल, डीज़ल व सीएनजी अपडेट'
                          : 'Receive 6:00 AM daily price revisions for your selected metro',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    value: _dailyFuelTicker,
                    onChanged: (val) => setState(() => _dailyFuelTicker = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 6. PARIVAHAN & CMVR 139 STATUTORY COMPLIANCE VAULT
            _buildSectionHeader(
              title: isHindi
                  ? 'परिवहन वैधानिक अनुपालन'
                  : 'Parivahan Statutory Compliance',
              icon: Icons.gavel_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi
                                  ? 'सीएमवीआर नियम १३९ डिजिटल वैधता'
                                  : 'CMVR Rule 139 Digital Validity',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              isHindi
                                  ? 'एमओआरटीएच व आईटी अधिनियम २००० के तहत मान्य'
                                  : 'Legally approved under MoRTH Notification & IT Act 2000',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            _showCmvrLegalSheet(context, isDark, isHindi),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isHindi ? 'विवरण' : 'Notice',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isHindi
                          ? '• ट्रैफिक पुलिस या आरटीओ अधिकारी द्वारा निरीक्षण के समय डिजिटल आरसी व ड्राइविंग लाइसेंस पूर्णतः वैध हैं।\n• भौतिक मूल दस्तावेज जब्त करने के विशेष आदेश के बिना मूल प्रपत्र मांगना अनिवार्य नहीं है।'
                          : '• Electronic presentation of RC, DL, Insurance & Permit is legally valid at par with physical originals per MoRTH Circular RT-11036/64/2017-MVL.\n• Enforcement agencies cannot insist on physical documents during routine checks.',
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.45,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Privacy Masking Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 15,
                            color: Color(0xFF0066FF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isHindi
                                ? 'डीपीडीपी अधिनियम २०२३ गोपनीयता:'
                                : 'DPDP Act 2023 Masking:',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Active • Masked',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Offline Cache Toggle
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF0066FF),
                    title: Text(
                      isHindi
                          ? 'ऑफ़लाइन वाहन स्मार्ट कार्ड कैश'
                          : 'Offline Vehicle Smart Card Cache',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'इंटरनेट न होने पर भी सहेजे गए वाहन रिकॉर्ड प्रदर्शित करें'
                          : 'Keep inspected RC smart cards accessible during highway checks',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    value: _offlineCache,
                    onChanged: (val) => setState(() => _offlineCache = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 7. ALL-INDIA HIGHWAY & ROADSIDE EMERGENCY DIRECTORY
            _buildSectionHeader(
              title: isHindi
                  ? 'अखिल भारतीय आपातकालीन हेल्पलाइन'
                  : 'Roadside Emergency Helplines',
              icon: Icons.emergency_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? '२४x७ आधिकारिक राष्ट्रीय आपातकालीन नंबर:'
                        : 'Official 24x7 Government Emergency Helplines:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEmergencyTile(
                          number: '112',
                          title: isHindi ? 'राष्ट्रीय आपात' : 'All-in-One 112',
                          subtitle: 'Police • Fire • Medical',
                          color: const Color(0xFFEF4444),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildEmergencyTile(
                          number: '1033',
                          title: isHindi ? 'एनएचएआई हाईवे' : 'NHAI Highway',
                          subtitle: '24x7 Roadside & Towing',
                          color: const Color(0xFF0066FF),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEmergencyTile(
                          number: '1073',
                          title: isHindi ? 'सड़क दुर्घटना' : 'Road Accident',
                          subtitle: 'Immediate First Response',
                          color: const Color(0xFFF59E0B),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildEmergencyTile(
                          number: '108',
                          title: isHindi ? 'एम्बुलेंस सेवा' : 'Ambulance 108',
                          subtitle: 'Medical Emergency Unit',
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 8. STORAGE, CACHE & LOCAL DATA MANAGEMENT
            _buildSectionHeader(
              title: isHindi
                  ? 'डेटा व स्थानीय स्टोरेज'
                  : 'Data & Local Storage',
              icon: Icons.storage_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              child: Column(
                children: [
                  // Storage metrics row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCol(
                          label: isHindi ? 'खोज इतिहास' : 'Search Cache',
                          value: '${historyList.length}',
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                        _buildMetricCol(
                          label: isHindi ? 'गैराज वाहन' : 'Saved Garage',
                          value: '${favouritesList.length}',
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                        _buildMetricCol(
                          label: isHindi ? 'स्थानीय आकार' : 'Est. Storage',
                          value: '< 2 MB',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Clear search history
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi ? 'खोज इतिहास मिटाएं' : 'Clear Search History',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'सहेजे गए पसंदीदा वाहनों को बिना छुए केवल हालिया खोजें हटाएं'
                          : 'Remove cached vehicle search queries without affecting garage',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                    onTap: () => _confirmClearHistory(context, ref, isHindi),
                  ),

                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF223150)
                        : const Color(0xFFE2E8F0),
                  ),

                  // Clear all data
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      isHindi
                          ? 'संपूर्ण स्थानीय डेटा साफ़ करें'
                          : 'Reset All Local Application Data',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    subtitle: Text(
                      isHindi
                          ? 'सभी खोज इतिहास व डिजिटल गैराज रिकॉर्ड पूरी तरह साफ़ करें'
                          : 'Clear search history, favourites, and cached parameters completely',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                    onTap: () => _showClearDataDialog(context, ref, isHindi),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 9. SYSTEM & HARDWARE DIAGNOSTICS (COLLAPSIBLE ACCORDION)
            PremiumCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 14,
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(
                      () => _isDiagnosticsExpanded = !_isDiagnosticsExpanded,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.developer_board_rounded,
                            color: Color(0xFF0066FF),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi
                                    ? 'सिस्टम व हार्डवेयर डायग्नोस्टिक्स'
                                    : 'Device & System Diagnostics',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                isHindi ? 'नेटिव एंड्रॉइड ब्रिज व स्पेक्स' : 'Native Android MethodChannel specifications',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _isDiagnosticsExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF0066FF),
                        ),
                      ],
                    ),
                  ),

                  if (_isDiagnosticsExpanded) ...[
                    const Divider(height: 16),
                    _buildDiagnosticRow(
                      'Android Device',
                      _deviceInfo != null
                          ? '${_deviceInfo!['manufacturer']} ${_deviceInfo!['model']}'
                          : 'Android Handset',
                      isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildDiagnosticRow(
                      'OS Release / API Level',
                      _deviceInfo != null
                          ? 'Android ${_deviceInfo!['release']} (SDK ${_deviceInfo!['sdk']})'
                          : 'API 34 (Android 14)',
                      isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildDiagnosticRow(
                      'Kotlin Native Channel',
                      'com.rtoinfo.app/native • Connected',
                      isDark,
                      valueColor: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 6),
                    _buildDiagnosticRow(
                      'Device Battery Level',
                      _batteryLevel >= 0 ? '$_batteryLevel%' : 'Available',
                      isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildDiagnosticRow(
                      'Network Connectivity',
                      _isNetworkOnline ? 'Online (Active)' : 'Offline',
                      isDark,
                      valueColor: _isNetworkOnline
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 10. ABOUT RTO INFO, COMMUNITY & STATUTORY LEGAL DISCLAIMER
            _buildSectionHeader(
              title: isHindi ? 'एप्लिकेशन के बारे में' : 'About & Disclaimers',
              icon: Icons.info_outline_rounded,
              isDark: isDark,
            ),
            PremiumCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF003399), Color(0xFF0066FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0066FF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppConstants.appName,
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w900,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'STABLE',
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Version ${AppConstants.appVersion} (Build ${AppConstants.buildNumber}) • 100% Flutter Native',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Quick Action Buttons Row (Share, Rate, Rules)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            NativeBridge.shareVehicleDetails(
                              'Discover vehicle RC details, pending e-challans, and live fuel rates on RTO Info! Download: https://github.com/sherdin82-sys/rto-info/releases/latest',
                              subject: 'RTO Info - Indian Vehicle App',
                            );
                          },
                          icon: const Icon(Icons.share_rounded, size: 15),
                          label: Text(
                            isHindi ? 'शेयर करें' : 'Share App',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context.push('/signs'),
                          icon: const Icon(Icons.traffic_rounded, size: 15),
                          label: Text(
                            isHindi ? 'यातायात नियम' : 'Road Signs',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _showPrivacyPolicySheet(context, isDark, isHindi),
                          icon: const Icon(Icons.policy_outlined, size: 15),
                          label: Text(
                            isHindi ? 'गोपनीयता' : 'Privacy',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Statutory Disclaimers
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      isHindi
                          ? 'अस्वीकरण (Disclaimer): आरटीओ इन्फो एक स्वतंत्र भारतीय ऑटोमोटिव सूचना एप्लिकेशन है। प्रदर्शित सार्वजनिक वाहन डेटा भारत सरकार के सड़क परिवहन और राजमार्ग मंत्रालय (MoRTH) के आधिकारिक पोर्टल (parivahan.gov.in) के सार्वजनिक रिकॉर्ड पर आधारित है। आरटीओ इन्फो किसी भी सरकारी विभाग अथवा क्षेत्रीय परिवहन कार्यालय (RTO) से संबद्ध या अधिकृत नहीं है।'
                          : 'Statutory Disclaimer: RTO Info is an independent automotive discovery companion built for Indian vehicle owners. Public vehicle records are facilitated via MoRTH Parivahan Sewa open data standards. RTO Info is not affiliated with, endorsed by, or representing the Ministry of Road Transport and Highways (MoRTH) or any state government RTO.',
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.45,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      isHindi
                          ? 'भारतीय वाहन चालकों के लिए समर्पित • भारत में निर्मित 🇮🇳'
                          : 'Crafted for Indian Motorists • Proudly Made in India 🇮🇳',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- SUBWIDGET HELPERS ---

  Widget _buildProfileSummaryCard({
    required BuildContext context,
    required bool isDark,
    required bool isHindi,
    required int garageCount,
    required int historyCount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0A1E3F), const Color(0xFF0A1128)]
              : [const Color(0xFFEBF3FF), const Color(0xFFF0F7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFBFDBFE),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066FF).withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF003399),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield_rounded,
                    color: Color(0xFFFFD700),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isHindi ? 'डिजिटल वाहन गैराज' : 'RTO Digital Garage',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'CMVR 139',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isHindi
                          ? 'सुरक्षित स्थानीय डेटाबेस • कोई लॉगिन आवश्यक नहीं'
                          : 'Zero-Auth Offline Architecture • Privacy Safe',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quick Garage Stat Chips
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/favourites'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF10192D) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF223150)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          size: 16,
                          color: Color(0xFF0066FF),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isHindi
                              ? 'गैराज ($garageCount)'
                              : 'My Garage ($garageCount)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/history'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF10192D) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF223150)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isHindi
                              ? 'इतिहास ($historyCount)'
                              : 'History ($historyCount)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0066FF)),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSegment({
    required ThemeMode mode,
    required String label,
    required String sublabel,
    required IconData icon,
    required ThemeMode currentMode,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final isSelected = currentMode == mode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0066FF)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0066FF)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0066FF).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 9.5,
                color: isSelected
                    ? Colors.white70
                    : (isDark ? Colors.white38 : Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSegment({
    required String languageCode,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0066FF)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0066FF)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0066FF).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF0066FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  languageCode.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : const Color(0xFF0066FF),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isSelected
                          ? Colors.white70
                          : (isDark ? Colors.white38 : Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelChip(
    String id,
    String labelHi,
    Color accentColor,
    bool isDark,
  ) {
    final isSelected = _preferredFuel == id;
    return InkWell(
      onTap: () => setState(() => _preferredFuel = id),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.18)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              id,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : (isDark ? Colors.white70 : const Color(0xFF475569)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String id,
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _defaultVehicleClass == id;
    return InkWell(
      onTap: () => setState(() => _defaultVehicleClass = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0066FF).withOpacity(0.15)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0066FF)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? const Color(0xFF0066FF)
                  : (isDark ? Colors.white70 : const Color(0xFF64748B)),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0066FF)
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTile({
    required String number,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () => _showEmergencyDialog(number, title, subtitle),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3), width: 1.1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0066FF),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white60 : const Color(0xFF475569),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color:
                valueColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  // --- MODALS & DIALOGS ---

  void _showCitySelectorSheet(BuildContext context, bool isDark, bool isHindi) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF10192D) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi
                          ? 'प्राथमिक शहर चुनें'
                          : 'Select Primary Metro City',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _indianCities.length,
                  itemBuilder: (c, i) {
                    final city = _indianCities[i];
                    final isSelected = city == _selectedCity;
                    return ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: isSelected
                            ? const Color(0xFF0066FF)
                            : Colors.grey,
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A)),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF0066FF),
                              size: 18,
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedCity = city);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isHindi
                                  ? 'प्राथमिक शहर $city के रूप में सेट किया गया'
                                  : 'Primary city updated to $city',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmergencyDialog(String number, String title, String subtitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.emergency_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Helpline Number: $number',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0066FF),
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.4)),
            const SizedBox(height: 8),
            const Text(
              'Toll-free 24x7 service operating across all states and Union Territories in India.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: number));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Helpline number $number copied to clipboard'),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy Number'),
          ),
        ],
      ),
    );
  }

  void _showCmvrLegalSheet(BuildContext context, bool isDark, bool isHindi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF10192D) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.gavel_rounded,
                    color: Color(0xFF0066FF),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHindi
                        ? 'केंद्रीय मोटर वाहन नियम (CMVR) १३९'
                        : 'Central Motor Vehicles Rules (CMVR) 139',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Ministry of Road Transport & Highways (MoRTH) Standard:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Per Notification No. RT-11036/64/2017-MVL dated 17th December 2018 and Rule 139 of CMVR 1989:\n\n'
                  '1. Production of physical Registration Certificate, Driving Licence, Fitness, and Insurance is NOT mandatory if presented through authorized digital platforms.\n'
                  '2. The digital format carries statutory evidentiary value equivalent to original documents under Section 4 of the Information Technology Act 2000.\n'
                  '3. Enforcement officers must not seize physical documents during routine checks unless an impoundable violation has been formally recorded.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Understood'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicySheet(
    BuildContext context,
    bool isDark,
    bool isHindi,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF10192D) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFF0066FF),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHindi
                        ? 'गोपनीयता व सुरक्षा नीतियां'
                        : 'Privacy & Data Protections',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '• Zero Authentication: We do not require any signup, user account, email, or passwords.\n'
                '• Privacy Masking: In adherence to DPDP Act 2023 & MoRTH guidelines, full owner names and contact numbers are masked with asterisks.\n'
                '• Local Storage: Search history and garage bookmarks remain 100% on your device.\n'
                '• Open Government Data: All vehicular public data is retrieved per Open Government Data (OGD) standards without altering official registry records.',
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Acknowledge'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context, WidgetRef ref, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(isHindi ? 'खोज इतिहास मिटाएं?' : 'Clear Search History?'),
        content: Text(
          isHindi
              ? 'क्या आप हाल ही में खोजी गई नंबर प्लेटों का इतिहास मिटाना चाहते हैं? आपके गैराज में सुरक्षित वाहन बने रहेंगे।'
              : 'This will reset your recent search queries. Vehicles saved in your Digital Garage will not be removed.',
          style: const TextStyle(fontSize: 12.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(historyProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isHindi
                        ? 'खोज इतिहास साफ़ किया गया'
                        : 'Search history cleared successfully',
                  ),
                ),
              );
            },
            child: Text(isHindi ? 'इतिहास हटाएं' : 'Clear History'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isHindi ? 'संपूर्ण स्थानीय डेटा साफ़ करें?' : 'Reset All Local Data?',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        content: Text(
          isHindi
              ? 'क्या आप सभी खोज इतिहास और गैराज पसंदीदा रिकॉर्ड हटाना चाहते हैं? यह क्रिया वापस नहीं ली जा सकती।'
              : 'This will permanently remove your cached search history and all saved vehicles from your Digital Garage.',
          style: const TextStyle(fontSize: 12.5, height: 1.4),
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
                borderRadius: BorderRadius.circular(10),
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
                        ? 'संपूर्ण स्थानीय डेटा सफलतापूर्वक साफ़ किया गया'
                        : 'All local application data successfully reset',
                  ),
                ),
              );
            },
            child: Text(isHindi ? 'सभी साफ़ करें' : 'Reset All'),
          ),
        ],
      ),
    );
  }
}
