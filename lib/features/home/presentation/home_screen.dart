import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../core/widgets/vehicle_search_bar.dart';

/// HomeScreen serves as the primary automotive dashboard for RTO Info.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final quickTools = [
      {
        'title': isHindi ? 'आरसी विवरण' : 'RC Details',
        'desc': isHindi ? 'वाहन स्वामित्व व फिटनेस' : 'Owner & fitness',
        'icon': Icons.verified_user_outlined,
        'color': AppColors.electricBlue,
        'route': '/rc',
      },
      {
        'title': isHindi ? 'ई-चालान' : 'e-Challan',
        'desc': isHindi ? 'यातायात जुर्माना देखें' : 'Pending traffic fines',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.error,
        'route': '/challan',
      },
      {
        'title': isHindi ? 'डीएल सत्यापन' : 'DL Verify',
        'desc': isHindi ? 'ड्राइविंग लाइसेंस स्थिति' : 'Driving licence check',
        'icon': Icons.badge_outlined,
        'color': AppColors.success,
        'route': '/dl',
      },
      {
        'title': isHindi ? 'ईंधन दरें' : 'Fuel Rates',
        'desc': isHindi ? 'दैनिक पेट्रोल व डीजल' : 'Daily petrol & diesel',
        'icon': Icons.local_gas_station_outlined,
        'color': AppColors.saffron,
        'route': '/fuel',
      },
      {
        'title': isHindi ? 'पुनर्विक्रय मूल्य' : 'Resale & EMI',
        'desc': isHindi ? 'वाहन मूल्यांकन व ऋण' : 'Market valuation & loan',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF8B5CF6),
        'route': '/resale',
      },
      {
        'title': isHindi ? 'आरटीओ निर्देशिका' : 'RTO Directory',
        'desc': isHindi ? 'कार्यालय पता व संपर्क' : 'Offices & state codes',
        'icon': Icons.business_outlined,
        'color': const Color(0xFF0284C7),
        'route': '/rto',
      },
      {
        'title': isHindi ? 'यातायात संकेत' : 'Traffic Signs',
        'desc': isHindi ? 'सड़क सुरक्षा नियम व दंड' : 'Road safety rules & fines',
        'icon': Icons.traffic_outlined,
        'color': AppColors.successDark,
        'route': '/signs',
      },
      {
        'title': isHindi ? 'आरटीओ परीक्षा' : 'Mock Exam',
        'desc': isHindi ? 'लर्नर लाइसेंस अभ्यास' : 'Learner licence test',
        'icon': Icons.school_outlined,
        'color': const Color(0xFF0D9488),
        'route': '/exam',
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Header
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.electricBlue, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.directions_car, color: Colors.amber, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isHindi ? 'आरटीओ इन्फो' : 'RTO INFO',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'INDIA',
                            style: TextStyle(
                              color: AppColors.electricBlue,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isHindi ? 'भारतीय वाहन सूचना पोर्टल' : 'Parivahan Vehicle Intelligence',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Text(
                  isHindi ? 'EN' : 'हिं',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
                onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
                tooltip: 'Toggle Language',
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 22,
                ),
                onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                tooltip: 'Toggle Theme',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Main Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tricolor Accent Line
                Container(
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9933), Colors.white, Color(0xFF138808)],
                    ),
                  ),
                ),

                // Hero Title
                Text(
                  isHindi ? 'वाहन विवरण खोजें' : 'Check Indian Vehicle Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHindi
                      ? 'आरसी, बीमा, प्रदूषण और ई-चालान की तुरंत जाँच करें'
                      : 'Verify RC, insurance, PUC status, and pending challans instantly',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 18),

                // Search Bar
                VehicleSearchBar(
                  onSearch: (cleanPlate) {
                    context.push('/rc?plate=$cleanPlate');
                  },
                ),
                const SizedBox(height: 12),

                // Quick Plate Suggestions
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Text(
                      isHindi ? 'नमूना:' : 'Sample:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    for (final s in AppConstants.sampleVehicles)
                      InkWell(
                        onTap: () {
                          context.push('/rc?plate=${s['plate']}');
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Text(
                            s['label']!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),

                // Section: Quick RTO Tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi ? 'त्वरित आरटीओ सेवाएँ' : 'Essential RTO Services',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2-Column Grid of Tools
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  itemCount: quickTools.length,
                  itemBuilder: (context, index) {
                    final item = quickTools[index];
                    final color = item['color'] as Color;

                    return Card(
                      child: InkWell(
                        onTap: () {
                          context.push(item['route'] as String);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item['icon'] as IconData, color: color, size: 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Compliance Notice Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceAlt : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.electricBlue, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi
                                  ? 'मोटर वाहन अधिनियम धारा 139'
                                  : 'Motor Vehicles Act Section 139',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isHindi
                                  ? 'डिजिलॉकर व एम-परिवहन द्वारा प्रस्तुत डिजिटल आरसी और ड्राइविंग लाइसेंस कानूनी रूप से भौतिक दस्तावेजों के समान मान्य हैं।'
                                  : 'Digital RC and Driving Licences on DigiLocker / mParivahan are legally accepted at par with original physical documents across India.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
