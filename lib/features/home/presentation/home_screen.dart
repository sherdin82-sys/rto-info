import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../history/presentation/providers/history_provider.dart';

/// HomeScreen provides a high-density, automotive-grade homepage for RTO Info,
/// built strictly with native Flutter widgets and modeled after the CarInfo reference.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _heroPageController = PageController();
  int _currentHeroPage = 0;
  String _selectedCity = 'Delhi NCR';
  final Set<int> _expandedFaqIndices = {0}; // First FAQ open by default

  final List<String> _cities = [
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
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  void _onSearchSubmit([String? input]) {
    final query = (input ?? _searchController.text).trim();
    if (query.isEmpty) return;
    final cleaned = VehicleNumberValidator.cleanPlate(query);
    if (cleaned.isNotEmpty) {
      context.push('/rc?plate=$cleaned');
    }
  }

  void _showCitySelector(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select City',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  itemCount: _cities.length,
                  itemBuilder: (c, i) {
                    final city = _cities[i];
                    final isSelected = city == _selectedCity;
                    return ListTile(
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: isSelected
                            ? AppColors.electricBlue
                            : Colors.grey,
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.electricBlue
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColors.electricBlue,
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedCity = city);
                        Navigator.pop(ctx);
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

  void _showFastagDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF005691).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.toll_outlined,
                color: Color(0xFF005691),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'FASTag Services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage and check NPCI FASTag balance, transaction history, or recharge through official banking portals.',
              style: TextStyle(fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: AppColors.electricBlue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'NPCI NETC FASTag interoperability compliant.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/rc');
            },
            child: const Text('Check Vehicle Tag'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyItems = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B101B)
          : const Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          // 1. CARINFO-STYLE TOP APP BAR
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            scrolledUnderElevation: 1,
            toolbarHeight: 56,
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            titleSpacing: 14,
            title: Row(
              children: [
                // Brand Logo & City Dropdown Column
                InkWell(
                  onTap: () => _showCitySelector(context, isDark),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0066FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_car_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            Text(
                              isHindi ? 'आरटीओ इन्फो' : 'RTO Info',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 11,
                              color: Color(0xFF0066FF),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _selectedCity,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 13,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // 'My garage' shortcut button
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go('/favourites'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.garage_rounded,
                            size: 14,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isHindi ? 'गैरेज' : 'My garage',
                            style: TextStyle(
                              fontSize: 11,
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
              ),

              // Language toggle
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        ref.read(localeProvider.notifier).toggleLocale(),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        isHindi ? 'EN' : 'हिं',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Theme toggle
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).toggleTheme(),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        size: 15,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. HERO PROMOTIONAL BANNER & FLOATING HSRP SEARCH BOX
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Hero Card Container
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 10, 14, 26),
                  height: 145,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0F3E4D),
                        Color(0xFF165265),
                        Color(0xFF1B6278),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F3E4D).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        PageView(
                          controller: _heroPageController,
                          onPageChanged: (idx) {
                            setState(() => _currentHeroPage = idx);
                          },
                          children: [
                            _buildHeroSlide(
                              title: isHindi
                                  ? 'कार व बाइक बीमा ऑनलाइन नवीनीकृत करें'
                                  : 'Buy or renew vehicle insurance online',
                              ctaText: isHindi ? 'अभी लें' : 'Buy now',
                              onCta: () => context.push('/rc'),
                              icon: Icons.verified_user_rounded,
                            ),
                            _buildHeroSlide(
                              title: isHindi
                                  ? 'लंबित ट्रैफ़िक ई-चालान तुरंत जांचें'
                                  : 'Check pending traffic challans online',
                              ctaText: isHindi ? 'जांचें' : 'Check now',
                              onCta: () => context.push('/challan'),
                              icon: Icons.warning_amber_rounded,
                            ),
                            _buildHeroSlide(
                              title: isHindi
                                  ? 'अखिल भारतीय वाहन आरसी विवरण'
                                  : 'Instant all-India Parivahan RC check',
                              ctaText: isHindi ? 'खोजें' : 'Search RC',
                              onCta: () => context.push('/search'),
                              icon: Icons.assignment_turned_in_rounded,
                            ),
                          ],
                        ),

                        // Carousel Dots Indicator
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (idx) {
                              final active = idx == _currentHeroPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2.5,
                                ),
                                width: active ? 16 : 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),

                        // Pill badge above search bar: "Enter your Vehicle Number"
                        Positioned(
                          bottom: 2,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isHindi
                                    ? 'अपना वाहन नंबर दर्ज करें'
                                    : 'Enter your Vehicle Number',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating HSRP Search Box overlapping the hero banner
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left IND Strip
                        Container(
                          width: 40,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF003399),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8.8),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD700),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 2,
                                    height: 2,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFD700),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'IND',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Input Field
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _searchController,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                letterSpacing: 1.2,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: '(e.g. DL 01 AB 1234)',
                                hintStyle: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12.5,
                                  color: isDark ? Colors.white38 : Colors.grey,
                                  letterSpacing: 0.8,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: _onSearchSubmit,
                            ),
                          ),
                        ),

                        // Search Button
                        IconButton(
                          icon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF0066FF),
                            size: 22,
                          ),
                          onPressed: () => _onSearchSubmit(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. SAMPLE REGISTRATION CHIPS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  Text(
                    isHindi ? 'नमूना:' : 'Sample:',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SizedBox(
                      height: 24,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstants.sampleVehicles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (ctx, idx) {
                          final s = AppConstants.sampleVehicles[idx];
                          return InkWell(
                            onTap: () {
                              _searchController.text = s['plate']!;
                              _onSearchSubmit(s['plate']!);
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                s['label']!,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
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
            ),
          ),

          // RECENT SEARCHES (IF ANY)
          if (historyItems.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: SizedBox(
                  height: 24,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: historyItems.take(4).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (ctx, idx) {
                      final h = historyItems[idx];
                      return InkWell(
                        onTap: () =>
                            context.push('/rc?plate=${h.registrationNumber}'),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFEEF2F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.history,
                                size: 11,
                                color: Color(0xFF0066FF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                h.formattedPlate,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // 4. PRIMARY 4x2 QUICK SERVICES GRID (CarInfo-style 8 cards)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.82,
                children: [
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.receipt_long_rounded,
                    title: isHindi ? 'ई-चालान' : 'Pay challan',
                    color: const Color(0xFFEF4444),
                    onTap: () => context.push('/challan'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.shield_rounded,
                    title: isHindi ? 'कार बीमा' : 'Car insurance',
                    color: const Color(0xFF06B6D4),
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.two_wheeler_rounded,
                    title: isHindi ? 'बाइक बीमा' : 'Bike insurance',
                    color: const Color(0xFF10B981),
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.fact_check_outlined,
                    title: isHindi ? 'वाहन रिपोर्ट' : 'Vehicle report',
                    color: const Color(0xFF3B82F6),
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.find_in_page_outlined,
                    title: isHindi ? 'आरसी खोज' : 'RC search',
                    color: const Color(0xFF6366F1),
                    onTap: () => context.push('/search'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.toll_rounded,
                    title: isHindi ? 'फास्टैग' : 'FASTag Manager',
                    color: const Color(0xFFF59E0B),
                    onTap: () => _showFastagDialog(context, isDark),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.car_repair_rounded,
                    title: isHindi ? 'कार जांच' : 'Car check',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => context.push('/rto'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.payments_rounded,
                    title: isHindi ? 'कार ऋण' : 'Car loan',
                    color: const Color(0xFF14B8A6),
                    onTap: () => context.push('/loan-emi'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // 5. SECTION: "Buy & sell car"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'कार खरीदें व बेचें' : 'Buy & sell car',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'पुरानी कार खरीदें' : 'Buy used car',
                          icon: Icons.directions_car_filled_rounded,
                          accentColor: const Color(0xFF0066FF),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'नई कार खरीदें' : 'Buy new car',
                          icon: Icons.electric_car_rounded,
                          accentColor: const Color(0xFF0D9488),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'कार बेचें' : 'Sell your car',
                          icon: Icons.key_rounded,
                          accentColor: const Color(0xFFF59E0B),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'कार लोन' : 'Car loan',
                          icon: Icons.monetization_on_rounded,
                          accentColor: const Color(0xFF8B5CF6),
                          onTap: () => context.push('/loan-emi'),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. SECTION: "Top 10 trending used cars"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'शीर्ष 10 लोकप्रिय पुरानी कारें'
                        : 'Top 10 trending used cars',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTrendingCarCard(
                          rank: '01',
                          model: 'Verna ₹2L- 11L',
                          brand: 'Hyundai',
                          color: const Color(0xFF0066FF),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTrendingCarCard(
                          rank: '02',
                          model: 'Creta ₹4L- 19L',
                          brand: 'Hyundai',
                          color: const Color(0xFF0D9488),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTrendingCarCard(
                          rank: '03',
                          model: 'Thar ₹8L- 17L',
                          brand: 'Mahindra',
                          color: const Color(0xFFDC2626),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTrendingCarCard(
                          rank: '04',
                          model: 'City ₹3L- 12L',
                          brand: 'Honda',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 7. SECTION: "Explore used car by brand"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'ब्रांड द्वारा कार खोजें'
                        : 'Explore used car by brand',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBrandCircle(
                          name: 'Maruti',
                          code: 'MS',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Hyundai',
                          code: 'HY',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Tata',
                          code: 'TA',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Honda',
                          code: 'HO',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Mahindra',
                          code: 'MA',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Toyota',
                          code: 'TO',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 14),
                        _buildBrandCircle(
                          name: 'Kia',
                          code: 'KI',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 8. SECTION: "Offers for you"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'आपके लिए विशेष ऑफ़र' : 'Offers for you',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPromoOfferBanner(
                          title: 'Buy FASTag and have a smoother journey',
                          actionText: 'Buy now',
                          gradient: const [
                            Color(0xFF1E40AF),
                            Color(0xFF3B82F6),
                          ],
                          icon: Icons.toll_rounded,
                          onTap: () => _showFastagDialog(context, isDark),
                        ),
                        const SizedBox(width: 10),
                        _buildPromoOfferBanner(
                          title: 'Clear Traffic Challans before court notices',
                          actionText: 'Check Fines',
                          gradient: const [
                            Color(0xFF831843),
                            Color(0xFFBE185D),
                          ],
                          icon: Icons.warning_rounded,
                          onTap: () => context.push('/challan'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 9. SECTION: "Trending videos" / "RTO Traffic Rules & Tips"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'यातायात नियम व महत्वपूर्ण वीडियो'
                        : 'Trending videos & Traffic Rules',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTrendingVideoCard(
                          title: '🚦 3 TRAFFIC RULES\nTHAT YOU MUST KNOW!',
                          category: 'Road Safety 2026',
                          color: const Color(0xFF0F766E),
                          onTap: () => context.push('/signs'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTrendingVideoCard(
                          title: '⚠️ HOW TO CLEAR\nPENDING E-CHALLANS',
                          category: 'Court & Virtual RTO',
                          color: const Color(0xFF0369A1),
                          onTap: () => context.push('/challan'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTrendingVideoCard(
                          title: '📋 PASS RTO EXAM\nIN FIRST ATTEMPT',
                          category: 'Sarathi Parivahan',
                          color: const Color(0xFF7C3AED),
                          onTap: () => context.push('/exam'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 10. SECTION: "Trending new bikes"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHindi ? 'लोकप्रिय नई बाइक' : 'Trending new bikes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/resale'),
                        child: Text(
                          isHindi ? 'सभी देखें' : 'View all',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 115,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBikeCard(
                          name: 'S1 X Electric',
                          price: '₹ 84,999',
                          brand: 'Ola Electric',
                          icon: Icons.electric_scooter_rounded,
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildBikeCard(
                          name: 'Bullet 350',
                          price: '₹ 1,73,564',
                          brand: 'Royal Enfield',
                          icon: Icons.two_wheeler_rounded,
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildBikeCard(
                          name: 'Pulsar NS200',
                          price: '₹ 1,42,000',
                          brand: 'Bajaj Auto',
                          icon: Icons.motorcycle_rounded,
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 11. SECTION: "What our customers say"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'उपयोगकर्ताओं के अनुभव'
                        : 'What our customers say',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 125,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTestimonialCard(
                          quote: 'Checked my vehicle challans and verified my RC within 10 seconds. Extremely clean and fast experience.',
                          name: 'Manish Bhatia',
                          subtitle: 'Verified User • Delhi',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTestimonialCard(
                          quote: 'The used car resale calculator gave me the exact market rate. Highly recommend for used car buyers!',
                          name: 'Priya Sharma',
                          subtitle: 'Verified User • Bengaluru',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 12. SECTION: "FAQs" (Accordion)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'अक्सर पूछे जाने वाले प्रश्न' : 'FAQs',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildFaqItem(
                    index: 0,
                    question:
                        'How can I check my vehicle details in mParivahan?',
                    answer: 'Enter your state registration number (e.g., DL01AB1234) into the search bar. The app securely fetches authenticated public transport details including maker, model, fuel type, fitness, and insurance status.',
                    isDark: isDark,
                  ),
                  _buildFaqItem(
                    index: 1,
                    question: 'How to find RC in Parivahan?',
                    answer: 'You can look up the Registration Certificate using either your vehicle registration plate number or chassis/engine credentials through the Parivahan Sewa portal.',
                    isDark: isDark,
                  ),
                  _buildFaqItem(
                    index: 2,
                    question: 'Is mParivahan virtual RC valid?',
                    answer: 'Yes. Under Rule 139 of the Central Motor Vehicles Rules (CMVR), virtual RC and Driving Licences on DigiLocker / mParivahan are statutory legal electronic records accepted by traffic police across all Indian states.',
                    isDark: isDark,
                  ),
                  _buildFaqItem(
                    index: 3,
                    question: 'How to check paid challan in Telangana & other states?',
                    answer: 'Open the e-Challan section, enter your vehicle number, and filter by "Settled / Paid" to verify past penalty receipts and payment transaction IDs.',
                    isDark: isDark,
                  ),
                  _buildFaqItem(
                    index: 4,
                    question: 'How to check if RC is original or fake?',
                    answer: 'Match the engine number, chassis number, registration date, and issuing RTO authority displayed in the digital RC card against physical stamps on your vehicle.',
                    isDark: isDark,
                  ),
                  _buildFaqItem(
                    index: 5,
                    question: 'What is an RC book / Smart Card?',
                    answer: 'A Registration Certificate (RC) is official proof that a motor vehicle has been registered with the regional transport office of the state government.',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // 13. FOOTER BRAND BANNER
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(14, 24, 14, 24),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0066FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RTO Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'INDIA\'S APP FOR COMPLETE VEHICLE MANAGEMENT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Parivahan Sewa • Sarathi • e-Challan • Motor Vehicles Act 2019',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildHeroSlide({
    required String title,
    required String ctaText,
    required VoidCallback onCta,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F3E4D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onCta,
                  child: Text(
                    ctaText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF2DD4BF), size: 36),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuySellCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Icon(icon, size: 20, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCarCard({
    required String rank,
    required String model,
    required String brand,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Stack(
          children: [
            // Watermark rank
            Positioned(
              left: 4,
              bottom: -6,
              child: Text(
                rank,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: color.withOpacity(0.12),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      brand,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: 38,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCircle({
    required String name,
    required String code,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF0066FF),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoOfferBanner({
    required String title,
    required String actionText,
    required List<Color> gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: gradient),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white70, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingVideoCard({
    required String title,
    required String category,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF0F172A),
                  size: 24,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 8,
              right: 8,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeCard({
    required String name,
    required String price,
    required String brand,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF0066FF)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                ),
                Text(
                  brand,
                  style: TextStyle(
                    fontSize: 8.5,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String quote,
    required String name,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.star, size: 9, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
              const Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
              const Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
              const Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
            ],
          ),
          Text(
            quote,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.25,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFF0066FF).withOpacity(0.15),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 8.5,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
    required bool isDark,
  }) {
    final isExpanded = _expandedFaqIndices.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              question,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.remove : Icons.add,
              size: 16,
              color: const Color(0xFF0066FF),
            ),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedFaqIndices.remove(index);
                } else {
                  _expandedFaqIndices.add(index);
                }
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
