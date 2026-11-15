import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/vehicle_search_bar.dart';
import '../../history/presentation/providers/history_provider.dart';

/// HomeScreen serves as the primary automotive dashboard for RTO Info.
/// Version 0.2.1: Balanced, compact layout with 125-145dp service cards,
/// 2-line descriptions, and zero dead whitespace.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends ConsumerWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyItems = ref.watch(historyProvider);

    final quickTools = [
      {
        'title': isHindi ? 'आरसी विवरण' : 'RC Details',
        'desc': isHindi
            ? 'मालिक का नाम, मॉडल, फिटनेस व वाहन पंजीकरण स्थिति'
            : 'Owner details, model, fitness & registration status',
        'icon': Icons.directions_car_rounded,
        'color': AppColors.electricBlue,
        'route': '/rc',
      },
      {
        'title': isHindi ? 'ई-चालान' : 'e-Challan',
        'desc': isHindi
            ? 'लंबित ट्रैफ़िक जुर्माना, चालान विवरण व भुगतान लिंक'
            : 'Pending traffic fines, violation details & official portal',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.error,
        'route': '/challan',
      },
      {
        'title': isHindi ? 'डीएल सत्यापन' : 'DL Verify',
        'desc': isHindi
            ? 'सारथी ड्राइविंग लाइसेंस वैधता व अधिकृत वाहन श्रेणियाँ'
            : 'Sarathi driving licence validity & vehicle endorsements',
        'icon': Icons.badge_outlined,
        'color': AppColors.success,
        'route': '/dl',
      },
      {
        'title': isHindi ? 'ईंधन दरें' : 'Fuel Rates',
        'desc': isHindi
            ? 'दैनिक पेट्रोल, डीजल व सीएनजी दरें महानगरों के लिए'
            : 'Daily petrol, diesel & CNG rates across Indian cities',
        'icon': Icons.local_gas_station_rounded,
        'color': AppColors.warmOrange,
        'route': '/fuel',
      },
      {
        'title': isHindi ? 'पुनर्विक्रय मूल्य' : 'Resale & EMI',
        'desc': isHindi
            ? 'वाहन का सही बाज़ार मूल्य व ऋण ईएमआई कैलकुलेटर'
            : 'Fair market valuation estimator & loan EMI calculator',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF8B5CF6),
        'route': '/resale',
      },
      {
        'title': isHindi ? 'आरटीओ निर्देशिका' : 'RTO Directory',
        'desc': isHindi
            ? 'अखिल भारतीय आरटीओ कोड, कार्यालय पता व संपर्क'
            : 'All-India RTO codes, office address & state helplines',
        'icon': Icons.business_outlined,
        'color': const Color(0xFF0284C7),
        'route': '/rto',
      },
      {
        'title': isHindi ? 'यातायात संकेत' : 'Traffic Signs',
        'desc': isHindi
            ? 'अनिवार्य व चेतावनी सड़क संकेत और एमवी एक्ट जुर्माना'
            : 'Road safety signs handbook & MV Act 2019 fine schedule',
        'icon': Icons.traffic_outlined,
        'color': AppColors.successDark,
        'route': '/signs',
      },
      {
        'title': isHindi ? 'आरटीओ परीक्षा' : 'Mock Exam',
        'desc': isHindi
            ? 'लर्नर लाइसेंस परीक्षा अभ्यास व आधिकारिक प्रश्नोत्तरी'
            : 'Parivahan Sarathi learner licence test simulation',
        'icon': Icons.school_outlined,
        'color': const Color(0xFF0D9488),
        'route': '/exam',
      },
      {
        'title': isHindi ? 'यात्रा लागत' : 'Trip Cost',
        'desc': isHindi
            ? 'दूरी, माइलेज व ईंधन के आधार पर यात्रा खर्च अनुमान'
            : 'Estimate fuel consumption & running cost per kilometer',
        'icon': Icons.route_outlined,
        'color': const Color(0xFFE11D48),
        'route': '/trip-calculator',
      },
      {
        'title': isHindi ? 'ऋण ईएमआई' : 'Loan EMI',
        'desc': isHindi
            ? 'मासिक किस्त, कुल ब्याज और ऋण भुगतान विवरण'
            : 'Monthly installment, interest breakdown & loan schedule',
        'icon': Icons.payments_outlined,
        'color': AppColors.electricBlueDark,
        'route': '/loan-emi',
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // A. Compact Header with Precision Alignment
          SliverAppBar(
            floating: true,
            pinned: false,
            toolbarHeight: 52,
            collapsedHeight: 52,
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 14,
            title: Row(
              children: [
                // App Logo Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.electricBlue,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricBlue.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.warmOrange,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Title and Subtitle Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          isHindi ? 'आरटीओ इन्फो' : 'RTO INFO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'INDIA',
                            style: TextStyle(
                              color: AppColors.electricBlue,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isHindi
                          ? 'परिवहन सेवा पोर्टल'
                          : 'Parivahan Vehicle Intelligence',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Compact Language Pill Button
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        ref.read(localeProvider.notifier).toggleLocale(),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceAlt
                            : AppColors.lightSurfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Text(
                        isHindi ? 'EN' : 'हिं',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Compact Theme Toggle Button
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).toggleTheme(),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceAlt
                            : AppColors.lightSurfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Main Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tricolor Accent Line
                Container(
                  height: 2.5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF9933),
                        Colors.white,
                        Color(0xFF138808),
                      ],
                    ),
                  ),
                ),

                // Hero Title & Subtitle with Tight Spacing
                Text(
                  isHindi ? 'वाहन विवरण खोजें' : 'Check Vehicle Details',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi
                      ? 'आरसी, चालान, बीमा व प्रदूषण की तुरंत आधिकारिक जाँच करें'
                      : 'Instant RC, challan, insurance & fitness verification',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                // B. Compact HSRP Number Plate Search Input
                VehicleSearchBar(
                  onSearch: (cleanPlate) {
                    context.push('/rc?plate=$cleanPlate');
                  },
                ),
                const SizedBox(height: 8),

                // Compact Single-Row Sample Registration Chips
                Row(
                  children: [
                    Text(
                      isHindi ? 'नमूना:' : 'Sample:',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SizedBox(
                        height: 24,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppConstants.sampleVehicles.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 5),
                          itemBuilder: (context, index) {
                            final s = AppConstants.sampleVehicles[index];
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  context.push('/rc?plate=${s['plate']}');
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurfaceAlt
                                        : AppColors.lightSurfaceAlt,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: Text(
                                    s['label']!,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.5,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Recent Searches Ribbon (Single row if present)
                if (historyItems.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHindi ? 'हाल की खोजें' : 'Recent Searches',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.go('/history'),
                        child: Text(
                          isHindi ? 'सभी देखें' : 'View All',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.electricBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 26,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: historyItems.take(5).length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final h = historyItems[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push('/rc?plate=${h.registrationNumber}');
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurfaceAlt
                                    : AppColors.lightSurfaceAlt,
                                borderRadius: BorderRadius.circular(6),
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
                                    Icons.history,
                                    size: 12,
                                    color: AppColors.electricBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    h.formattedPlate,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10.5,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // C. Compact Daily Fuel Rates Mini Ticker Card
                const SizedBox(height: 12),
                PremiumCard(
                  onTap: () => context.push('/fuel'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  borderRadius: 10,
                  accentColor: AppColors.warmOrange,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.warmOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.local_gas_station_rounded,
                          color: AppColors.warmOrange,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isHindi
                                      ? 'दैनिक ईंधन दरें (दिल्ली)'
                                      : 'Daily Fuel Rates (Delhi)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.5,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                                children: [
                                  const TextSpan(text: 'Petrol '),
                                  TextSpan(
                                    text: '₹94.72',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  const TextSpan(text: '  •  Diesel '),
                                  TextSpan(
                                    text: '₹87.62',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  const TextSpan(text: '  •  CNG '),
                                  TextSpan(
                                    text: '₹75.09',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.electricBlue,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // D. Essential RTO Services – MOST IMPORTANT
                // Redesigned two-column service grid: Target card height 125-145dp,
                // small icon, clear title, readable 2-line descriptions, no fake badges.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi
                          ? 'आवश्यक आरटीओ सेवाएँ'
                          : 'Essential RTO Services',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.primaryNavy,
                      ),
                    ),
                    Text(
                      '10 SERVICES',
                      style: TextStyle(
                        color: AppColors.electricBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                LayoutBuilder(
                  builder: (context, constraints) {
                    // Compute responsive childAspectRatio targeting ~130dp card height
                    final itemWidth = (constraints.maxWidth - 10) / 2;
                    const targetHeight = 132.0;
                    final responsiveAspectRatio = itemWidth / targetHeight;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: responsiveAspectRatio,
                      ),
                      itemCount: quickTools.length,
                      itemBuilder: (context, index) {
                        final item = quickTools[index];
                        final color = item['color'] as Color;

                        return PremiumCard(
                          padding: const EdgeInsets.all(12),
                          borderRadius: 12,
                          onTap: () {
                            context.push(item['route'] as String);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 1. Small service icon container
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: color,
                                  size: 18,
                                ),
                              ),

                              // 2. Service title & 3. 2-line wrapped short description
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.lightTextPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      height: 1.3,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 14),

                // E. Information Banner (Motor Vehicles Act Section 139)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceAlt
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.electricBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.electricBlue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isHindi
                                  ? 'मोटर वाहन अधिनियम धारा 139'
                                  : 'Motor Vehicles Act Section 139',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isHindi
                                  ? 'डिजिलॉकर व एम-परिवहन द्वारा प्रस्तुत डिजिटल आरसी और डीएल कानूनी रूप से मान्य हैं।'
                                  : 'Digital RC & DL on DigiLocker / mParivahan are legally accepted at par with physical originals.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.3,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
