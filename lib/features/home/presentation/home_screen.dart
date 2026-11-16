import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../fuel/data/fuel_mock_datasource.dart';
import '../../fuel/domain/models/fuel_price_entity.dart';
import '../../history/presentation/providers/history_provider.dart';
import '../domain/models/new_car_entity.dart';
import 'widgets/rto_service_graphics.dart';

/// HomeScreen serves as the primary automotive dashboard for RTO Info,
/// built strictly with native Flutter widgets and modeled after the CarInfo reference.
/// Features a high-density, automotive marketplace experience with restored fuel rates,
/// genuine new-car catalogues, and manufacturer brand discoveries.
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
    'Chandigarh',
    'Bhopal',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  void _onSearchSubmit([String? input]) {
    final query = (input ?? _searchController.text).trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(localeProvider).languageCode == 'hi'
                ? 'कृपया वाहन पंजीकरण संख्या दर्ज करें (जैसे DL 01 AB 1234)'
                : 'Please enter a vehicle registration number (e.g. DL 01 AB 1234)',
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    final cleaned = VehicleNumberValidator.cleanPlate(query);
    if (!VehicleNumberValidator.isValid(cleaned)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(localeProvider).languageCode == 'hi'
                ? 'अमान्य वाहन नंबर! उदाहरण: DL01AB1234 या HR26DQ5551'
                : 'Invalid vehicle number format! Example: DL01AB1234 or HR26DQ5551',
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    context.push('/rc?plate=$cleaned');
  }

  FuelPriceEntity _getFuelPriceForCity(String city) {
    final lower = city.toLowerCase();
    for (final f in FuelMockDataSource.allCities) {
      if (f.city.toLowerCase() == lower ||
          (lower.contains('delhi') && f.city == 'New Delhi') ||
          (lower == 'gurgaon' && f.city == 'New Delhi') ||
          (lower == 'noida' && f.city == 'New Delhi')) {
        return f;
      }
    }
    return FuelMockDataSource.allCities.first;
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
                color: const Color(0xFFF59E0B).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.toll_outlined,
                color: Color(0xFFF59E0B),
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

  void _showTestDriveDialog(BuildContext context, bool isDark) {
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
                color: const Color(0xFF10B981).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.car_rental_rounded,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Book Test Drive',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select any verified new car model across authorized dealerships in your city.',
              style: TextStyle(fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    color: AppColors.electricBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'City: $_selectedCity • Doorstep test drive available.',
                      style: const TextStyle(
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/search');
            },
            child: const Text('Browse Dealerships'),
          ),
        ],
      ),
    );
  }

  void _showBrandDetailsSheet(
    BuildContext context,
    CarBrandEntity brand,
    bool isDark,
    bool isHindi,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
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
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        brand.logoAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.directions_car_rounded,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                brand.name,
                                style: TextStyle(
                                  fontSize: 17,
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
                                  color: const Color(0xFF10B981)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  brand.origin,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            brand.segmentLeader,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF475569),
                            ),
                          ),
                          Text(
                            '${brand.modelCount} Models in India • ${brand.priceRange}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF0066FF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isHindi ? 'लोकप्रिय मॉडल सूची:' : 'Popular Model Lineup:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: brand.topModels.isNotEmpty
                      ? brand.topModels
                            .map(
                              (model) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  model,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            )
                            .toList()
                      : [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              brand.popularModel,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/resale');
                        },
                        child: Text(
                          isHindi ? 'मूल्यांकन देखें' : 'Resale Value',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/search?brand=${brand.id}');
                        },
                        child: Text(isHindi ? 'मॉडल खोजें' : 'Explore Models'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          // 1. RTO INFO HEADER (CARINFO-STYLE TOP APP BAR)
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

          // 2. PROMOTIONAL AUTOMOTIVE HERO BANNER
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
                            _buildHeroSlide(
                              title: isHindi
                                  ? 'सारथी ड्राइविंग लाइसेंस वैधता जांचें'
                                  : 'Verify Sarathi Driving Licence online',
                              ctaText: isHindi ? 'डीएल जांचें' : 'Verify DL',
                              onCta: () => context.push('/dl'),
                              icon: Icons.badge_outlined,
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
                            children: List.generate(4, (idx) {
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
                  left: 18,
                  right: 18,
                  bottom: 0,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left IND Strip
                        Container(
                          width: 42,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFF003399),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10.5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD700),
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 2.2,
                                    height: 2.2,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFD700),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2.5),
                              const Text(
                                'IND',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Input Field directly inside main container with NO inner outline or border
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: _searchController,
                              inputFormatters: [VehicleNumberFormatter()],
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              autocorrect: false,
                              enableSuggestions: false,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: const Color(0xFF0066FF),
                              cursorWidth: 2.0,
                              cursorRadius: const Radius.circular(1),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                fontSize: 21,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'DL 01 AB 1234',
                                hintStyle: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white30
                                      : const Color(0xFF94A3B8),
                                  letterSpacing: 1.2,
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: false,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: _onSearchSubmit,
                            ),
                          ),
                        ),

                        // Clear Button when text entered
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Icon(
                                Icons.clear_rounded,
                                size: 19,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),

                        // Compact HSRP-aligned Search Button
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Material(
                            color: const Color(0xFF0066FF),
                            borderRadius: BorderRadius.circular(9),
                            child: InkWell(
                              onTap: () => _onSearchSubmit(),
                              borderRadius: BorderRadius.circular(9),
                              child: const SizedBox(
                                width: 42,
                                height: 42,
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. VEHICLE REGISTRATION NUMBER SEARCH (SAMPLE CHIPS & RECENT SEARCHES)
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
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 13,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isHindi ? 'हाल की खोजें:' : 'Recent:',
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
                          itemCount: historyItems.length > 5
                              ? 5
                              : historyItems.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 6),
                          itemBuilder: (ctx, idx) {
                            final h = historyItems[idx];
                            return InkWell(
                              onTap: () {
                                _searchController.text = h.registrationNumber;
                                context.push(
                                  '/rc?plate=${h.registrationNumber}',
                                );
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
                                  h.registrationNumber,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
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

          // 4. ESSENTIAL RTO QUICK SERVICES (PRIMARY 4x2 GRID & DRIVER UTILITIES)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.78,
                children: [
                  _buildQuickActionCard(
                    context: context,
                    graphic: PosChallanGraphic(isDark: isDark),
                    title: isHindi ? 'ई-चालान' : 'Pay challan',
                    onTap: () => context.push('/challan'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: const CarInsuranceGraphic(),
                    title: isHindi ? 'कार बीमा' : 'Car insurance',
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: const BikeInsuranceGraphic(),
                    title: isHindi ? 'बाइक बीमा' : 'Bike insurance',
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: VehicleReportGraphic(isDark: isDark),
                    title: isHindi ? 'वाहन रिपोर्ट' : 'Vehicle report',
                    onTap: () => context.push('/rc'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: RcSearchGraphic(isDark: isDark),
                    title: isHindi ? 'आरसी खोज' : 'RC search',
                    onTap: () => context.push('/search'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: FastagGraphic(isDark: isDark),
                    title: isHindi ? 'फास्टैग' : 'FASTag Manager',
                    onTap: () => _showFastagDialog(context, isDark),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: CarCheckGraphic(isDark: isDark),
                    title: isHindi ? 'कार जांच' : 'Car check',
                    onTap: () => context.push('/rto'),
                    isDark: isDark,
                  ),
                  _buildQuickActionCard(
                    context: context,
                    graphic: CarLoanGraphic(isDark: isDark),
                    title: isHindi ? 'कार लोन' : 'Car loan',
                    onTap: () => context.push('/loan-emi'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // DRIVER UTILITIES STRIP (2x2 Grid)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDriverToolTile(
                      icon: Icons.school_outlined,
                      title: isHindi ? 'आरटीओ परीक्षा' : 'Mock Exam',
                      subtitle: isHindi
                          ? 'सारथी एलएल अभ्यास'
                          : 'Sarathi LL test',
                      color: const Color(0xFF0D9488),
                      onTap: () => context.push('/exam'),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDriverToolTile(
                      icon: Icons.traffic_outlined,
                      title: isHindi ? 'यातायात संकेत' : 'Traffic Signs',
                      subtitle: isHindi
                          ? 'सड़क नियम व जुर्माना'
                          : 'Road signs & fines',
                      color: const Color(0xFF2563EB),
                      onTap: () => context.push('/signs'),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDriverToolTile(
                      icon: Icons.route_outlined,
                      title: isHindi ? 'यात्रा खर्च' : 'Trip Cost',
                      subtitle: isHindi
                          ? 'दूरी व माइलेज अनुमान'
                          : 'Fuel trip estimate',
                      color: const Color(0xFFE11D48),
                      onTap: () => context.push('/trip-calculator'),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDriverToolTile(
                      icon: Icons.badge_outlined,
                      title: isHindi ? 'डीएल सत्यापन' : 'DL Verify',
                      subtitle: isHindi
                          ? 'ड्राइविंग लाइसेंस स्थिति'
                          : 'Driving licence status',
                      color: const Color(0xFF10B981),
                      onTap: () => context.push('/dl'),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. RESTORED: DAILY FUEL RATES SECTION (HORIZONTALLY ACCESSIBLE CARDS)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: _buildDailyFuelRatesSection(
                context: context,
                isHindi: isHindi,
                isDark: isDark,
                selectedCity: _selectedCity,
              ),
            ),
          ),

          // 6. BUY & EXPLORE NEW CARS HUB
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'नई कारें खरीदें व खोजें'
                        : 'Buy / Explore New Cars',
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
                          title: isHindi ? 'नई कारें' : 'Buy new car',
                          icon: Icons.directions_car_filled_rounded,
                          accentColor: const Color(0xFF0066FF),
                          onTap: () => context.push('/search'),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'टेस्ट ड्राइव' : 'Test drive',
                          icon: Icons.car_rental_rounded,
                          accentColor: const Color(0xFF10B981),
                          onTap: () => _showTestDriveDialog(context, isDark),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'कार ऋण' : 'Car loan EMI',
                          icon: Icons.account_balance_wallet_rounded,
                          accentColor: const Color(0xFF8B5CF6),
                          onTap: () => context.push('/loan-emi'),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildBuySellCard(
                          title: isHindi ? 'एक्सचेंज' : 'Sell / Exchange',
                          icon: Icons.published_with_changes_rounded,
                          accentColor: const Color(0xFFFF7A00),
                          onTap: () => context.push('/resale'),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 7. TOP NEW CARS (REPLACED USED CARS SECTION WITH GENUINE PHOTOGRAPHS)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: _buildTopNewCarsSection(
                context: context,
                isHindi: isHindi,
                isDark: isDark,
              ),
            ),
          ),

          // 8. EXPLORE NEW CARS BY BRAND (GENUINE LOGOS OF 15 INDIAN MANUFACTURERS)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: _buildExploreNewCarsByBrandSection(
                context: context,
                isHindi: isHindi,
                isDark: isDark,
              ),
            ),
          ),

          // 9. AUTOMOTIVE PROMOTIONAL BANNERS ("OFFERS FOR YOU")
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'विशेष ऑफ़र' : 'Offers for you',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 95,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPromoOfferBanner(
                          title: isHindi
                              ? 'फास्टैग रिचार्ज पर कैशबैक\nराष्ट्रीय राजमार्ग टोल पर मान्य'
                              : 'Recharge FASTag instantly\nGet assured cashback at toll plazas',
                          actionText: isHindi ? 'रिचार्ज करें' : 'Recharge now',
                          gradient: const [
                            Color(0xFF1E3A8A),
                            Color(0xFF3B82F6),
                          ],
                          icon: Icons.toll_rounded,
                          onTap: () => _showFastagDialog(context, isDark),
                        ),
                        const SizedBox(width: 10),
                        _buildPromoOfferBanner(
                          title: isHindi
                              ? 'ई-चालान समय पर भरें\nकोर्ट नोटिस व अतिरिक्त दंड से बचें'
                              : 'Pay e-Challan on time\nAvoid court summons & extra fines',
                          actionText: isHindi ? 'चालान जांचें' : 'Check status',
                          gradient: const [
                            Color(0xFF7F1D1D),
                            Color(0xFFDC2626),
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

          // 10. TRENDING VIDEOS & ROAD SAFETY RULES
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

          // 11. LATEST AUTOMOTIVE INFORMATION (NEW BIKES, COMPLIANCE BANNER, TESTIMONIALS)
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
                        onTap: () => context.push('/search'),
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
                          onTap: () => context.push('/search'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildBikeCard(
                          name: 'Bullet 350',
                          price: '₹ 1,73,564',
                          brand: 'Royal Enfield',
                          icon: Icons.two_wheeler_rounded,
                          onTap: () => context.push('/search'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildBikeCard(
                          name: 'Pulsar NS200',
                          price: '₹ 1,42,000',
                          brand: 'Bajaj Auto',
                          icon: Icons.motorcycle_rounded,
                          onTap: () => context.push('/search'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECTION 139 CMVR STATUTORY COMPLIANCE BANNER
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(14, 18, 14, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0C1929)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E3A5F)
                      : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF0066FF),
                      size: 20,
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
                              ? 'मोटर वाहन अधिनियम धारा 139 (CMVR)'
                              : 'Motor Vehicles Act Section 139 (CMVR)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHindi
                              ? 'डिजिलॉकर व एम-परिवहन द्वारा प्रस्तुत डिजिटल आरसी और डीएल कानूनी रूप से मान्य हैं।'
                              : 'Digital RC & DL on DigiLocker / mParivahan are legally accepted at par with physical originals across India.',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.3,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CUSTOMER TESTIMONIALS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
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
                          quote: 'Found my new Thar ROXX ex-showroom price and verified RC within 10 seconds. Extremely clean and fast experience.',
                          name: 'Manish Bhatia',
                          subtitle: 'Verified User • Delhi',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _buildTestimonialCard(
                          quote: 'Daily fuel prices for Bengaluru are always accurate at 6 AM. Love the instant trip cost calculator!',
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

          // 12. FAQS (ACCORDION)
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

          // 13. RTO INFO BRANDED FOOTER
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

  // 1. Daily Fuel Rates Section
  Widget _buildDailyFuelRatesSection({
    required BuildContext context,
    required bool isHindi,
    required bool isDark,
    required String selectedCity,
  }) {
    // Reorder so currently selected city appears first
    final activeFuel = _getFuelPriceForCity(selectedCity);
    final cities = List<FuelPriceEntity>.from(FuelMockDataSource.allCities);
    cities.removeWhere((c) => c.city == activeFuel.city);
    cities.insert(0, activeFuel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.local_gas_station_rounded,
                          size: 14,
                          color: Color(0xFFFF7A00),
                        ),
                      ),
                      Text(
                        isHindi ? 'दैनिक ईंधन दरें' : 'Daily Fuel Rates',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindi
                        ? 'आईओसीएल, बीपीसीएल व एचपीसीएल द्वारा सत्यापित दैनिक दरें'
                        : 'Updated daily at 6:00 AM • Verified by IOCL, BPCL & HPCL',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/fuel'),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Text(
                        isHindi ? 'सभी देखें' : 'View all',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Color(0xFF0066FF),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 122,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: cities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (ctx, idx) {
              final fuel = cities[idx];
              final isCurrent = idx == 0;
              return _buildFuelCityCard(
                fuel: fuel,
                isHighlight: isCurrent,
                isDark: isDark,
                isHindi: isHindi,
                onTap: () => context.push('/fuel'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFuelCityCard({
    required FuelPriceEntity fuel,
    required bool isHighlight,
    required bool isDark,
    required bool isHindi,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isHighlight
                  ? const Color(0xFF0066FF)
                  : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
              width: isHighlight ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 13,
                        color: Color(0xFF0066FF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${fuel.city}, ${fuel.state}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildFuelPricePill(
                      label: isHindi ? 'पेट्रोल' : 'Petrol',
                      price: '₹${fuel.petrolPrice.toStringAsFixed(2)}',
                      unit: '/L',
                      change: fuel.petrolChange,
                      accentColor: const Color(0xFFEF4444),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFuelPricePill(
                      label: isHindi ? 'डीजल' : 'Diesel',
                      price: '₹${fuel.dieselPrice.toStringAsFixed(2)}',
                      unit: '/L',
                      change: fuel.dieselChange,
                      accentColor: const Color(0xFF3B82F6),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildFuelPricePill(
                      label: isHindi ? 'सीएनजी' : 'CNG',
                      price: '₹${fuel.cngPrice.toStringAsFixed(2)}',
                      unit: '/kg',
                      change: fuel.cngChange,
                      accentColor: const Color(0xFF10B981),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fuel.lastUpdated,
                    style: TextStyle(
                      fontSize: 8.5,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        isHindi ? 'यात्रा खर्च' : 'Trip cost',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 12,
                        color: Color(0xFF0066FF),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuelPricePill({
    required String label,
    required String price,
    required String unit,
    required double change,
    required Color accentColor,
    required bool isDark,
  }) {
    final changeText = change == 0.0
        ? '0.00'
        : (change > 0
              ? '+₹${change.toStringAsFixed(2)}'
              : '-₹${(-change).toStringAsFixed(2)}');
    final changeColor = change > 0
        ? const Color(0xFFEF4444)
        : (change < 0 ? const Color(0xFF10B981) : Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 7.5,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            changeText,
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Top New Cars Section
  Widget _buildTopNewCarsSection({
    required BuildContext context,
    required bool isHindi,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'लोकप्रिय नई कारें' : 'Top New Cars',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindi
                        ? 'भारतीय बाज़ार के नवीनतम मॉडल व सत्यापित एक्स-शोरूम दरें'
                        : 'Trending Indian-market 2026 models with verified pricing',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/search'),
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
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: NewCarEntity.topNewCars.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (ctx, idx) {
              final car = NewCarEntity.topNewCars[idx];
              return _buildNewCarCard(
                car: car,
                isDark: isDark,
                onTap: () => context.push('/rc'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewCarCard({
    required NewCarEntity car,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Photograph
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    car.imageAsset,
                    height: 124,
                    width: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => Container(
                      height: 124,
                      width: 250,
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFE2E8F0),
                      child: const Center(
                        child: Icon(
                          Icons.directions_car_rounded,
                          size: 40,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                    ),
                  ),
                  // Badge (NEW / HOT / HYBRID)
                  if (car.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(car.badgeColorValue ?? 0xFF0066FF),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          car.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  // Category pill
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        car.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${car.manufacturer} ${car.name}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${car.verifiedPricePrefix} ',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        car.exShowroomPrice,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${car.fuelType} • ${car.transmission}',
                    style: TextStyle(
                      fontSize: 8.5,
                      color: isDark ? Colors.white38 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Explore New Cars by Brand Section
  Widget _buildExploreNewCarsByBrandSection({
    required BuildContext context,
    required bool isHindi,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi
                        ? 'ब्रांड द्वारा नई कारें देखें'
                        : 'Explore New Cars by Brand',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindi
                        ? 'भारत के प्रमुख वाहन निर्माता व ब्रांड कैटलॉग'
                        : 'Official Indian automobile manufacturers',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/search'),
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
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: CarBrandEntity.allBrands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (ctx, idx) {
              final brand = CarBrandEntity.allBrands[idx];
              return _buildBrandLogoCard(
                brand: brand,
                isDark: isDark,
                onTap: () =>
                    _showBrandDetailsSheet(context, brand, isDark, isHindi),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrandLogoCard({
    required CarBrandEntity brand,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 82,
          child: Column(
            children: [
              Container(
                width: 76,
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 54,
                    child: Image.asset(
                      brand.logoAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, _) => const Icon(
                        Icons.directions_car_rounded,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                brand.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '${brand.modelCount} models',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverToolTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    required Widget graphic,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.22 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 50, height: 44, child: Center(child: graphic)),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF1E293B),
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
