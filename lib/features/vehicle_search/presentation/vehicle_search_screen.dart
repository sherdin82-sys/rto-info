import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/vehicle_number_formatter.dart';
import '../../../core/utils/vehicle_number_validator.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/vehicle_search_bar.dart';
import '../../history/presentation/providers/history_provider.dart';
import '../../home/domain/models/new_car_entity.dart';

/// VehicleSearchScreen provides an authentic, high-density Indian vehicle discovery interface.
/// Features live HSRP plate simulation, category filters, manufacturer brand catalogs,
/// categorized sample plates, and Parivahan statutory verification indicators.
class VehicleSearchScreen extends ConsumerStatefulWidget {
  final String? initialBrand;

  const VehicleSearchScreen({
    super.key,
    this.initialBrand,
  });

  @override
  ConsumerState<VehicleSearchScreen> createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends ConsumerState<VehicleSearchScreen> {
  String _liveQuery = '';
  String _selectedCategory = 'all'; // 'all', 'car', 'bike', 'ev', 'commercial'
  String? _selectedBrand;
  String _searchBarValue = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialBrand != null) {
      _selectedBrand = widget.initialBrand;
    }
  }

  // State code mapping for authentic Indian High Security Registration Plates
  static const Map<String, String> _indianStateMap = {
    'DL': 'Delhi NCR',
    'MH': 'Maharashtra',
    'KA': 'Karnataka',
    'HR': 'Haryana',
    'UP': 'Uttar Pradesh',
    'TN': 'Tamil Nadu',
    'GJ': 'Gujarat',
    'RJ': 'Rajasthan',
    'WB': 'West Bengal',
    'AP': 'Andhra Pradesh',
    'TS': 'Telangana',
    'KL': 'Kerala',
    'PB': 'Punjab',
    'CH': 'Chandigarh',
    'BR': 'Bihar',
    'MP': 'Madhya Pradesh',
    'GA': 'Goa',
    'UK': 'Uttarakhand',
    'UA': 'Uttarakhand',
    'HP': 'Himachal Pradesh',
    'OD': 'Odisha',
    'JH': 'Jharkhand',
    'AS': 'Assam',
    'TR': 'Tripura',
    'PY': 'Puducherry',
    'JK': 'Jammu & Kashmir',
    'LA': 'Ladakh',
    'BH': 'Bharat Series (All-India)',
  };

  String? _detectStateName(String plate) {
    final clean = VehicleNumberValidator.cleanPlate(plate);
    if (clean.length >= 2) {
      final code = clean.substring(0, 2);
      return _indianStateMap[code];
    }
    return null;
  }

  // Expanded authentic Indian vehicle samples across all categories
  static const List<Map<String, String>> _allSampleVehicles = [
    {
      'plate': 'DL01AB1234',
      'label': 'DL 01 AB 1234',
      'make': 'Maruti Suzuki Swift 4th Gen',
      'category': 'car',
      'brand': 'maruti_suzuki',
      'fuel': 'Petrol • Manual',
      'rto': 'DL-01 Delhi Mall Road RTO',
      'typeBadge': 'Passenger Car (LMV)',
    },
    {
      'plate': 'MH12DE1433',
      'label': 'MH 12 DE 1433',
      'make': 'Hyundai Creta Facelift SX(O)',
      'category': 'car',
      'brand': 'hyundai',
      'fuel': 'Diesel • Automatic',
      'rto': 'MH-12 Pune Central RTO',
      'typeBadge': 'Mid-Size SUV',
    },
    {
      'plate': 'KA05MJ5005',
      'label': 'KA 05 MJ 5005',
      'make': 'Tata Nexon EV Long Range',
      'category': 'ev',
      'brand': 'tata',
      'fuel': 'Electric (40.5 kWh) • Single Speed',
      'rto': 'KA-05 Bengaluru South RTO',
      'typeBadge': 'Electric Vehicle (BEV)',
    },
    {
      'plate': 'HR26DQ5551',
      'label': 'HR 26 DQ 5551',
      'make': 'Royal Enfield Classic 350 Dual Channel',
      'category': 'bike',
      'brand': 'royal_enfield',
      'fuel': 'Petrol • 5-Speed',
      'rto': 'HR-26 Gurugram North RTO',
      'typeBadge': 'Two Wheeler (MCWG)',
    },
    {
      'plate': 'UP32AZ0001',
      'label': 'UP 32 AZ 0001',
      'make': 'Mahindra Thar ROXX 4x4 AX7L',
      'category': 'car',
      'brand': 'mahindra',
      'fuel': 'Diesel • 4x4 Automatic',
      'rto': 'UP-32 Lucknow Mahanagar RTO',
      'typeBadge': '4x4 Off-Road SUV',
    },
    {
      'plate': 'TN09BK2020',
      'label': 'TN 09 BK 2020',
      'make': 'Honda Elevate 1.5 ZX CVT',
      'category': 'car',
      'brand': 'honda',
      'fuel': 'Petrol • 7-Speed CVT',
      'rto': 'TN-09 Chennai West RTO',
      'typeBadge': 'Compact SUV',
    },
    {
      'plate': 'DL1VC9876',
      'label': 'DL 1V C 9876',
      'make': 'Tata Ace Gold BS6 Commercial',
      'category': 'commercial',
      'brand': 'tata',
      'fuel': 'Diesel • Commercial LCV',
      'rto': 'DL-01 Burari Transport Authority',
      'typeBadge': 'Light Goods Vehicle (LGV)',
    },
    {
      'plate': 'MH01EE9999',
      'label': 'MH 01 EE 9999',
      'make': 'BMW 3 Series Gran Limousine M Sport',
      'category': 'car',
      'brand': 'bmw',
      'fuel': '2.0L Turbo Petrol • 8-Speed Steptronic',
      'rto': 'MH-01 Mumbai Tardeo RTO',
      'typeBadge': 'Luxury Performance Sedan',
    },
    {
      'plate': 'KA01EV1001',
      'label': 'KA 01 EV 1001',
      'make': 'Ola S1 Pro Gen 2 Electric Scooter',
      'category': 'ev',
      'brand': 'ola',
      'fuel': 'Electric (4.0 kWh) • Mid-Drive',
      'rto': 'KA-01 Bengaluru Central RTO',
      'typeBadge': 'Electric Two Wheeler',
    },
  ];

  List<Map<String, String>> _getFilteredSamples() {
    return _allSampleVehicles.where((item) {
      if (_selectedCategory != 'all' && item['category'] != _selectedCategory) {
        return false;
      }
      if (_selectedBrand != null && item['brand'] != _selectedBrand) {
        return false;
      }
      return true;
    }).toList();
  }

  void _onPlateSelected(String plate) {
    setState(() {
      _searchBarValue = plate;
      _liveQuery = plate;
    });
    context.push('/rc?plate=$plate');
  }

  void _showBrandDetailsSheet(CarBrandEntity brand, bool isDark, bool isHindi) {
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
                      width: 54,
                      height: 54,
                      padding: const EdgeInsets.all(6),
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
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.12),
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
                              color: isDark ? Colors.white70 : const Color(0xFF475569),
                            ),
                          ),
                          Text(
                            '${brand.modelCount} Models Available • ${brand.priceRange}',
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                model,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                        child: Text(isHindi ? 'मूल्यांकन देखें' : 'Resale Value'),
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
                          setState(() {
                            _selectedBrand = brand.id;
                          });
                        },
                        child: Text(isHindi ? 'ब्रांड मॉडल चुनें' : 'Filter Brand'),
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
    final historyList = ref.watch(historyProvider);

    final cleanQuery = VehicleNumberValidator.cleanPlate(_liveQuery);
    final isQueryValid = VehicleNumberValidator.isValid(cleanQuery);
    final detectedState = _detectStateName(cleanQuery);

    // Plate background styling based on category or query
    final isEv = _selectedCategory == 'ev' || cleanQuery.contains('EV');
    final isCommercial = _selectedCategory == 'commercial';

    final Color plateBgColor = isCommercial
        ? const Color(0xFFFFD500) // Commercial Taxi / Transport Yellow
        : (isEv
            ? const Color(0xFF0B6623) // Electric Vehicle MoRTH Green
            : const Color(0xFFFFFFFF)); // Standard Metallic White

    final Color plateTextColor = (isCommercial || (!isEv))
        ? const Color(0xFF0F172A)
        : Colors.white;

    final filteredSamples = _getFilteredSamples();

    return Scaffold(
      appBar: AppAppBar(
        title: isHindi ? 'वाहन आरसी खोज' : 'Vehicle Search',
        subtitle: isHindi
            ? 'एचएसआरपी नंबर प्लेट व निर्माता खोज'
            : 'Live HSRP plate validation & RC lookup',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PRIMARY HSRP VEHICLE SEARCH BAR
            VehicleSearchBar(
              initialValue: _searchBarValue.isNotEmpty ? _searchBarValue : null,
              onChanged: (val) {
                setState(() {
                  _liveQuery = val;
                });
              },
              onSearch: (plate) {
                context.push('/rc?plate=$plate');
              },
            ),

            const SizedBox(height: 14),

            // 2. INTERACTIVE LIVE HSRP PLATE PREVIEW CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            size: 15,
                            color: isQueryValid ? const Color(0xFF10B981) : const Color(0xFF0066FF),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isHindi ? 'लाइव एचएसआरपी प्लेट सिमुलेशन' : 'Live HSRP Plate Preview',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      if (detectedState != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            detectedState,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // EMBOSSED METALLIC HSRP NUMBER PLATE
                  Center(
                    child: Container(
                      height: 52,
                      constraints: const BoxConstraints(maxWidth: 320),
                      decoration: BoxDecoration(
                        color: plateBgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF0F172A),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // MoRTH Blue IND Strip with Ashoka Chakra
                          Container(
                            width: 38,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF003399),
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(5.5),
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
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Plate Hologram Stamp
                          Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.blueGrey.withOpacity(0.6),
                                width: 0.8,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '✦',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Live Plate Monospace Number
                          Expanded(
                            child: Center(
                              child: Text(
                                cleanQuery.isNotEmpty
                                    ? VehicleNumberFormatter.formatForDisplay(cleanQuery)
                                    : 'DL 01 AB 1234',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.2,
                                  color: cleanQuery.isNotEmpty
                                      ? plateTextColor
                                      : plateTextColor.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      isQueryValid
                          ? '✓ Valid format • Tap Search button to verify RC'
                          : (cleanQuery.isNotEmpty
                              ? 'Enter full 10-character plate (e.g. MH12DE1433)'
                              : 'High Security Registration Plate standard (CMVR Rule 50)'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isQueryValid
                            ? const Color(0xFF10B981)
                            : (cleanQuery.isNotEmpty ? const Color(0xFF0066FF) : Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. VEHICLE CATEGORY FILTER CHIPS
            Text(
              isHindi ? 'वाहन श्रेणी चुनें' : 'Filter by Vehicle Category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip(
                    label: 'All Vehicles',
                    category: 'all',
                    icon: Icons.grid_view_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                    label: 'Cars (LMV)',
                    category: 'car',
                    icon: Icons.directions_car_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                    label: 'Bikes (2W)',
                    category: 'bike',
                    icon: Icons.two_wheeler_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                    label: 'Electric (EV)',
                    category: 'ev',
                    icon: Icons.electric_car_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                    label: 'Commercial',
                    category: 'commercial',
                    icon: Icons.local_shipping_rounded,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 4. EXPLORE BY MANUFACTURER BRANDS (15 AUTHENTIC BRANDS)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHindi ? 'निर्माता ब्रांड द्वारा खोजें' : 'Explore by Manufacturer',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isHindi
                          ? '१५ आधिकारिक ऑटोमोबाइल निर्माता'
                          : '15 verified automobile manufacturers',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (_selectedBrand != null)
                  InkWell(
                    onTap: () => setState(() => _selectedBrand = null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close, size: 12, color: Color(0xFFEF4444)),
                          SizedBox(width: 3),
                          Text(
                            'Clear Brand',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 98,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: CarBrandEntity.allBrands.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (ctx, idx) {
                  final brand = CarBrandEntity.allBrands[idx];
                  final isSelected = _selectedBrand == brand.id;
                  return _buildBrandCard(
                    brand: brand,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () {
                      if (isSelected) {
                        setState(() => _selectedBrand = null);
                      } else {
                        _showBrandDetailsSheet(brand, isDark, isHindi);
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 5. RECENT SEARCHES (IF ANY)
            if (historyList.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isHindi ? 'हाल ही में खोजे गए वाहन' : 'Recent Searches',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () => ref.read(historyProvider.notifier).clearAll(),
                    child: Text(
                      isHindi ? 'इतिहास मिटाएं' : 'Clear',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: historyList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, idx) {
                    final item = historyList[idx];
                    return ActionChip(
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      ),
                      label: Text(
                        item.formattedPlate.isNotEmpty ? item.formattedPlate : item.registrationNumber,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () => _onPlateSelected(item.registrationNumber),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 6. CURATED SAMPLE VEHICLES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isHindi ? 'उदाहरण नंबर प्लेट' : 'Curated Sample Vehicles',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '${filteredSamples.length} verified records',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (filteredSamples.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 36,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No sample vehicle matches this filter.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filteredSamples.map(
                (sample) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PremiumCard(
                    onTap: () => _onPlateSelected(sample['plate']!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    borderRadius: 12,
                    child: Row(
                      children: [
                        // HSRP Mini Plate Display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFF0F172A),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003399),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  'IND',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 6.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                VehicleNumberFormatter.formatForDisplay(sample['plate']!),
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Vehicle Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sample['make']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      sample['fuel']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0066FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      sample['typeBadge']!,
                                      style: const TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0066FF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: Color(0xFF0066FF),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 7. STATUTORY PARIVAHAN VERIFICATION CHECKLIST
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0C1929) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        color: Color(0xFF0066FF),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isHindi
                            ? 'सार्वजनिक परिवहन डेटा सुरक्षा व सत्यापन'
                            : 'Verified All-India MoRTH Parivahan Data',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHindi
                        ? '• वाहन मालिक का विवरण (गोपनीयता नियम अनुसार)\n• बीमा कंपनी व समाप्ति तिथि\n• प्रदूषण नियंत्रण (PUCC) वैधता\n• वित्तपोषक बैंक (Hypothecation Status)\n• लंबित ई-चालान व ब्लैकलिस्ट स्थिति'
                        : '• Registered Owner & Age (Privacy-masked per CMVR)\n• Insurance Policy & Expiry Date\n• PUCC Emission Certificate Validity\n• Bank Hypothecation / Financed Status\n• Pending Virtual Court e-Challan Records',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.45,
                      color: isDark ? Colors.white70 : const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String category,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = category),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0066FF)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0066FF)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCard({
    required CarBrandEntity brand,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white, // Pure crisp white tile for authentic logo colors
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0066FF)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: isSelected ? 2.0 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF0066FF).withOpacity(0.3)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  brand.logoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, _) => const Icon(
                    Icons.directions_car_rounded,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                brand.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF0066FF)
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
              Text(
                '${brand.modelCount} models',
                style: TextStyle(
                  fontSize: 8,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
