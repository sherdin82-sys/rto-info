import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/vehicle_search_bar.dart';
import '../../history/presentation/providers/history_provider.dart';

/// HomeScreen serves as the primary automotive dashboard for RTO Info.
/// Redesigned with NoteFlow architecture, premium cards, and responsive native widgets.
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
        'badge': 'VERIFIED',
        'route': '/rc',
      },
      {
        'title': isHindi ? 'ई-चालान' : 'e-Challan',
        'desc': isHindi ? 'यातायात जुर्माना देखें' : 'Pending traffic fines',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.error,
        'badge': 'PORTAL',
        'route': '/challan',
      },
      {
        'title': isHindi ? 'डीएल सत्यापन' : 'DL Verify',
        'desc': isHindi ? 'ड्राइविंग लाइसेंस स्थिति' : 'Driving licence check',
        'icon': Icons.badge_outlined,
        'color': AppColors.success,
        'badge': 'SARATHI',
        'route': '/dl',
      },
      {
        'title': isHindi ? 'ईंधन दरें' : 'Fuel Rates',
        'desc': isHindi ? 'दैनिक पेट्रोल व डीजल' : 'Daily petrol & diesel',
        'icon': Icons.local_gas_station_outlined,
        'color': AppColors.warmOrange,
        'badge': 'DAILY',
        'route': '/fuel',
      },
      {
        'title': isHindi ? 'पुनर्विक्रय मूल्य' : 'Resale & EMI',
        'desc': isHindi ? 'वाहन मूल्यांकन व ऋण' : 'Market valuation & loan',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF8B5CF6),
        'badge': 'CALC',
        'route': '/resale',
      },
      {
        'title': isHindi ? 'आरटीओ निर्देशिका' : 'RTO Directory',
        'desc': isHindi ? 'कार्यालय पता व संपर्क' : 'Offices & state codes',
        'icon': Icons.business_outlined,
        'color': const Color(0xFF0284C7),
        'badge': 'ALL-INDIA',
        'route': '/rto',
      },
      {
        'title': isHindi ? 'यातायात संकेत' : 'Traffic Signs',
        'desc': isHindi
            ? 'सड़क सुरक्षा नियम व दंड'
            : 'Road safety rules & fines',
        'icon': Icons.traffic_outlined,
        'color': AppColors.successDark,
        'badge': 'MV ACT',
        'route': '/signs',
      },
      {
        'title': isHindi ? 'आरटीओ परीक्षा' : 'Mock Exam',
        'desc': isHindi ? 'लर्नर लाइसेंस अभ्यास' : 'Learner licence test',
        'icon': Icons.school_outlined,
        'color': const Color(0xFF0D9488),
        'badge': 'QUIZ',
        'route': '/exam',
      },
      {
        'title': isHindi ? 'यात्रा लागत' : 'Trip Cost',
        'desc': isHindi
            ? 'माइलेज व यात्रा खर्च'
            : 'Estimate fuel & travel expense',
        'icon': Icons.route_outlined,
        'color': const Color(0xFFE11D48),
        'badge': 'BUDGET',
        'route': '/trip-calculator',
      },
      {
        'title': isHindi ? 'ऋण ईएमआई' : 'Loan EMI',
        'desc': isHindi
            ? 'मासिक किस्त व ब्याज'
            : 'Monthly installment calculator',
        'icon': Icons.payments_outlined,
        'color': AppColors.electricBlueDark,
        'badge': 'FINANCE',
        'route': '/loan-emi',
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Header
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: AppRadius.radiusM,
                    border: Border.all(
                      color: AppColors.electricBlue,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricBlue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car,
                      color: AppColors.warmOrange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
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
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(0.12),
                            borderRadius: AppRadius.radiusXs,
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
                      isHindi
                          ? 'भारतीय वाहन सूचना व परिवहन पोर्टल'
                          : 'Parivahan Vehicle Intelligence',
                      style: AppTypography.labelSmall(
                        isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceAlt
                        : AppColors.lightSurfaceAlt,
                    borderRadius: AppRadius.radiusS,
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
                      fontSize: 12,
                    ),
                  ),
                ),
                onPressed: () =>
                    ref.read(localeProvider.notifier).toggleLocale(),
                tooltip: 'Toggle Language',
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 22,
                ),
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
                tooltip: 'Toggle Theme',
              ),
              const SizedBox(width: AppSpacing.s),
            ],
          ),

          // Main Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tricolor Accent Line
                Container(
                  height: 3,
                  margin: const EdgeInsets.only(bottom: AppSpacing.l),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.radiusXs,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF9933),
                        Colors.white,
                        Color(0xFF138808),
                      ],
                    ),
                  ),
                ),

                // Hero Title
                Text(
                  isHindi ? 'वाहन विवरण खोजें' : 'Check Indian Vehicle Details',
                  style: AppTypography.titleLarge(
                    isDark ? Colors.white : AppColors.primaryNavy,
                  ).copyWith(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isHindi
                      ? 'आरसी, बीमा, प्रदूषण और ई-चालान की तुरंत आधिकारिक जाँच करें'
                      : 'Verify RC smart card, insurance, PUC status, and pending challans instantly',
                  style: AppTypography.bodySmall(
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // HSRP Number Plate Search Input
                VehicleSearchBar(
                  onSearch: (cleanPlate) {
                    context.push('/rc?plate=$cleanPlate');
                  },
                ),
                const SizedBox(height: AppSpacing.m),

                // Quick Plate Suggestions
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Text(
                      isHindi ? 'नमूना:' : 'Sample:',
                      style: AppTypography.labelSmall(
                        isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    for (final s in AppConstants.sampleVehicles)
                      InkWell(
                        onTap: () {
                          context.push('/rc?plate=${s['plate']}');
                        },
                        borderRadius: AppRadius.radiusS,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceAlt
                                : AppColors.lightSurfaceAlt,
                            borderRadius: AppRadius.radiusS,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
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

                // Recent Searches Ribbon
                if (historyItems.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHindi ? 'हाल की खोजें' : 'Recent Searches',
                        style: AppTypography.labelLarge(
                          isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.go('/history'),
                        child: Text(
                          isHindi ? 'सभी देखें' : 'View All',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.electricBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final h in historyItems.take(4))
                        ActionChip(
                          avatar: const Icon(
                            Icons.history,
                            size: 14,
                            color: AppColors.electricBlue,
                          ),
                          label: Text(
                            h.formattedPlate,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            context.push('/rc?plate=${h.registrationNumber}');
                          },
                        ),
                    ],
                  ),
                ],

                // Live Fuel Rates Mini Ticker Card
                const SizedBox(height: AppSpacing.xl),
                PremiumCard(
                  onTap: () => context.push('/fuel'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
                  accentColor: AppColors.warmOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.warmOrange.withOpacity(0.12),
                              borderRadius: AppRadius.radiusM,
                            ),
                            child: const Icon(
                              Icons.local_gas_station,
                              color: AppColors.warmOrange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi
                                    ? 'दैनिक ईंधन दरें (दिल्ली)'
                                    : 'Daily Fuel Rates (Delhi)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Petrol ₹94.72 • Diesel ₹87.62 • CNG ₹75.09',
                                style: AppTypography.labelSmall(
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.electricBlue,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Section: Essential RTO Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindi
                          ? 'आवश्यक आरटीओ सेवाएँ'
                          : 'Essential RTO Services',
                      style: AppTypography.titleMedium(
                        isDark ? Colors.white : AppColors.primaryNavy,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue.withOpacity(0.1),
                        borderRadius: AppRadius.radiusPill,
                      ),
                      child: Text(
                        '10 TOOLS',
                        style: AppTypography.labelSmall(AppColors.electricBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),

                // 2-Column Grid of 10 Tools using PremiumCard
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

                    return PremiumCard(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      onTap: () {
                        context.push(item['route'] as String);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: AppRadius.radiusM,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: color,
                                  size: 20,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.08),
                                  borderRadius: AppRadius.radiusXs,
                                ),
                                child: Text(
                                  item['badge'] as String,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['desc'] as String,
                                style: AppTypography.labelSmall(
                                  isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Compliance Notice Card (Motor Vehicles Act Section 139)
                Container(
                  padding: AppSpacing.edgeInsetsL,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceAlt
                        : const Color(0xFFEFF6FF),
                    borderRadius: AppRadius.radiusCard,
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
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.m),
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
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              isHindi
                                  ? 'डिजिलॉकर व एम-परिवहन द्वारा प्रस्तुत डिजिटल आरसी और ड्राइविंग लाइसेंस कानूनी रूप से भौतिक दस्तावेजों के समान मान्य हैं।'
                                  : 'Digital RC and Driving Licences on DigiLocker / mParivahan are legally accepted at par with original physical documents across India.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
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
                const SizedBox(height: AppSpacing.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
