import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/rto_office_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/rto_directory_data.dart';

class RtoDirectoryScreen extends StatefulWidget {
  const RtoDirectoryScreen({super.key});

  @override
  State<RtoDirectoryScreen> createState() => _RtoDirectoryScreenState();
}

class _RtoDirectoryScreenState extends State<RtoDirectoryScreen> {
  final _searchController = TextEditingController();
  String _selectedState = 'All';
  List<RtoOfficeEntity> _filteredOffices = RtoDirectoryData.offices;

  final List<String> _states = [
    'All',
    'Delhi',
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Uttar Pradesh',
    'Haryana',
    'Gujarat',
    'Rajasthan',
    'West Bengal',
    'Telangana',
    'Kerala',
    'Chandigarh',
    'Punjab',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchController.text.toUpperCase().replaceAll('-', '').trim();
    setState(() {
      _filteredOffices = RtoDirectoryData.offices.where((office) {
        final stateMatch =
            _selectedState == 'All' || office.state == _selectedState;
        if (!stateMatch) return false;

        if (q.isEmpty) return true;

        final cleanCode = office.rtoCode.replaceAll('-', '');
        return cleanCode.contains(q) ||
            office.city.toUpperCase().contains(q) ||
            office.officeName.toUpperCase().contains(q) ||
            office.pincode.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'All-India RTO Directory',
        subtitle: 'Official Transport Offices & Helplines',
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.m,
              AppSpacing.l,
              AppSpacing.s,
            ),
            child: AppTextField(
              controller: _searchController,
              hint: 'Search by RTO code (e.g. DL-01, MH-12) or city...',
              prefixIcon: const Icon(Icons.search, size: 20),
              onChanged: (_) => _filter(),
              onClear: () {
                _searchController.clear();
                _filter();
              },
            ),
          ),

          // State filter horizontal scroll
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              itemCount: _states.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
              itemBuilder: (context, index) {
                final st = _states[index];
                final isSelected = st == _selectedState;
                return ChoiceChip(
                  label: Text(st),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedState = st;
                    });
                    _filter();
                  },
                  selectedColor: AppColors.electricBlue.withOpacity(0.18),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.electricBlue
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.electricBlue
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s),

          // Count & Result List
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredOffices.length} Offices Listed',
                  style: AppTypography.labelSmall(
                    isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredOffices.isEmpty
                ? EmptyStateView(
                    icon: Icons.location_off_rounded,
                    title: 'No RTO Office Found',
                    description:
                        'No transport office matched "$_selectedState / ${_searchController.text}".',
                  )
                : ListView.separated(
                    padding: AppSpacing.edgeInsetsL,
                    itemCount: _filteredOffices.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.m),
                    itemBuilder: (context, index) {
                      final office = _filteredOffices[index];
                      return _buildOfficeCard(office, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeCard(RtoOfficeEntity office, bool isDark) {
    return PremiumCard(
      padding: AppSpacing.edgeInsetsL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.12),
                  borderRadius: AppRadius.radiusS,
                  border: Border.all(
                    color: AppColors.electricBlue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  office.rtoCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.electricBlue,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      office.officeName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${office.city}, ${office.state}',
                      style: AppTypography.labelSmall(
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${office.address} - ${office.pincode}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: office.phone));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Helpline ${office.phone} copied to clipboard',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: AppRadius.radiusS,
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      office.phone,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: office.website));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Portal link ${office.website} copied'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: AppRadius.radiusS,
                child: Row(
                  children: const [
                    Icon(
                      Icons.open_in_new,
                      size: 14,
                      color: AppColors.electricBlue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'State Portal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.electricBlue,
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
}
