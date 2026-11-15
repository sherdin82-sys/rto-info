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
/// Redesigned with compact premium layout, zero vertical waste, and precision alignment.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyItems = ref.watch(historyProvider);

    final quickTools = [
      {
        'title': isHindi ? 'आरसी विवरण' : 'RC Details',
        'desc': isHindi ? 'वाहन स्वामित्व व फिटनेस' : 'Owner & fitness status',
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
        'color': AppColors.warmOrange,
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
        'desc': isHindi
            ? 'सड़क सुरक्षा नियम व दंड'
            : 'Road safety rules & fines',
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
      {
        'title': isHindi ? 'यात्रा लागत' : 'Trip Cost',
        'desc': isHindi ? 'माइलेज व यात्रा खर्च' : 'Estimate fuel expense',
        'icon': Icons.route_outlined,
        'color': const Color(0xFFE11D48),
        'route': '/trip-calculator',
      },
      {
        'title': isHindi ? 'ऋण ईएमआई' : 'Loan EMI',
        'desc': isHindi ? 'मासिक किस्त व ब्याज' : 'Monthly installment calc',
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

                // Section: Essential RTO Services Header
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '10 TOOLS',
                        style: TextStyle(
                          color: AppColors.electricBlue,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2-Column Compact Grid of 10 Tools
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: quickTools.length,
                  itemBuilder: (context, index) {
                    final item = quickTools[index];
                    final color = item['color'] as Color;

                    return PremiumCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      borderRadius: 10,
                      onTap: () {
                        context.push(item['route'] as String);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: color,
                              size: 17,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.5,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.lightTextPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  item['desc'] as String,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Compact Compliance Notice Card (Motor Vehicles Act Section 139)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.electricBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ? 'डिजिलॉकर व एम-परिवहन द्वारा प्रस्तुत डिजिटल आरसी और डीएल कानूनी रूप से भौतिक दस्तावेजों के समान मान्य हैं।'
                                  : 'Digital RC and Driving Licences on DigiLocker / mParivahan are legally accepted at par with original physical documents across India.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.35,
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
