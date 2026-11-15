import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/traffic_sign_entity.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/premium_card.dart';
import '../data/traffic_signs_data.dart';

class TrafficSignsScreen extends StatefulWidget {
  const TrafficSignsScreen({super.key});

  @override
  State<TrafficSignsScreen> createState() => _TrafficSignsScreenState();
}

class _TrafficSignsScreenState extends State<TrafficSignsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Traffic Signs & MV Act Fines',
        subtitle: 'Road Safety Rules & Penalties Handbook',
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Mandatory Signs'),
            Tab(text: 'Cautionary Signs'),
            Tab(text: 'Informatory Signs'),
            Tab(text: 'MV Act Fines'),
          ],
        ),
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
              hint: 'Search sign name, rule or offence...',
              prefixIcon: const Icon(Icons.search, size: 20),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase().trim()),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSignsList('Mandatory'),
                _buildSignsList('Cautionary'),
                _buildSignsList('Informatory'),
                _buildFinesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignsList(String category) {
    final filtered = TrafficSignsData.signs.where((s) {
      final matchesCat = s.category == category;
      if (!matchesCat) return false;
      if (_searchQuery.isEmpty) return true;
      return s.title.toLowerCase().contains(_searchQuery) ||
          s.description.toLowerCase().contains(_searchQuery) ||
          (s.fineForViolation?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();

    if (filtered.isEmpty) {
      return EmptyStateView(
        icon: Icons.traffic_rounded,
        title: 'No Signs Found',
        description: 'No $category signs matched "$_searchQuery".',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final sign = filtered[index];
        return _buildSignCard(sign);
      },
    );
  }

  Widget _buildSignCard(TrafficSignEntity sign) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color badgeBg;
    Color badgeFg;
    IconData icon;

    switch (sign.category) {
      case 'Mandatory':
        badgeBg = AppColors.error.withOpacity(0.12);
        badgeFg = AppColors.error;
        icon = Icons.do_not_disturb_on_outlined;
        break;
      case 'Cautionary':
        badgeBg = AppColors.warning.withOpacity(0.15);
        badgeFg = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      default:
        badgeBg = AppColors.electricBlue.withOpacity(0.12);
        badgeFg = AppColors.electricBlue;
        icon = Icons.info_outline;
        break;
    }

    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 10,
      accentColor: badgeFg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
            child: Icon(icon, color: badgeFg, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        sign.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: isDark ? Colors.white : AppColors.primaryNavy,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: AppRadius.radiusXs,
                      ),
                      child: Text(
                        sign.shape,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  sign.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.35,
                  ),
                ),
                if (sign.fineForViolation != null &&
                    sign.fineForViolation!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.gavel, size: 13, color: AppColors.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Fine: ${sign.fineForViolation}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinesList() {
    final filtered = TrafficSignsData.fines.where((f) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return f.offence.toLowerCase().contains(query) ||
          f.section.toLowerCase().contains(query) ||
          f.penalty.toLowerCase().contains(query) ||
          f.category.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return EmptyStateView(
        icon: Icons.gavel_rounded,
        title: 'No Penalties Found',
        description: 'No MV Act offence matched "$_searchQuery".',
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: AppSpacing.edgeInsetsL,
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return PremiumCard(
          padding: AppSpacing.edgeInsetsL,
          accentColor: AppColors.error,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.offence,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.electricBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.section,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.saffron,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.gavel_rounded,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.penalty,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
